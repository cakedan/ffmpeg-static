#!/bin/bash

# Fail if any command fails
set -e

# Define color codes
RED="\e[1;31m"
GREEN="\e[1;32m"
RESET="\e[0m"

# Set default values of the options
download_only=false

# Parse the options
while getopts 'd' OPTION
do
  case $OPTION in
  d)
      download_only=true
      ;;
  ?)
      printf "Usage: %s: [-d]\n" "$(basename "$0")" >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))

# Set up the environment
cd "$(dirname "$0")"
ENV_ROOT=$(pwd)
. env.sh

# Create additional directories
mkdir -p "$BUILD_DIR" "$TARGET_DIR" "$DOWNLOAD_DIR" "$BIN_DIR"

# Download and extract the archive, renaming if necessary
download() {
  url="$1"
  filename="${2:-$(basename "$url" | sed -r 's/(.*)\.tar\..*/\1/')}"
  checksum="$3"

  archive=$filename$(basename "${url}" | sed -r 's/.*\.tar\.(.*)/.tar.\1/')
  archive_path="${DOWNLOAD_DIR}/${archive}"
  builddir_path="${BUILD_DIR}/${filename}"

  unpack() {
    echo -e "${GREEN}> Unpacking $archive...${RESET}"
    mkdir -p "${builddir_path}"
    if [ "$(tar -t --exclude='*/*' -f "${archive_path}" | wc -l)" -le 1 ]; then
      tar --strip-components=1 --overwrite -xf "${archive_path}" -C "${builddir_path}"
    else
      tar --overwrite -xf "${archive_path}" -C "${builddir_path}"
    fi
  }

  _download() {
    echo -e "${GREEN}> Downloading $url...${RESET}"
    if ! curl -sfLm 600 -o "${archive_path}" "$url"; then
      echo -e "${RED}> Couldn't download the file. Exiting.${RESET}\n"
      exit 2
    fi
    if [ -n "${checksum}" ]; then
      echo -e "${GREEN}> Checking the MD5 checksum of $archive...${RESET}"
      if [ "$(md5sum "${archive_path}" | cut -f 1 -d ' ')" != "$checksum" ]; then
        echo -e "${RED}> Wrong checksum. Exiting.${RESET}"
        exit 3
      fi
    fi
    unpack
  }

  if [ -f "${archive_path}" ]; then
    if [ -n "${checksum}" ]; then
      echo -e "${GREEN}> Checking the MD5 checksum of $archive...${RESET}"
      if [ "$(md5sum "${archive_path}" | cut -f 1 -d ' ')" != "$checksum" ]; then
        _download
      else
        unpack
      fi
    else
      unpack
    fi
  else
    _download
  fi
}

cd "$BUILD_DIR"

download \
  "https://github.com/openssl/openssl/archive/openssl-3.0.5.tar.gz" \
  "" \
  "22733b9187548b735201fd9f7aa12e71"

download \
  "https://code.videolan.org/videolan/x264/-/archive/baee400fa9ced6f5481a728138fed6e867b0ff7f/x264-baee400fa9ced6f5481a728138fed6e867b0ff7f.tar.gz" \
  "libx264-baee400f" \
  "33d20c2955efb3352b32cfbd4fe966e8"

download \
  "http://download.openpkg.org/components/cache/x265/x265_3.4.tar.gz" \
  "libx265-3.4" \
  "e37b91c1c114f8815a3f46f039fe79b5"

download \
  "https://github.com/mstorsjo/fdk-aac/archive/v2.0.2.tar.gz" \
  "libfdk-aac-2.0.2" \
  "b15f56aebd0b4cfe8532b24ccfd8d11e"

download \
  "https://github.com/harfbuzz/harfbuzz/archive/5.3.0.tar.gz" \
  "libharfbuzz-5.3.0" \
  "485af70c103ecab6c4c639cc62d813ba"

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
  "https://github.com/webmproject/libwebp/archive/v1.2.4.tar.gz" \
  "libwebp-1.2.4" \
  "4f08244f88a39816c3e0719ca16c7a92"

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
  "https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.14.0.tar.xz" \
  "" \
  "e12700a9d522bdfec06b6b7e72646987"

download \
  "https://github.com/google/brotli/archive/refs/tags/v1.0.9.tar.gz" \
  "libbrotli-1.0.9" \
  "c2274f0c7af8470ad514637c35bcee7d"

download \
  "https://download.savannah.gnu.org/releases/freetype/freetype-2.12.1.tar.xz" \
  "libfreetype-2.12.1" \
  "7f7cd7c706d8e402354305c1c59e3ff2"

