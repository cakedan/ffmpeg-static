#!/bin/bash

brew install \
    automake \
    frei0r \
    gcc \
    meson \
    nasm \
    ninja \
    openssl \
    sdl2 \
    wget \
    yasm

./build.sh "$@"
