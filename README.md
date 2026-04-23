# bevy_test

Starter Bevy example project prepared for GitHub Codespaces.

## Run

```bash
cargo run
```

Or use the provided start script:

```bash
./scripts/start.sh
```

The start script automatically handles display setup and ensures the proper environment for running the Bevy app.

On first startup, Codespaces runs `.devcontainer/post-create.sh`, which installs native Linux dependencies for Bevy, writes a proxy-friendly Cargo config, and prefetches Rust crates.

## Web Demo

A web-based version of the Bevy app is available as `web-demo.html`. This demonstrates the game mechanics running in a browser canvas.

In GitHub Codespaces, the web demo is automatically served at:
**https://[codespace-name]-8000.app.github.dev/**

To view it:
1. Open the forwarded port notification in VS Code
2. Or navigate to the URL above (replace [codespace-name] with your codespace name)
3. Use WASD or arrow keys to control the player

The web demo includes:
- Interactive player movement with WASD/arrow keys
- Boundary constraints
- Canvas-based rendering

## Proxy support

If your environment requires a proxy, set these in your Codespace (or VS Code terminal):

```bash
export HTTPS_PROXY=http://proxy-host:port
export HTTP_PROXY=http://proxy-host:port
```

If your company provides a Cargo registry mirror, set it before running the setup script:

```bash
export CARGO_REGISTRY_MIRROR=sparse+https://<your-artifactory-or-mirror>/
```

- With `CARGO_REGISTRY_MIRROR` set, the setup script configures Cargo to use that mirror.
- Without it, the repo defaults to GitHub-backed registry index access (`protocol = "git"`) plus `git-fetch-with-cli`, which is often more reliable behind proxies.

## Devcontainer dependencies installed

- `pkg-config`
- `libudev-dev`
- `libasound2-dev`
- `libxkbcommon-dev`
- `libwayland-dev`
- `libx11-dev`
- `libxi-dev`
- `libxcursor-dev`
- `libxrandr-dev`
- `libxinerama-dev`
- `libgl1-mesa-dev`

## Quick diagnosis command

```bash
./scripts/diagnose_codespaces.sh
```
