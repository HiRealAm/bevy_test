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

## What this example includes

- A windowed Bevy app (`Bevy Example Project`)
- A simple controllable player square
- Keyboard movement (`WASD` or arrow keys)
- Movement bounds so the player stays on screen

If no display server is available (`DISPLAY`/`WAYLAND_DISPLAY` unset), the app automatically runs in one-shot headless mode so the terminal command still succeeds.

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