download \
  "https://sourceforge.net/projects/opencore-amr/files/opencore-amr/opencore-amr-0.1.5.tar.gz" \
  "libopencore-amr-0.1.5" \
  "e0798587b91411cc092aa73091a97dfc"

download \
  "https://sourceforge.net/projects/opencore-amr/files/vo-amrwbenc/vo-amrwbenc-0.1.3.tar.gz" \
  "libvo-amrwbenc-0.1.3" \
  "f63bb92bde0b1583cb3cb344c12922e0"

download \
  "http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2" \
  "" \
  "292ab65cedd5021d6b7ddd117e07cd8e"

download \
  "https://downloads.xvid.com/downloads/xvidcore-1.3.7.tar.gz" \
  "libxvid-core-1.3.7" \
  "5c6c19324608ac491485dbb27d4da517"

download \
  "https://aomedia.googlesource.com/aom/+archive/v3.4.0.tar.gz" \
  "libaom-3.4.0" \
  ""

download \
  "https://downloads.videolan.org/pub/videolan/dav1d/1.0.0/dav1d-1.0.0.tar.xz" \
  "libdav1d-1.0.0" \
  "424548396e45406fe2f395e248b38121"

download \
  "https://github.com/Netflix/vmaf/archive/v2.3.1.tar.gz" \
  "libvmaf-2.3.1" \
  "be40a256a3b739ffc2119b45f919d6bf"

download \
  "https://github.com/AviSynth/AviSynthPlus/archive/v3.7.2.tar.gz" \
  "avisynthplus-3.7.2" \
  "cac7ab4e64af4caa8c10aa14e796331f"

download \
  "https://github.com/mm2/Little-CMS/archive/lcms2.13.1.tar.gz" \
  "lcms-2.13.1" \
  "4d07798d8d5826804403d4acb5c93f16"

download \
  "https://github.com/nkoriyama/aribb24/archive/v1.0.3.tar.gz" \
  "libaribb24-1.0.3" \
  "5ef0a6d1d72f294666ee1489b7ebb8c5"

download \
  "https://github.com/Distrotech/libiec61883/archive/v1.2.0.tar.gz" \
  "libiec61883-1.2.0" \
  "6d76dc23cd90611919d8c6d904797ee2"

download \
  "https://github.com/festvox/flite/archive/v2.2.tar.gz" \
  "libflite-2.2" \
  "31f84ece0078906780f07942c0cd978c"

download \
  "https://github.com/ultravideo/kvazaar/archive//v2.1.0.tar.gz" \
  "libkvazaar-2.1.0" \
  "3a133dbb009605748606f279615378e4"

download \
  "https://sourceforge.net/projects/modplug-xmms/files/libmodplug/0.8.9.0/libmodplug-0.8.9.0.tar.gz" \
  "" \
  "5ba16981e6515975e9a68a58d5ba69d1"

download \
  "https://github.com/hoene/libmysofa/archive/v1.2.1.tar.gz" \
  "libmysofa-1.2.1" \
  "de55b79f2687c824f2134e677f437601"

download \
  "https://github.com/cisco/openh264/archive/v2.2.0.tar.gz" \
  "libopenh264-2.2.0" \
  "19d2820c775abfea141d93779f958a9b"

download \
  "https://github.com/alanxz/rabbitmq-c/archive/v0.11.0.tar.gz" \
  "librabbitmq-0.11.0" \
  "e7d9896577aea6351811d7c1d7f0a68a"

download \
  "https://breakfastquay.com/files/releases/rubberband-3.0.0.tar.bz2" \
  "librubberband-3.0.0" \
  "30e220e8ca2202d52c58714793f93c23"

download \
  "https://github.com/toots/shine/archive/3.1.1.tar.gz" \
  "libshine-3.1.1" \
  "ff41cb139c25470f2d9c9acc9f97cc8d"

download \
  "https://github.com/toots/shine/archive/3.1.1.tar.gz" \
  "libshine-3.1.1" \
  "ff41cb139c25470f2d9c9acc9f97cc8d"

download \
  "https://github.com/haivision/srt/archive/v1.5.0.tar.gz" \
  "libsrt-1.5.0" \
  "339598e9674d8ed4507d20e8fad4a2d2"

download \
  "https://github.com/DanBloomberg/leptonica/archive/1.82.0.tar.gz" \
  "libleptonica-1.82.0" \
  "39f0befbd53939950beb32d81b3542cf"

