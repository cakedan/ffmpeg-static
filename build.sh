#!/bin/bash

set -e
set -u

jflag=()
rebuild=0
download_only=0
uname -mpi | grep -qE 'x86|i386|i686' && is_x86=1 || is_x86=0

while getopts 'j:Bd' OPTION
do
  case $OPTION in
  j)
      jflag=(-j "$OPTARG")
      ;;
  B)
      rebuild=1
      ;;
  d)
      download_only=1
      ;;
  ?)
      printf "Usage: %s: [-j concurrency_level] (hint: your cores + 20%%) [-B] [-d]\n" "$(basename "$0")" >&2
      exit 2
      ;;
  esac
done
shift $((OPTIND - 1))

[ "$rebuild" -eq 1 ] && echo "Reconfiguring existing packages..."
[ $is_x86 -ne 1 ] && echo "Not using yasm or nasm on non-x86 platform..."

cd "$(dirname "$0")"
ENV_ROOT=$(pwd)
. ./env.source

# check operating system
OS=$(uname)
platform="unknown"

case $OS in
  'Darwin')
    platform='darwin'
    ;;
  'Linux')
    platform='linux'
    ;;
esac

#if you want a rebuild
#rm -rf "$BUILD_DIR" "$TARGET_DIR"
mkdir -p "$BUILD_DIR" "$TARGET_DIR" "$DOWNLOAD_DIR" "$BIN_DIR"

# Download and extract the archive
download() {
  filename="$1"
  if [ -n "$2" ]; then
    filename="$2"
  fi
  ../download.pl "$DOWNLOAD_DIR" "$1" "$filename" "$3" "$4"
  #disable uncompress
  REPLACE="$rebuild" CACHE_DIR="$DOWNLOAD_DIR" ../fetchurl "http://cache/$filename"
}

echo "#### FFmpeg static build ####"

#this is our working directory
cd "$BUILD_DIR"

[ $is_x86 -eq 1 ] && download \
  "yasm-1.3.0.tar.gz" \
  "" \
  "fc9e586751ff789b34b1f21d572d96af" \
  "http://www.tortall.net/projects/yasm/releases/"

[ $is_x86 -eq 1 ] && download \
  "nasm-2.15.05.tar.bz2" \
  "" \
  "b8985eddf3a6b08fc246c14f5889147c" \
  "https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/"

download \
  "openssl-3.0.5.tar.gz" \
  "" \
  "22733b9187548b735201fd9f7aa12e71" \
  "https://github.com/openssl/openssl/archive/"

download \
  "v1.2.12.tar.gz" \
  "zlib-1.2.12.tar.gz" \
  "db5b7326d4e0dbcbd1981b640d495c9b" \
  "https://github.com/madler/zlib/archive/"

download \
  "x264-stable.tar.gz" \
  "" \
  "nil" \
  "https://code.videolan.org/videolan/x264/-/archive/stable/"

download \
  "x265_3.4.tar.gz" \
  "x265-3.4.tar.gz" \
  "e37b91c1c114f8815a3f46f039fe79b5" \
  "http://download.openpkg.org/components/cache/x265/"

download \
  "v2.0.2.tar.gz" \
  "fdk-aac-2.0.2.tar.gz" \
  "b15f56aebd0b4cfe8532b24ccfd8d11e" \
  "https://github.com/mstorsjo/fdk-aac/archive/"

# libass dependency
download \
  "harfbuzz-2.6.7.tar.xz" \
  "" \
  "3b884586a09328c5fae76d8c200b0e1c" \
  "https://www.freedesktop.org/software/harfbuzz/release/"

# fribidi dependency
download \
  "577ed40.tar.gz" \
  "c2man-577ed40.tar.gz" \
  "5cf6e5056385e6d173a44d600faa1f8d" \
  "https://github.com/fribidi/c2man/archive/"

download \
  "v1.0.12.tar.gz" \
  "fribidi-1.0.12.tar.gz" \
  "a7d87e1f323d43685c99614a204ea7e5" \
  "https://github.com/fribidi/fribidi/archive/"

download \
  "0.16.0.tar.gz" \
  "libass-0.16.0.tar.gz" \
  "9603bb71804a27dee6776a8969ecdf1e" \
  "https://github.com/libass/libass/archive/"

download \
  "lame-3.100.tar.gz" \
  "" \
  "83e260acbe4389b54fe08e0bdbf7cddb" \
  "http://downloads.sourceforge.net/project/lame/lame/3.100/"

