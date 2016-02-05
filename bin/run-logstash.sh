#!/bin/bash
set -o errexit
set -o nounset

erb /logstash.config.erb > /logstash-${LOGSTASH_VERSION}/logstash.config

cd /logstash-${LOGSTASH_VERSION}
exec bin/logstash -f logstash.config "$@"
