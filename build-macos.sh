#!/bin/bash

brew install \
    openssl \
    frei0r \
    sdl2 \
    wget

./build.sh "$@"
