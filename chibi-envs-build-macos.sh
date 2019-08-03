#!/bin/sh
set -eu
cd "$(dirname "$0")"
echo "Entering directory '$PWD'"
set -x
chibi-ffi chibi-envs.stub
${CC:-clang} \
    -std=c99 -Wall -Wextra -Wno-unused-parameter \
    -lchibi-scheme \
    -fPIC -shared -o chibi-envs.dylib chibi-envs.c
