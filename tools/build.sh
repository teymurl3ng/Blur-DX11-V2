#!/bin/sh
# [Blur2PC] Standard x64 Release pipeline. Each subprocess propagates failure.
set -eu
cd "$(dirname "$0")/.."
exec python tools/build/build.py
