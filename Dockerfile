FROM ubuntu:22.04

RUN apt-get update && \
  apt-get install -y sudo && \
  rm -rf /var/lib/apt/lists/*

VOLUME /ffmpeg-static
WORKDIR /ffmpeg-static

# Copy the build scripts
COPY build.sh build-ubuntu.sh download.pl env.source fetchurl .

ENTRYPOINT ["./build-ubuntu.sh"]