download \
  "v1.3.1.tar.gz" \
  "opus-1.3.1.tar.gz" \
  "b27f67923ffcbc8efb4ce7f29cbe3faf" \
  "https://github.com/xiph/opus/archive/"

download \
  "v1.12.0.tar.gz" \
  "vpx-1.12.0.tar.gz" \
  "10cf85debdd07be719a35ca3bfb8ea64" \
  "https://github.com/webmproject/libvpx/archive/"

download \
  "soxr-0.1.3-Source.tar.xz" \
  "soxr-0.1.3.tar.xz" \
  "3f16f4dcb35b471682d4321eda6f6c08" \
  "https://sourceforge.net/projects/soxr/files/"

download \
  "v1.1.0.tar.gz" \
  "vid.stab-1.1.0.tar.gz" \
  "633af54b7e2fd5734265ac7488ac263a" \
  "https://github.com/georgmartius/vid.stab/archive/"

download \
  "release-3.0.4.tar.gz" \
  "zimg-3.0.4.tar.gz" \
  "9ef18426caecf049d3078732411a9802" \
  "https://github.com/sekrit-twc/zimg/archive/"

download \
  "v2.5.0.tar.gz" \
  "openjpeg-2.5.0.tar.gz" \
  "5cbb822a1203dd75b85639da4f4ecaab" \
  "https://github.com/uclouvain/openjpeg/archive/"

download \
  "v1.2.3.tar.gz" \
  "libwebp-1.2.3.tar.gz" \
  "a9d3c93923ab0e5eab649a965b7b2bcd" \
  "https://github.com/webmproject/libwebp/archive/"

download \
  "v1.3.7.tar.gz" \
  "vorbis-1.3.7.tar.gz" \
  "689dc495b22c5f08246c00dab35f1dc7" \
  "https://github.com/xiph/vorbis/archive/"

download \
  "v1.3.5.tar.gz" \
  "ogg-1.3.5.tar.gz" \
  "52b33b31dfff09a89ad1bc07248af0bd" \
  "https://github.com/xiph/ogg/archive/"

download \
  "Speex-1.2.1.tar.gz" \
  "speex-1.2.1.tar.gz" \
  "2872f3c3bf867dbb0b63d06762f4b493" \
  "https://github.com/xiph/speex/archive/"

download \
  "ffmpeg-5.1.tar.xz" \
  "" \
  "efd690ec82772073fd9d3ae83ca615da" \
  "https://www.ffmpeg.org/releases/"

[ $download_only -eq 1 ] && exit 0

# Print the message about what library is being built
building() {
  echo -e "\e[1;32mBuilding $1...\e[0m"
}

# Add extra arguments to the `make` calls
make() {
  command make ${jflag[@]+"${jflag[@]}"} "$@" >/dev/null
}

if [ $is_x86 -eq 1 ]; then
    building yasm
    cd "$BUILD_DIR"/yasm-*
    [ $rebuild -eq 1 ] && [ -f Makefile ] && make distclean
    [ ! -f config.status ] && ./configure -q --prefix="$TARGET_DIR" --bindir="$BIN_DIR"
    make
    make install
fi

if [ $is_x86 -eq 1 ]; then
    building nasm
    cd "$BUILD_DIR"/nasm-*
    [ $rebuild -eq 1 ] && [ -f Makefile ] && make distclean
    [ ! -f config.status ] && ./configure -q --prefix="$TARGET_DIR" --bindir="$BIN_DIR"
    make
    make install
fi

building OpenSSL
cd "$BUILD_DIR"/openssl-*
[ $rebuild -eq 1 ] && [ -f Makefile ] && make distclean
if [ "$platform" = "darwin" ]; then
  PATH="$BIN_DIR:$PATH" ./Configure darwin64-x86_64-cc --prefix="$TARGET_DIR"
elif [ "$platform" = "linux" ]; then
  PATH="$BIN_DIR:$PATH" ./config --prefix="$TARGET_DIR"
fi
PATH="$BIN_DIR:$PATH" make
make install

building zlib
cd "$BUILD_DIR"/zlib-*
[ $rebuild -eq 1 ] && [ -f Makefile ] && make distclean
if [ "$platform" = "linux" ]; then
  [ ! -f config.status ] && PATH="$BIN_DIR:$PATH" ./configure --prefix="$TARGET_DIR"
elif [ "$platform" = "darwin" ]; then
  [ ! -f config.status ] && PATH="$BIN_DIR:$PATH" ./configure --prefix="$TARGET_DIR"
