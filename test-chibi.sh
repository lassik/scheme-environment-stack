#!/bin/sh
chibi-scheme -I . -e '(import (envs))' -p '(environment-stack)'
