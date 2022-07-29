#!/bin/bash

# Fail if any command fails
set -e

# Define color codes
RED="\e[1;31m"
GREEN="\e[1;32m"
RESET="\e[0m"

verbose=false
download_only=false
uname -mpi | grep -qE 'x86|i386|i686' && is_x86=true || is_x86=false

while getopts 'vd' OPTION
do
  case $OPTION in
  v)
      verbose=true
      ;;
  d)
      download_only=true
      ;;
  ?)
      printf "Usage: %s: [-v] [-d]\n" "$(basename "$0")" >&2
      exit 2
      ;;
  esac
done
shift $((OPTIND - 1))

[ $is_x86 = false ] && echo "Not using yasm or nasm on non-x86 platform..."

cd "$(dirname "$0")"
ENV_ROOT=$(pwd)
. env.sh

mkdir -p "$BUILD_DIR" "$TARGET_DIR" "$DOWNLOAD_DIR" "$BIN_DIR"

# Download and extract the archive, renaming if necessary
download() {
  url="$1"
  filename="${2:-$(basename "$url" .tar.gz | xargs basename -s .tar.xz | xargs basename -s .tar.bz2)}"
  checksum="$3"

  archive=$(basename "$url")
  archive_path="${DOWNLOAD_DIR}/${archive}"
  builddir_path="${BUILD_DIR}/${filename}"

  _download() {
      echo -e "${GREEN}> Downloading $url...${RESET}"
      if ! curl -sfLm 600 -o "${archive_path}" "$url"; then
        echo -e "Couldn't download the file.\n"
        exit 1
      fi
      echo -e "${GREEN}> Checking the MD5 checksum of $archive...${RESET}"
      if [ "$(md5sum "${archive_path}" | cut -f 1 -d ' ')" != "$checksum" ]; then
        echo -e "${RED}Wrong checksum. Exiting.${RESET}"
        exit 1
      fi
      echo -e "${GREEN}> Unpacking $archive...${RESET}"
      mkdir -p "${builddir_path}"
      tar --strip-components=1 --overwrite -xf "${archive_path}" -C "${builddir_path}"
  }

  if [ -f "${archive_path}" ]; then
    echo -e "${GREEN}> Checking the MD5 checksum of $archive...${RESET}"
    if [ "$(md5sum "${archive_path}" | cut -f 1 -d ' ')" != "$checksum" ]; then
      _download
    else
      echo -e "${GREEN}> Unpacking $archive...${RESET}"
      mkdir -p "${builddir_path}"
      tar --strip-components=1 --overwrite -xf "${archive_path}" -C "${builddir_path}"
    fi
  else
    _download
  fi
}

cd "$BUILD_DIR"

[ $is_x86 = true ] && download \
  "http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz" \
  "" \
  "fc9e586751ff789b34b1f21d572d96af"

[ $is_x86 = true ] && download \
  "https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/nasm-2.15.05.tar.bz2" \
  "" \
  "b8985eddf3a6b08fc246c14f5889147c"

download \
  "https://github.com/openssl/openssl/archive/openssl-3.0.5.tar.gz" \
  "" \
  "22733b9187548b735201fd9f7aa12e71"

download \
  "https://github.com/madler/zlib/archive/v1.2.12.tar.gz" \
  "zlib-1.2.12" \
  "db5b7326d4e0dbcbd1981b640d495c9b"

download \
  "https://code.videolan.org/videolan/x264/-/archive/stable/x264-stable.tar.gz" \
  "libx264-stable" \
  "57bfbd990bea805b44c4785e64c6372f"

download \
  "http://download.openpkg.org/components/cache/x265/x265_3.4.tar.gz" \
  "libx265-3.4" \
  "e37b91c1c114f8815a3f46f039fe79b5"

download \
  "https://github.com/mstorsjo/fdk-aac/archive/v2.0.2.tar.gz" \
  "libfdk-aac-2.0.2" \
  "b15f56aebd0b4cfe8532b24ccfd8d11e"

