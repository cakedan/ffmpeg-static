# FFmpeg static build

Scripts to make a static build of FFmpeg with many (but not all) latest codecs.

## Build

```bash
./build.sh [-j <jobs>] [-v] [-B] [-d]
```

*or*

```bash
./build-ubuntu.sh [-j <jobs>] [-v] [-B] [-d]
```

*or*

```bash
./build-macos.sh [-j <jobs>] [-v] [-B] [-d]
```

Arguments:
* `-j <jobs>`: number of jobs to run at the same time;
* `-v`: make the build process verbose;
* `-B`: reconfigure and rebuild all packages;
* `-d`: download and unpack dependencies, but don't build.

If you're on another Linux, you can inspect the `build-ubuntu.sh` script for dependencies you might need. Or, better yet, you can build in a rootless container as described in the next section.

> ***NOTE:*** If you're going to use the H264 presets, make sure to copy them along the binaries. For ease, you can put them in your home folder like this:

```
mkpath ~/.ffmpeg && cp ./target/share/ffmpeg/*.ffpreset ~/.ffmpeg
```

## Build using Podman

```bash
podman build --squash-all -t ffmpeg-static .
podman run -it --rm -v .:/ffmpeg-static:Z --name ffmpeg-static ffmpeg-static [-j <jobs>] [-B] [-d]
```

The binaries will be created in the `./bin` directory.

## Debug

On the top-level of the project, run:

```bash
. env.source
```

You can then enter the source folders and make the compilation yourself

```bash
cd build/ffmpeg-*
./configure --prefix=$TARGET_DIR #...
```

## Check if it's actually static

Note that binaries on macOS may still be dynamic.

```bash
# On Ubuntu:
$ ldd ./target/bin/ffmpeg
not a dynamic executable

# on macOS:
$ otool -L ffmpeg
ffmpeg:
    /usr/lib/libSystem.B.dylib
```

## Related projects

* [FFmpeg Static Builds](http://johnvansickle.com/ffmpeg/)
