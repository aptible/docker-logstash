FROM quay.io/aptible/alpine:3.3

RUN apk-install curl openjdk7-jre-base ruby ca-certificates java-cacerts git

# Actually ensure Java uses the trustore java-cacerts creates
RUN JAVA_TRUSTSTORE=/usr/lib/jvm/java-1.7-openjdk/jre/lib/security/cacerts \
 && SYSTEM_TRUSTSTORE=/etc/ssl/certs/java/cacerts \
 && rm "$JAVA_TRUSTSTORE" \
 && ln -s "$SYSTEM_TRUSTSTORE" "$JAVA_TRUSTSTORE"

# Install logstash
ENV LOGSTASH_VERSION 2.1.3
ENV LOGSTASH_SHA1 283f6d8842df52c7d69f77b5c6d4755ee942b291

RUN curl -O https://download.elastic.co/logstash/logstash/logstash-${LOGSTASH_VERSION}.tar.gz && \
    echo "${LOGSTASH_SHA1}  logstash-${LOGSTASH_VERSION}.tar.gz" | sha1sum -c - && \
    tar zxf "/logstash-${LOGSTASH_VERSION}.tar.gz" && \
    rm "/logstash-${LOGSTASH_VERSION}.tar.gz"

# Blow away the existing elasticsearch plugin so we can instal our version instead.
RUN rm -rf /logstash-2.1.3/vendor/bundle/jruby/1.9/gems/logstash-output-elasticsearch-2.4.1-java

# Install logstash plugins. We need --no-verify to install Aptible Gems.
ADD Gemfile /logstash-${LOGSTASH_VERSION}/Gemfile
RUN "/logstash-${LOGSTASH_VERSION}/bin/plugin" install --no-verify

# Add logstash run scripts and configuration
ADD templates/logstash.config.erb /logstash.config.erb
ADD bin/run-logstash.sh /run-logstash.sh
ADD bin/checkconfig.sh /logstash-checkconfig.sh

# Add tests. Those won't run as part of the build because customers don't need to run
# them when deploying, but they'll be run in test.sh
ADD test /tmp/test

EXPOSE 80
CMD ["/run-logstash.sh"]