download \
  "https://github.com/tesseract-ocr/tesseract/archive/5.2.0.tar.gz" \
  "libtesseract-5.2.0" \
  "1f289de81512bca5ab9ec07d173cb7b3"

download \
  "https://sourceforge.net/projects/twolame/files/twolame/0.4.0/twolame-0.4.0.tar.gz" \
  "libtwolame-0.4.0" \
  "400c164ed096c7aea82bcf8edcd3f6f9"

download \
  "https://sourceforge.net/projects/zapping/files/zvbi/0.2.35/zvbi-0.2.35.tar.bz2" \
  "libzvbi-0.2.35" \
  "95e53eb208c65ba6667fd4341455fa27"

download \
  "https://ftp.gnu.org/gnu/libcdio/libcdio-2.1.0.tar.bz2" \
  "libcdio-gnu-2.1.0" \
  "aa7629e8f73662a762f64c444b901055"

download \
  "https://github.com/rocky/libcdio-paranoia/archive/release-10.2+2.0.1.tar.gz" \
  "libcdio-paranoia-10.2+2.0.1" \
  "13aa9153d14a0d917c5bdac6e9bf8664"

download \
  "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v1.2.1/SVT-AV1-v1.2.1.tar.gz" \
  "libsvtav1-1.2.1" \
  "79b9e1262a7e999ab8b2e4cd5353b8c2"

download \
  "https://github.com/xiph/rav1e/archive/refs/tags/p20221004.tar.gz" \
  "librav1e-p20221004" \
  "3c0bbe422438ae85f7d980654ff45211"

download \
  "https://www.ffmpeg.org/releases/ffmpeg-5.1.tar.xz" \
  "" \
  "efd690ec82772073fd9d3ae83ca615da"

[ $download_only = true ] && exit 0

# Print the message about what library is
# being built and enter its build directory
building() {
  echo -e "${GREEN}> Building $1...${RESET}"
  cd "$BUILD_DIR"/"$1"*
}

# Override `configure` calls
configure() {
  ./configure --prefix="$TARGET_DIR" "$@"
}
# Override `cmake` calls
cmake() {
  command cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" "$@"
}
# Override `make` calls
make() {
  command make -j "$(nproc)" "$@"
}
# Override `meson` calls
meson() {
  command meson -Dprefix="$TARGET_DIR" --default-library=static --backend=ninja "$@"
}

building openssl
./config --prefix="$TARGET_DIR"
make
make install

building libx264
configure --enable-static --disable-opencl --enable-pic
make
make install

building libx265
cd build/linux
cmake -DENABLE_SHARED:BOOL=OFF -DSTATIC_LINK_CRT:BOOL=ON -DENABLE_CLI:BOOL=OFF ../../source
sed -i 's/-lgcc_s/-lgcc_eh/g' x265.pc
make
make install

building libfdk-aac
autoreconf -fiv
configure --disable-shared
make
make install

building libbrotli
mkdir -p out && cd out
cmake -DBUILD_SHARED_LIBS:bool=off ..
make
make install
ln -sf "${TARGET_DIR}/lib64/libbrotlidec-static.a" "${TARGET_DIR}/lib64/libbrotlidec.a"
ln -sf "${TARGET_DIR}/lib64/libbrotlicommon-static.a" "${TARGET_DIR}/lib64/libbrotlicommon.a"

building libfreetype
./autogen.sh
configure --enable-static --disable-shared
make
make install

building libharfbuzz
meson build
ninja -C build
ninja -C build install

building libfribidi
meson -Ddocs=false build
ninja -C build
ninja -C build install

building fontconfig
configure --enable-static --disable-shared
make
make install

building libass
./autogen.sh
configure --disable-shared
make
make install

building libmp3lame
configure --enable-nasm --disable-shared
make
make install

building libopus
./autogen.sh
configure --disable-shared
make
make install

building libvpx
configure --disable-examples --disable-unit-tests --enable-pic
make
make install

building libsoxr
cmake -DBUILD_SHARED_LIBS:bool=off -DWITH_OPENMP:bool=off -DBUILD_TESTS:bool=off
make
make install

building libvidstab
cmake -DBUILD_SHARED_LIBS:bool=off
make
make install

building libopenjpeg
cmake -DBUILD_SHARED_LIBS:bool=off
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

building libogg
./autogen.sh
configure --enable-static --disable-shared --with-pic
make
make install

building libvorbis
./autogen.sh
configure --disable-shared
make
make install

building libspeex
./autogen.sh
configure --disable-shared
make
make install

