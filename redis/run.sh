#!/bin/bash

(
    sleep 5
    echo 'CONFIG Set "requirePass" ""' | redis-cli
) & 

redis-server ${HOME}/redis.conf
# redis://localhost:6379/dev"