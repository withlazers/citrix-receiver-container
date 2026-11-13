# Notes for agents

- Images are per user (rootless podman): each user builds their own with `./build.sh`.
- Debugging without a display: run the image in a throwaway layer with `xvfb`, `xdotool` and `imagemagick`, start `/entrypoint.sh` under `Xvfb`, type the store URL with `xdotool`, screenshot with `import -window root`.
- Citrix logs: `logs/` in the `citrix-ica` volume (`podman unshare`, path from `podman volume inspect citrix-ica`). Useful lines: `Curlcode`, `Detail:`.
- After a failed account setup (TLS, network) delete the `citrix-ica` volume before retrying: Citrix caches the connectivity result and keeps failing.