# libass dependency
download \
  "https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-2.6.7.tar.xz" \
  "libharfbuzz-2.6.7" \
  "3b884586a09328c5fae76d8c200b0e1c"

download \
  "https://github.com/fribidi/fribidi/archive/v1.0.12.tar.gz" \
  "libfribidi-1.0.12" \
  "a7d87e1f323d43685c99614a204ea7e5"

download \
  "https://github.com/libass/libass/archive/0.16.0.tar.gz" \
  "libass-0.16.0" \
  "9603bb71804a27dee6776a8969ecdf1e"

download \
  "http://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz" \
  "libmp3lame-3.100" \
  "83e260acbe4389b54fe08e0bdbf7cddb"

download \
  "https://github.com/xiph/opus/archive/v1.3.1.tar.gz" \
  "libopus-1.3.1" \
  "b27f67923ffcbc8efb4ce7f29cbe3faf" \

download \
  "https://github.com/webmproject/libvpx/archive/v1.12.0.tar.gz" \
  "libvpx-1.12.0" \
  "10cf85debdd07be719a35ca3bfb8ea64"

download \
  "https://sourceforge.net/projects/soxr/files/soxr-0.1.3-Source.tar.xz" \
  "libsoxr-0.1.3" \
  "3f16f4dcb35b471682d4321eda6f6c08"

download \
  "https://github.com/georgmartius/vid.stab/archive/v1.1.0.tar.gz" \
  "libvidstab-1.1.0" \
  "633af54b7e2fd5734265ac7488ac263a"

download \
  "https://github.com/sekrit-twc/zimg/archive/release-3.0.4.tar.gz" \
  "libzimg-3.0.4" \
  "9ef18426caecf049d3078732411a9802"

download \
  "https://github.com/uclouvain/openjpeg/archive/v2.5.0.tar.gz" \
  "libopenjpeg-2.5.0" \
  "5cbb822a1203dd75b85639da4f4ecaab"

download \
  "https://github.com/webmproject/libwebp/archive/v1.2.3.tar.gz" \
  "libwebp-1.2.3" \
  "a9d3c93923ab0e5eab649a965b7b2bcd"

download \
  "https://github.com/xiph/vorbis/archive/v1.3.7.tar.gz" \
  "libvorbis-1.3.7" \
  "689dc495b22c5f08246c00dab35f1dc7"

download \
  "https://github.com/xiph/ogg/archive/v1.3.5.tar.gz" \
  "libogg-1.3.5" \
  "52b33b31dfff09a89ad1bc07248af0bd"

download \
  "https://github.com/xiph/speex/archive/Speex-1.2.1.tar.gz" \
  "libspeex-1.2.1" \
  "2872f3c3bf867dbb0b63d06762f4b493"

download \
  "https://www.ffmpeg.org/releases/ffmpeg-5.1.tar.xz" \
  "" \
  "efd690ec82772073fd9d3ae83ca615da"

[ $download_only = true ] && exit 0

# Print the message about what library is
# being built and enter its build directory
building() {
  echo -e "\n${GREEN}> Building $1...${RESET}\n"
  cd "$BUILD_DIR"/"$1"*
}

# Override `make` calls
if [ $verbose = true ]; then
  make() {
    command make "$@"
  }
else
  make() {
    command make "$@" >/dev/null
  }
fi

# Override `configure` calls
if [ $verbose = true ]; then
  configure() {
    ./configure --prefix="$TARGET_DIR" "$@"
  }
else
  configure() {
    ./configure --prefix="$TARGET_DIR" "$@" >/dev/null
  }
fi

if [ $is_x86 = true ]; then
    building yasm
    [ ! -f config.status ] && configure --bindir="$BIN_DIR"
    make
    make install
fi

if [ $is_x86 = true ]; then
    building nasm
    [ ! -f config.status ] && configure --bindir="$BIN_DIR"
    make
    make install
fi

building openssl
PATH="$BIN_DIR:$PATH" ./config --prefix="$TARGET_DIR"
PATH="$BIN_DIR:$PATH" make
make install

