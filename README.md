# Description

A script to make a static build of [FFmpeg](https://www.ffmpeg.org).

Git mirrors:
- [Codeberg](https://codeberg.org/paveloom-f/ffmpeg-static)
- [GitHub](https://github.com/paveloom-f/ffmpeg-static)
- [GitLab](https://gitlab.com/paveloom-g/forks/ffmpeg-static)

## Build

```bash
mkdir -p cache/dnf
podman build --squash-all -v $(pwd)/cache/dnf:/cache/dnf:Z -t ffmpeg-static .
podman run -it --rm -v .:/ffmpeg-static:Z --name ffmpeg-static ffmpeg-static [-d]
```

Options:
* `-d`: download and unpack dependencies, don't build.

The binaries will be created in the `./bin` directory.

You can delete the image after you're done with

```bash
podman rmi ffmpeg-static
```

## Debug

Start a Podman container in the background, then enter it with a shell:

```bash
podman run -itd -v .:/ffmpeg-static:Z --entrypoint=/bin/bash --name ffmpeg-static ffmpeg-static
podman exec -it ffmpeg-static /bin/bash
```

On the top-level of the project, run

```bash
. env.sh
```

To download only dependencies, run

```bash
./build.sh -d
```

You can then enter the source folders and make the compilation yourself:

```bash
cd build/ffmpeg-*
./configure --prefix=$TARGET_DIR # <...>
```

Don't forget to delete the container after you're done:

```bash
podman stop -t 1 ffmpeg-static && podman rm ffmpeg-static
```
