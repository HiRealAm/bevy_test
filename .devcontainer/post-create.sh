#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  pkg-config \
  libudev-dev \
  libasound2-dev \
  libxkbcommon-dev \
  libwayland-dev \
  libx11-dev \
  libxi-dev \
  libxcursor-dev \
  libxrandr-dev \
  libxinerama-dev \
  libgl1-mesa-dev

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

cargo fetch --locked || cargo fetch
