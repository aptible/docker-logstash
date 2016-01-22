#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

cat /logstash-plugins | while read plugin_name; do
    if [[ "${plugin_name}" = \#* ]]; then
    # This is a comment
    continue
  fi

  echo "Installing logstash plugin: ${plugin_name}"
  /logstash-${LOGSTASH_VERSION}/bin/plugin install ${plugin_name}
done
