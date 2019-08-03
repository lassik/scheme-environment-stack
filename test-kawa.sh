#!/bin/sh
kawa -e '(require envs "envs.sld")' -e '(write (environment-stack))'
