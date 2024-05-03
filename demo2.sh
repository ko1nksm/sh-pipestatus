#!/bin/bash

. ./pipestatus.sh

set -o pipefail

echo "=== seq 100000 | cat | head >/dev/null ==="
seq 100000 | cat | head >/dev/null
echo "exit: $? (PIPESTATUS: ${PIPESTATUS[*]})"
echo

echo "=== igpipe seq 100000 | igpipe cat | head >/dev/null ==="
igpipe seq 100000 | igpipe cat | head >/dev/null
echo "exit: $? (PIPESTATUS: ${PIPESTATUS[*]})"
echo
