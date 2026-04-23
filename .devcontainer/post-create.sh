#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  pkg-config \
  libudev-dev \
  libasound2-dev \
  libxkbcommon-dev \
  libxkbcommon-x11-0 \
  libwayland-dev \
  libx11-dev \
  libxi-dev \
  libxcursor-dev \
  libxrandr-dev \
  libxinerama-dev \
  libgl1-mesa-dev \
  xvfb

# Install latest Rust using rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source ~/.cargo/env

mkdir -p "${HOME}/.cargo"

if [[ -n "${CARGO_REGISTRY_MIRROR:-}" ]]; then
  cat > "${HOME}/.cargo/config.toml" <<TOML
[net]
git-fetch-with-cli = true
retry = 5

[http]
multiplexing = false

[source.crates-io]
replace-with = "mirror"

[source.mirror]
registry = "${CARGO_REGISTRY_MIRROR}"
TOML
else
  # Proxy-friendly default: use GitHub registry index instead of index.crates.io.
  cat > "${HOME}/.cargo/config.toml" <<'TOML'
[net]
git-fetch-with-cli = true
retry = 5

[http]
multiplexing = false

[registries.crates-io]
protocol = "git"
index = "https://github.com/rust-lang/crates.io-index"
TOML
fi

# Start Xvfb for display support
Xvfb :99 -screen 0 1024x768x24 &
export DISPLAY=:99

cargo fetch --locked || cargo fetch
