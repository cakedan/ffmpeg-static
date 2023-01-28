FROM registry.fedoraproject.org/fedora:latest

RUN \
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
    sh -s -- -y --default-toolchain none --no-modify-path;

ENV PATH="/root/.cargo/bin:${PATH}"

RUN \
  echo "keepcache=1" | sudo tee -a /etc/dnf/dnf.conf >/dev/null; \
  echo "cachedir=/cache/dnf" | sudo tee -a /etc/dnf/dnf.conf >/dev/null; \
  dnf -y update; \
  dnf -y install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm; \
  dnf -y install \
    CUnit-devel \
    SDL2-static \
    autoconf \
    automake \
    byacc \
    bzip2 \
    bzip2-static \
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

VOLUME /ffmpeg-static
WORKDIR /ffmpeg-static

ENTRYPOINT ["./build.sh"]
