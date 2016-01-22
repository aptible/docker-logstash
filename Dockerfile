FROM quay.io/aptible/alpine

RUN apk update && apk-install curl openjdk7-jre-base ruby ca-certificates java-cacerts

# Actually ensure Java uses the trustore java-cacerts creates
RUN JAVA_TRUSTSTORE=/usr/lib/jvm/java-1.7-openjdk/jre/lib/security/cacerts \
 && SYSTEM_TRUSTSTORE=/etc/ssl/certs/java/cacerts \
 && rm "$JAVA_TRUSTSTORE" \
 && ln -s "$SYSTEM_TRUSTSTORE" "$JAVA_TRUSTSTORE"

# Install logstash
ENV LOGSTASH_VERSION 2.1.1
ENV LOGSTASH_SHA1 d71a6e015509030ab6012adcf79291994ece0b39

RUN curl -O https://download.elastic.co/logstash/logstash/logstash-${LOGSTASH_VERSION}.tar.gz && \
    echo "${LOGSTASH_SHA1}  logstash-${LOGSTASH_VERSION}.tar.gz" | sha1sum -c - && \
    tar zxf /logstash-${LOGSTASH_VERSION}.tar.gz

# Install logstash plugins
ADD bin/install-plugins.sh /install-plugins.sh
ADD logstash-plugins /logstash-plugins
RUN /install-plugins.sh

# Add logstash run scripts and configuration
ADD templates/logstash.config.erb /logstash.config.erb
ADD bin/run-logstash.sh /run-logstash.sh

## Run tests
ADD test /tmp/test
RUN bats /tmp/test

EXPOSE 80
CMD ["/bin/bash", "/run-logstash.sh"]
