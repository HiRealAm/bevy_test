# bevy_test

Starter Bevy example project prepared for GitHub Codespaces.

## Quick Start

Run the all-in-one setup script:

```bash
./setup.sh
```

This will:
- Install all dependencies
- Build the project
- Start the web demo server
- Provide access URLs

## What this example includes

- A windowed Bevy app (`Bevy Example Project`)
- A simple controllable player square
- Keyboard movement (`WASD` or arrow keys)
- Movement bounds so the player stays on screen

## Web Demo

The web demo runs automatically and is available at:
**`https://[codespace-name]-8000.app.github.dev/`**

Features:
- Interactive player movement with WASD/arrow keys
- Boundary constraints
- Canvas-based rendering

## Manual Options

If you prefer manual control:

```bash
# Setup environment only
./setup.sh 1

# Run native Bevy app
./setup.sh 2

# Start web server only
./setup.sh 3

# Open web demo in browser
./setup.sh 4
```

## Devcontainer

The project includes a devcontainer configuration that automatically sets up the full environment when creating a new codespace.
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
