FROM fedora:36

RUN dnf -y install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm

RUN dnf -y install \
    autoconf \
    automake \
    byacc \
    bzip2 \
    cmake \
    curl \
    diffutils \
    expat-static \
    freetype-devel \
    frei0r-devel \
    gcc \
    gcc-c++ \
    git \
    glib2-static \
    glibc-static \
    gperf \
    libstdc++-static \
    libtool \
    meson \
    nasm \
    ninja-build \
    opencore-amr-devel \
    openjpeg2-devel \
    pcre-static \
    perl \
    vo-amrwbenc-devel \
    which \
    xz \
    yasm \
    zlib-static

VOLUME /ffmpeg-static
WORKDIR /ffmpeg-static

ENTRYPOINT ["./build.sh"]