fi
PATH="$BIN_DIR:$PATH" make
make install

building x264
cd "$BUILD_DIR"/x264-*
[ $rebuild -eq 1 ] && [ -f Makefile ] && make distclean
[ ! -f config.status ] && PATH="$BIN_DIR:$PATH" ./configure --prefix="$TARGET_DIR" --enable-static --disable-opencl --enable-pic
PATH="$BIN_DIR:$PATH" make
make install

building x265
cd "$BUILD_DIR"/x265*
cd build/linux
[ $rebuild -eq 1 ] && find . -mindepth 1 ! -name 'make-Makefiles.bash' -and ! -name 'multilib.sh' -exec rm -r {} +
PATH="$BIN_DIR:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DENABLE_SHARED:BOOL=OFF -DSTATIC_LINK_CRT:BOOL=ON -DENABLE_CLI:BOOL=OFF ../../source
if [ "$platform" = "linux" ]; then
  sed -i 's/-lgcc_s/-lgcc_eh/g' x265.pc
elif [ "$platform" = "darwin" ]; then
  sed -i "" 's/-lgcc_s/-lgcc_eh/g' x265.pc
fi
make
make install

building fdk-aac
cd "$BUILD_DIR"/fdk-aac-*
[ $rebuild -eq 1 ] && [ -f Makefile ] && make distclean
autoreconf -fiv
[ ! -f config.status ] && ./configure -q --prefix="$TARGET_DIR" --disable-shared
make
make install

building harfbuzz
cd "$BUILD_DIR"/harfbuzz-*
[ $rebuild -eq 1 ] && [ -f Makefile ] && make distclean
./configure -q --prefix="$TARGET_DIR" --disable-shared --enable-static
make
make install

building c2man
cd "$BUILD_DIR"/c2man-*
[ $rebuild -eq 1 ] && [ -f Makefile ] && make distclean
./Configure -dE
echo "binexp=${BIN_DIR}
installprivlib=${BIN_DIR}
mansrc=${BIN_DIR}" >> config.sh
sh config_h.SH
sh flatten.SH
sh Makefile.SH
make depend
make
make install

building fribidi
cd "$BUILD_DIR"/fribidi-*
[ $rebuild -eq 1 ] && [ -f Makefile ] && make distclean
./autogen.sh
./configure -q --prefix="$TARGET_DIR" --disable-shared --enable-static --disable-docs
PATH="$BIN_DIR:$PATH" make "${jflag[@]}"
make install

building libass
cd "$BUILD_DIR"/libass-*
[ $rebuild -eq 1 ] && [ -f Makefile ] && make distclean
./autogen.sh
./configure -q --prefix="$TARGET_DIR" --disable-shared
make
make install

building mp3lame
cd "$BUILD_DIR"/lame-*
# The lame build script does not recognize aarch64, so need to set it manually
uname -a | grep -q 'aarch64' && lame_build_target="--build=arm-linux" || lame_build_target=''
[ $rebuild -eq 1 ] && [ -f Makefile ] && make distclean
[ ! -f config.status ] && ./configure -q --prefix="$TARGET_DIR" --enable-nasm --disable-shared "$lame_build_target"
make
make install

building opus
cd "$BUILD_DIR"/opus-*
[ $rebuild -eq 1 ] && [ -f Makefile ] && make distclean
./autogen.sh
./configure -q --prefix="$TARGET_DIR" --disable-shared
make
make install

building libvpx
cd "$BUILD_DIR"/libvpx-*
[ $rebuild -eq 1 ] && [ -f Makefile ] && make distclean
[ ! -f config.status ] && PATH="$BIN_DIR:$PATH" ./configure --prefix="$TARGET_DIR" --disable-examples --disable-unit-tests --enable-pic
PATH="$BIN_DIR:$PATH" make
make install

building libsoxr
cd "$BUILD_DIR"/soxr-*
[ $rebuild -eq 1 ] && [ -f Makefile ] && make distclean
PATH="$BIN_DIR:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DBUILD_SHARED_LIBS:bool=off -DWITH_OPENMP:bool=off -DBUILD_TESTS:bool=off
make
make install

building libvidstab
cd "$BUILD_DIR"/vid.stab-*
[ $rebuild -eq 1 ] && [ -f Makefile ] && make distclean
if [ "$platform" = "linux" ]; then
  sed -i "s/vidstab SHARED/vidstab STATIC/" ./CMakeLists.txt
elif [ "$platform" = "darwin" ]; then
  sed -i "" "s/vidstab SHARED/vidstab STATIC/" ./CMakeLists.txt
