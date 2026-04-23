#!/usr/bin/env bash
set -euo pipefail

printf '== Environment ==\n'
date -u
printf 'rustc: %s\n' "$(rustc --version 2>/dev/null || echo missing)"
printf 'cargo: %s\n' "$(cargo --version 2>/dev/null || echo missing)"
printf 'HTTPS_PROXY: %s\n' "${HTTPS_PROXY:-<unset>}"
printf 'HTTP_PROXY: %s\n' "${HTTP_PROXY:-<unset>}"
printf 'DISPLAY: %s\n' "${DISPLAY:-<unset>}"
printf 'CARGO_REGISTRY_MIRROR: %s\n\n' "${CARGO_REGISTRY_MIRROR:-<unset>}"

printf '== Registry reachability ==\n'
if curl -I --max-time 15 https://github.com/rust-lang/crates.io-index >/tmp/crates_git_head.out 2>/tmp/crates_git_head.err; then
  echo 'OK: github.com/rust-lang/crates.io-index reachable'
else
  echo 'FAIL: cannot reach github.com/rust-lang/crates.io-index'
  sed -n '1,5p' /tmp/crates_git_head.err || true
fi

if curl -I --max-time 15 https://static.crates.io >/tmp/crates_static_head.out 2>/tmp/crates_static_head.err; then
  echo 'OK: static.crates.io reachable'
else
  echo 'FAIL: cannot reach static.crates.io'
  sed -n '1,5p' /tmp/crates_static_head.err || true
fi
printf '\n'

if [[ -n "${CARGO_REGISTRY_MIRROR:-}" ]]; then
  if curl -I --max-time 15 "${CARGO_REGISTRY_MIRROR}" >/tmp/crates_mirror_head.out 2>/tmp/crates_mirror_head.err; then
    echo 'OK: CARGO_REGISTRY_MIRROR reachable'
  else
    echo 'FAIL: cannot reach CARGO_REGISTRY_MIRROR'
    sed -n '1,5p' /tmp/crates_mirror_head.err || true
  fi
fi

printf '== Native Linux packages commonly needed by Bevy ==\n'
missing=0
for pkg in pkg-config libudev-dev libasound2-dev libxkbcommon-dev libwayland-dev libx11-dev libxi-dev libxcursor-dev libxrandr-dev libxinerama-dev libgl1-mesa-dev; do
  if dpkg -s "$pkg" >/dev/null 2>&1; then
    echo "OK: $pkg"
  else
    echo "MISSING: $pkg"
    missing=1
  fi
done

printf '\n== Diagnosis ==\n'
if [[ ${missing} -eq 1 ]]; then
  echo 'Some native packages are missing; Bevy may fail to compile until installed.'
else
  echo 'Native package check passed.'
fi

if [[ -z "${DISPLAY:-}" ]]; then
  echo 'No DISPLAY detected; windowed Bevy apps may not start in headless shells.'
fi
