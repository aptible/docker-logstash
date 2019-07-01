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
  wait_for_message "Successfully started Logstash" "$BATS_TEST_DIRNAME/logstash.log" 400
}

@test "It should install logstash 6.7.0" {
  run /run-logstash.sh --version
  [[ "$output" =~ "logstash 6.7.0"  ]]
}

