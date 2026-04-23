#!/usr/bin/env bash
set -euo pipefail

printf '== Environment ==\n'
date -u
printf 'rustc: %s\n' "$(rustc --version 2>/dev/null || echo missing)"
printf 'cargo: %s\n' "$(cargo --version 2>/dev/null || echo missing)"
printf 'HTTPS_PROXY: %s\n' "${HTTPS_PROXY:-<unset>}"
printf 'DISPLAY: %s\n\n' "${DISPLAY:-<unset>}"

printf '== crates.io reachability ==\n'
if curl -I --max-time 15 https://index.crates.io/config.json >/tmp/crates_head.out 2>/tmp/crates_head.err; then
  echo 'OK: index.crates.io reachable'
else
  echo 'FAIL: cannot reach index.crates.io'
  sed -n '1,5p' /tmp/crates_head.err || true
fi
printf '\n'

printf '== Native Linux packages commonly needed by Bevy ==\n'
missing=0
for pkg in pkg-config libudev-dev libasound2-dev libxkbcommon-dev libwayland-dev; do
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
