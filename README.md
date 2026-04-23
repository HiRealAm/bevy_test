# bevy_test

Minimal Bevy app prepared for GitHub Codespaces.

## Run in Codespaces

```bash
cargo run
```

If this is your first build in a new Codespace, Rust will download dependencies first.

## What this app does

- Starts a Bevy application
- Loads default Bevy plugins
- Spawns a 2D camera at startup

## Why it did not run here

I ran a diagnosis in this environment and found two concrete blockers:

1. **Cargo could not download crates**: requests to `https://index.crates.io/config.json` were blocked by proxy with `CONNECT tunnel failed, response 403` (observed on **2026-04-23**).
2. **Likely missing native packages for Linux Bevy builds**: `libudev-dev`, `libasound2-dev`, `libxkbcommon-dev`, and `libwayland-dev` are not installed in this container.

Also, this shell is headless (`DISPLAY` is unset), so even after compiling, windowed Bevy execution may fail without a GUI/display forwarding setup.

## Quick diagnosis command

```bash
./scripts/diagnose_codespaces.sh
```

## Typical Codespaces fix

```bash
sudo apt-get update
sudo apt-get install -y pkg-config libudev-dev libasound2-dev libxkbcommon-dev libwayland-dev
cargo check
cargo run
```
