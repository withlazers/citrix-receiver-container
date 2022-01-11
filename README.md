Citrix Receiver for Podman
==========================

This is a set of scripts that allows to jail Citrix Receiver in a Podman image.
This is useful for developers that want to keep their desktop clean, but are
forced to use Citrix for their day to day work. This also allows to run citrix
on musl based operating systems like VoidLinux or Alpine.

## Steps to set up

### 1. Obtain the debian package

Go to [the citrix download page](https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html)
and download the latest version. Place it in `docker/citrix`.

### 2. Build the container image

```
podman build -t citrix docker/citrix
```

### 3. Start the container:

```
podman run --rm --detach -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --ipc=host citrix
```

## TODO

- citrix currently uses X11, which is inherently unsafe and exposes all other X
  clients to Citrix. Run an Xwayland server in the container and let it connect
  to the hosts Wayland compositor.
- firefox opens dialogs to allow to xdg-open an ica file. this should be done
  automatically.
