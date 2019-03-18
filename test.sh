#!/bin/bash
set -o errexit
set -o nounset

echo "Running bats tests"
docker run -i --entrypoint "bats" "$IMAGE" "/tmp/test"

echo "Test OK!"
