# Description

A script to make a static build of [FFmpeg](https://www.ffmpeg.org).

Git mirrors:
- [Codeberg](https://codeberg.org/paveloom-f/ffmpeg-static)
- [GitHub](https://github.com/paveloom-f/ffmpeg-static)
- [GitLab](https://gitlab.com/paveloom-g/forks/ffmpeg-static)

## Build

```bash
podman build --squash-all -t ffmpeg-static .
podman run -it --rm -v .:/ffmpeg-static:Z --name ffmpeg-static ffmpeg-static [-d]
```

Options:
* `-d`: download and unpack dependencies, don't build.

The binaries will be created in the `./bin` directory.

## Debug

On the top-level of the project, run:

```bash
. env.sh
```

You can then enter the source folders and make the compilation yourself

```bash
cd build/ffmpeg-*
./configure --prefix=$TARGET_DIR #...
```
