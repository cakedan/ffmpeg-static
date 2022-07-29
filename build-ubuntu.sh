#!/bin/bash

sudo apt-get update
sudo apt-get -y install \
  autoconf \
  automake \
  build-essential \
  byacc \
  bzip2 \
  cmake \
  curl \
  flex \
  frei0r-plugins-dev \
  gawk \
  libass-dev \
  libfreetype6-dev \
  libopencore-amrnb-dev \
  libopencore-amrwb-dev \
  libsdl1.2-dev \
  libspeex-dev \
  libssl-dev \
  libtheora-dev \
  libtool \
  libva-dev \
  libvdpau-dev \
  libvo-amrwbenc-dev \
  libvorbis-dev \
  libwebp-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
  libxcb1-dev \
  libxvidcore-dev \
  libzstd-dev \
  meson \
  ninja-build \
  perl \
  pkg-config \
  sudo \
  tar \
  texi2html \
  wget \
  xz-utils \
  zlib1g-dev

./build.sh "$@"
