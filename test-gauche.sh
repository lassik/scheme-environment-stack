#!/bin/sh
gosh -I . -e '(begin (import (scheme base) (scheme write) (envs)) (write (environment-stack)) (newline))'
