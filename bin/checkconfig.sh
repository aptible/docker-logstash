#!/bin/bash
set -o errexit
set -o nounset

TEST_CONFIG_FILE="$(mktemp)"
trap 'rm -f "$TEST_CONFIG_FILE"' EXIT

echo "Testing configuration"
erb /logstash.config.erb > "$TEST_CONFIG_FILE"

if "/logstash-${LOGSTASH_VERSION}/bin/logstash" -f "$TEST_CONFIG_FILE" --configtest; then
  echo "Deploying!"
  exit 0
else
  echo "Aborting deploy!"
  exit 1
fi