fi
PATH="$BIN_DIR:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DBUILD_SHARED_LIBS:bool=off
make
make install

building openjpeg
cd "$BUILD_DIR"/openjpeg-*
[ $rebuild -eq 1 ] && [ -f Makefile ] && make distclean
PATH="$BIN_DIR:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DBUILD_SHARED_LIBS:bool=off
make
make install

building zimg
cd "$BUILD_DIR"/zimg-release-*
[ $rebuild -eq 1 ] && [ -f Makefile ] && make distclean
./autogen.sh
./configure -q --enable-static  --prefix="$TARGET_DIR" --disable-shared
make
make install

building libwebp
cd "$BUILD_DIR"/libwebp-*
[ $rebuild -eq 1 ] && [ -f Makefile ] && make distclean
./autogen.sh
./configure -q --prefix="$TARGET_DIR" --disable-shared
make
make install

building libvorbis
cd "$BUILD_DIR"/vorbis-*
[ $rebuild -eq 1 ] && [ -f Makefile ] && make distclean
./autogen.sh
./configure -q --prefix="$TARGET_DIR" --disable-shared
make
make install

building libogg
cd "$BUILD_DIR"/ogg-*
[ $rebuild -eq 1 ] && [ -f Makefile ] && make distclean
./autogen.sh
./configure -q --prefix="$TARGET_DIR" --disable-shared
make
make install

building libspeex
cd "$BUILD_DIR"/speex-*
[ $rebuild -eq 1 ] && [ -f Makefile ] && make distclean
./autogen.sh
./configure -q --prefix="$TARGET_DIR" --disable-shared
make
make install

building FFmpeg
cd "$BUILD_DIR"/ffmpeg-*
[ $rebuild -eq 1 ] && [ -f Makefile ] && make distclean
if [ "$platform" = "linux" ]; then
  [ ! -f config.status ] && PATH="$BIN_DIR:$PATH" \
  PKG_CONFIG_PATH="$TARGET_DIR/lib/pkgconfig" ./configure -q \
    --prefix="$TARGET_DIR" \
    --pkg-config-flags="--static" \
    --extra-cflags="-I$TARGET_DIR/include" \
    --extra-ldflags="-L$TARGET_DIR/lib" \
    --extra-libs="-lpthread -lm -lz" \
    --extra-ldexeflags="-static" \
    --bindir="$BIN_DIR" \
    --enable-pic \
    --enable-ffplay \
    --enable-fontconfig \
    --enable-frei0r \
    --enable-gpl \
    --enable-version3 \
    --enable-libass \
    --enable-libfribidi \
    --enable-libfdk-aac \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libopencore-amrnb \
    --enable-libopencore-amrwb \
    --enable-libopenjpeg \
    --enable-libopus \
    --enable-libsoxr \
    --enable-libspeex \
    --enable-libtheora \
    --enable-libvidstab \
    --enable-libvo-amrwbenc \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libwebp \
    --enable-libx264 \
    --enable-libx265 \
    --enable-libxvid \
    --enable-libzimg \
    --enable-nonfree \
    --enable-openssl
elif [ "$platform" = "darwin" ]; then
  [ ! -f config.status ] && PATH="$BIN_DIR:$PATH" \
  PKG_CONFIG_PATH="${TARGET_DIR}/lib/pkgconfig:/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig" ./configure -q \
    --cc=/usr/bin/clang \
    --prefix="$TARGET_DIR" \
    --pkg-config-flags="--static" \
    --extra-cflags="-I$TARGET_DIR/include" \
    --extra-ldflags="-L$TARGET_DIR/lib" \
    --extra-ldexeflags="-Bstatic" \
    --bindir="$BIN_DIR" \
    --enable-pic \
    --enable-ffplay \
    --enable-fontconfig \
    --enable-frei0r \
    --enable-gpl \
    --enable-version3 \
    --enable-libass \
    --enable-libfribidi \
    --enable-libfdk-aac \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libopencore-amrnb \
    --enable-libopencore-amrwb \
    --enable-libopenjpeg \
    --enable-libopus \
    --enable-libsoxr \
    --enable-libspeex \
    --enable-libvidstab \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libwebp \
    --enable-libx264 \
    --enable-libx265 \
    --enable-libxvid \
    --enable-libzimg \
    --enable-nonfree \
    --enable-openssl
fi
PATH="$BIN_DIR:$PATH" make
make install
make distclean
hash -r
