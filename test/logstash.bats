#!/usr/bin/env bats

setup() {
  :
}

teardown() {
  PID=$(pgrep java) || return 0
  pkill java
}

wait_for_message () {
  local message="$1"
  local logfile="$2"
  local timeout="$3"
  timeout -t "$timeout" -- sh -c "while ! grep -q '$message' '$logfile' ; do sleep 0.1; done"
  grep "$message" "$logfile"
}

wait_for_logstash () {
  /run-logstash.sh --verbose > $BATS_TEST_DIRNAME/logstash.log &
  wait_for_message "startup completed" "$BATS_TEST_DIRNAME/logstash.log" 400
}

@test "It should install logstash 2.1.3" {
  run /run-logstash.sh --version
  [[ "$output" =~ "logstash 2.1.3"  ]]
}

@test "It should listen over HTTP on port 80 for POSTs" {
  LOGSTASH_OUTPUT_CONFIG="stdout { codec => rubydebug }" wait_for_logstash
  run curl -XPOST http://localhost --data 'APTIBLE OK'
  run curl -XPUT http://localhost --data 'APTIBLE KO'

  run wait_for_message "APTIBLE OK" "$BATS_TEST_DIRNAME/logstash.log" 5
  [ "$status" -eq "0" ]

  run wait_for_message "APTIBLE KO" "$BATS_TEST_DIRNAME/logstash.log" 5
  [ "$status" -eq "1" ]
}

@test "It should be configurable through LOGSTASH_OUTPUT_CONFIG" {
  LOGSTASH_OUTPUT_CONFIG="file {path => '$BATS_TEST_DIRNAME/aptible.log' flush_interval => 0}" wait_for_logstash
  run curl -XPOST http://localhost --data 'APTIBLE OK'
  run wait_for_message "APTIBLE OK" "$BATS_TEST_DIRNAME/aptible.log" 5
  [ "$status" -eq "0" ]
}

@test "It should be configurable through LOGSTASH_FILTER_CONFIG" {
  LOGSTASH_OUTPUT_CONFIG="stdout { codec => rubydebug }" LOGSTASH_FILTER_CONFIG="if [message] == 'APTIBLE KO' { drop {} }" wait_for_logstash
  run curl -XPOST http://localhost --data 'APTIBLE OK'
  run curl -XPOST http://localhost --data 'APTIBLE KO'

  run wait_for_message "APTIBLE OK" "$BATS_TEST_DIRNAME/logstash.log" 5
  [ "$status" -eq "0" ]

  run wait_for_message "APTIBLE KO" "$BATS_TEST_DIRNAME/logstash.log" 5
  [ "$status" -eq "1" ]
}
