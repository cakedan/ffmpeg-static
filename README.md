# FFmpeg static build

Scripts to make a static build of FFmpeg with many (but not all) codecs.

## Build

```bash
podman build --squash-all -t ffmpeg-static .
podman run -it --rm -v .:/ffmpeg-static:Z --name ffmpeg-static --userns=keep-id ffmpeg-static [-d] [-v]
```

Options:
* `-d`: download and unpack dependencies, but don't build;
* `-v`: make the build process verbose.

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

## Related projects

* [FFmpeg Static Builds](http://johnvansickle.com/ffmpeg/)