building zlib
[ ! -f config.status ] && PATH="$BIN_DIR:$PATH" configure
PATH="$BIN_DIR:$PATH" make
make install

building libx264
[ ! -f config.status ] && PATH="$BIN_DIR:$PATH" configure --enable-static --disable-opencl --enable-pic
PATH="$BIN_DIR:$PATH" make
make install

building libx265
cd build/linux
PATH="$BIN_DIR:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DENABLE_SHARED:BOOL=OFF -DSTATIC_LINK_CRT:BOOL=ON -DENABLE_CLI:BOOL=OFF ../../source
sed -i 's/-lgcc_s/-lgcc_eh/g' x265.pc
make
make install

building libfdk-aac
autoreconf -fiv
[ ! -f config.status ] && configure --disable-shared
make
make install

building libharfbuzz
configure --disable-shared --enable-static
make
make install

building libfribidi
meson -Dprefix="$TARGET_DIR" -Ddocs=false --default-library=static --backend=ninja build
ninja -C build
ninja -C build install

building libass
./autogen.sh
configure --disable-shared
make
make install

building libmp3lame
# The lame build script does not recognize aarch64, so need to set it manually
uname -a | grep -q 'aarch64' && lame_build_target="--build=arm-linux" || lame_build_target=''
[ ! -f config.status ] && configure --enable-nasm --disable-shared "$lame_build_target"
make
make install

building libopus
./autogen.sh
configure --disable-shared
make
make install

building libvpx
[ ! -f config.status ] && PATH="$BIN_DIR:$PATH" configure --disable-examples --disable-unit-tests --enable-pic
PATH="$BIN_DIR:$PATH" make
make install

building libsoxr
PATH="$BIN_DIR:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DBUILD_SHARED_LIBS:bool=off -DWITH_OPENMP:bool=off -DBUILD_TESTS:bool=off
make
make install

building libvidstab
PATH="$BIN_DIR:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DBUILD_SHARED_LIBS:bool=off
make
make install

building libopenjpeg
PATH="$BIN_DIR:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DBUILD_SHARED_LIBS:bool=off
make
make install

building libzimg
./autogen.sh
configure --enable-static --disable-shared
make
make install

building libwebp
./autogen.sh
configure --disable-shared
make
make install

building libvorbis
./autogen.sh
configure --disable-shared
make
make install

building libogg
./autogen.sh
configure --disable-shared
make
make install

building libspeex
./autogen.sh
configure --disable-shared
make
make install

building ffmpeg
FEATURES=(
  --enable-ffplay
  --enable-fontconfig
  --enable-frei0r
  --enable-gpl
  --enable-libass
  --enable-libfdk-aac
  --enable-libfreetype
  --enable-libfribidi
  --enable-libmp3lame
  --enable-libopencore-amrnb
  --enable-libopencore-amrwb
  --enable-libopenjpeg
  --enable-libopus
  --enable-libsoxr
  --enable-libspeex
  --enable-libtheora
  --enable-libvidstab
  --enable-libvo-amrwbenc
  --enable-libvorbis
  --enable-libvpx
  --enable-libwebp
  --enable-libx264
  --enable-libx265
  --enable-libxvid
  --enable-libzimg
  --enable-nonfree
  --enable-openssl
  --enable-pic
  --enable-version3
)
if ! \
  PATH="$BIN_DIR:$PATH" \
  PKG_CONFIG_PATH="$TARGET_DIR/lib/pkgconfig" \
  configure \
  "${FEATURES[@]}" \
  --bindir="$BIN_DIR" \
  --extra-cflags="-I$TARGET_DIR/include" \
  --extra-ldexeflags="-static" \
  --extra-ldflags="-L$TARGET_DIR/lib" \
  --extra-libs="-lpthread -lm -lz" \
  --pkg-config-flags="--static"
then
  cat ffbuild/config.log
fi
PATH="$BIN_DIR:$PATH" make
make install
make distclean
hash -r
