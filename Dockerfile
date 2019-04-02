FROM quay.io/aptible/alpine:3.3

RUN apk-install curl openjdk8-jre-base ruby ca-certificates java-cacerts git

# Actually ensure Java uses the trustore java-cacerts creates
RUN JAVA_TRUSTSTORE=/usr/lib/jvm/java-1.8-openjdk/jre/lib/security/cacerts \
 && SYSTEM_TRUSTSTORE=/etc/ssl/certs/java/cacerts \
 && rm "$JAVA_TRUSTSTORE" \
 && ln -s "$SYSTEM_TRUSTSTORE" "$JAVA_TRUSTSTORE"

# Install logstash
ENV LOGSTASH_VERSION 6.7.0
ENV LOGSTASH_PLUGIN_VERSION 9.4.0
ENV LOGSTASH_SHA1 e90ff327b738f7b98984632d65b812df1cd84a62

RUN curl -O https:/artifacts.elastic.co/downloads/logstash/logstash-${LOGSTASH_VERSION}.tar.gz && \
    echo "${LOGSTASH_SHA1}  logstash-${LOGSTASH_VERSION}.tar.gz" | sha1sum -c - && \
    tar zxf "/logstash-${LOGSTASH_VERSION}.tar.gz" && \
    rm "/logstash-${LOGSTASH_VERSION}.tar.gz"

# Add logstash run scripts and configuration
ADD templates/logstash.config.erb /logstash.config.erb
ADD bin/run-logstash.sh /run-logstash.sh
ADD bin/checkconfig.sh /logstash-checkconfig.sh

# Add tests. Those won't run as part of the build because customers don't need to run
# them when deploying, but they'll be run in test.sh
ADD test /tmp/test

EXPOSE 80
CMD ["/run-logstash.sh"]
