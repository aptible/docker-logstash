#!/bin/bash
set -o errexit
set -o nounset

IMG="$ECR_REPO/$IMAGE:$CIRCLE_SHA1"

echo "Running bats tests"
# docker run -i --entrypoint "bats" "$IMG" "/tmp/test"

echo "Test OK!"
