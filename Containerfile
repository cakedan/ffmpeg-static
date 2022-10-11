FROM registry.fedoraproject.org/fedora:36

RUN dnf -y install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm

RUN dnf -y install \
    CUnit-devel \
    autoconf \
    automake \
    byacc \
    bzip2 \
    bzip2-static \
    cargo \
    cmake \
    curl \
    diffutils \
    expat-static \
    frei0r-devel \
    gcc \
    gcc-c++ \
    git \
    glib2-static \
    glibc-static \
    gperf \
    libpng-static \
    libstdc++-static \
    libtool \
    libxml2-devel \
    libxml2-static \
    meson \
    nasm \
    ninja-build \
    pcre-static \
    perl \
    which \
    xz \
    xz-static \
    yasm \
    zlib-static

ENV PATH="/root/.cargo/bin:${PATH}"

VOLUME /ffmpeg-static
WORKDIR /ffmpeg-static

ENTRYPOINT ["./build.sh"]
