#!/bin/bash

brew install \
    frei0r \
    nasm \
    openssl \
    sdl2 \
    wget \
    yasm

./build.sh "$@"
