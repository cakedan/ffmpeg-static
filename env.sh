#!/bin/bash

# Source this shell script to get the same environment as the build script

if [ -z "$ENV_ROOT" ]; then
  ENV_ROOT=$(pwd)
  export ENV_ROOT
fi

if [ "${ENV_ROOT#/}" = "$ENV_ROOT" ]; then
  echo "ENV_ROOT must be an absolute path" >&2
else
  BUILD_DIR="${BUILD_DIR:-$ENV_ROOT/build}"
  TARGET_DIR="${TARGET_DIR:-$ENV_ROOT/target}"
  DOWNLOAD_DIR="${DOWNLOAD_DIR:-$ENV_ROOT/dl}"
  BIN_DIR="${BIN_DIR:-$ENV_ROOT/bin}"
  export PATH="$BIN_DIR:$PATH"
  export PKG_CONFIG_PATH="$TARGET_DIR/lib/pkgconfig:$TARGET_DIR/lib64/pkgconfig"
fi
