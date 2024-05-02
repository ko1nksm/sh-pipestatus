#!/bin/sh

. ./pipestatus.sh

set -- "hello world"

echo "=== pipestatus ==="
pipe 'echo "$1" | grep e | { cat; exit 12; } | tr a-z A-Z' "$@"
echo "$? (PIPESTS: $PIPESTS)" # => 1 (PIPESTS: 0 1 0)
echo

echo "=== pipefail ==="
pipe -fail 'echo "$1" | grep e | { cat; exit 12; } | tr a-z A-Z' "$@"
echo "$? (PIPESTS: $PIPESTS)" # => 1 (PIPESTS: 0 1 0)
echo

set -e

echo "=== pipestatus (set -e) ==="
pipe 'echo "$1" | grep e | { cat; exit 12; } | tr a-z A-Z' "$@"
echo "$? (PIPESTS: $PIPESTS)" # => 1 (PIPESTS: 0 1 0)
echo

echo "=== pipefail (set -e) ==="
pipe -fail 'echo "$1" | grep e | { cat; exit 12; } | tr a-z A-Z' "$@"
echo "$? (PIPESTS: $PIPESTS)" # => 1 (PIPESTS: 0 1 0)