building libopencore-amr
configure --enable-static --disable-shared
make
make install

building libvo-amrwbenc
configure --enable-static --disable-shared
make
make install

building libtheora
./autogen.sh
configure --enable-static --disable-shared --disable-examples
make
make install

building libxvid-core
cd build/generic
configure
make
make install

building libaom
mkdir -p out && cd out
cmake -DBUILD_SHARED_LIBS:bool=off ..
make
make install

building libdav1d
meson build
ninja -C build
ninja -C build install

building libvmaf
cd libvmaf
meson build
ninja -C build
ninja -C build install

building avisynthplus
mkdir -p out && cd out
cmake -DBUILD_SHARED_LIBS:bool=off ..
make
make install

building lcms
./autogen.sh
configure --enable-static --disable-shared
make
make install

building libaribb24
./bootstrap
configure --enable-static --disable-shared
make
make install

building libflite
configure --disable-shared
make
make install

building libkvazaar
./autogen.sh
configure --enable-static --disable-shared
make
make install

building libmodplug
configure --enable-static --disable-shared
make
make install

building libmysofa
cmake -DBUILD_SHARED_LIBS:bool=off
make
make install

building libopenh264
meson build
ninja -C build
ninja -C build install

building librabbitmq
cmake -DBUILD_SHARED_LIBS:bool=off
make
make install

building librubberband
meson build
ninja -C build
ninja -C build install

building libshine
./bootstrap
configure --enable-static --disable-shared
make
make install

building libsrt
cmake -DENABLE_STATIC:bool=on
sed -i 's/-lgcc_s/-lgcc_eh/g' srt.pc
make
make install

building libleptonica
./autogen.sh
configure --enable-static --disable-shared
make
make install

building libtesseract
./autogen.sh
configure --enable-static --disable-shared --disable-openmp
make
make install

building libtwolame
configure --enable-static --disable-shared
make
make install

building libzvbi
configure --enable-static --disable-shared
make
make install

building libcdio-gnu
configure --enable-static --disable-shared
make
make install

building libcdio-paranoia
./autogen.sh
configure --enable-static --disable-shared
make
make install

building libsvtav1
cd Build
cmake -DBUILD_SHARED_LIBS:bool=off ..
make
make install

building librav1e
cargo install cargo-c
cargo cinstall --release --prefix="$TARGET_DIR"
sed -i 's/-lgcc_s/-lgcc_eh/g' "$TARGET_DIR/lib/pkgconfig/rav1e.pc"

building ffmpeg
FEATURES=( \
  --enable-avisynth \
  --enable-ffplay \
  --enable-fontconfig \
  --enable-frei0r \
  --enable-gpl \
  --enable-gray \
  --enable-lcms2 \
  --enable-libaom \
  --enable-libaribb24 \
  --enable-libass \
  --enable-libcdio \
  --enable-libdav1d \
  --enable-libfdk-aac \
  --enable-libflite \
  --enable-libfontconfig \
  --enable-libfreetype \
  --enable-libfribidi \
  --enable-libkvazaar \
  --enable-libmodplug \
  --enable-libmp3lame \
  --enable-libmysofa \
  --enable-libopencore-amrnb \
  --enable-libopencore-amrwb \
  --enable-libopenh264 \
  --enable-libopenjpeg \
  --enable-libopus \
  --enable-librabbitmq \
  --enable-librav1e \
  --enable-librubberband \
  --enable-libshine \
  --enable-libsoxr \
  --enable-libspeex \
  --enable-libsrt \
  --enable-libsvtav1 \
  --enable-libtesseract \
  --enable-libtheora \
  --enable-libtwolame \
  --enable-libvidstab \
  --enable-libvmaf \
  --enable-libvo-amrwbenc \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libwebp \
  --enable-libx264 \
  --enable-libx265 \
  --enable-libxml2 \
  --enable-libxvid \
  --enable-libzimg \
  --enable-libzvbi \
  --enable-lto \
  --enable-nonfree \
  --enable-openssl \
  --enable-pic \
  --enable-version3 \
)
if ! \
  configure \
  "${FEATURES[@]}" \
  --bindir="$BIN_DIR" \
  --extra-cflags="-I$TARGET_DIR/include" \
  --extra-ldexeflags="-static" \
  --extra-ldflags="-L$TARGET_DIR/lib" \
  --extra-libs="-lpthread -lm -lz" \
  --ld=g++ \
  --pkg-config-flags="--static"
then
  cat ffbuild/config.log
fi
make
make install
make distclean
hash -r
