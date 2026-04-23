#!/usr/bin/env bash
set -euo pipefail

# Start script for Bevy Test App
# This script ensures the proper environment is set up for running the Bevy application

# Check if DISPLAY is set, if not, try to set it for virtual display
if [[ -z "${DISPLAY:-}" ]]; then
    echo "DISPLAY not set. Starting virtual display..."
    # Check if Xvfb is running
    if ! pgrep -x "Xvfb" > /dev/null; then
        echo "Starting Xvfb..."
        Xvfb :99 -screen 0 1024x768x24 &
        sleep 1
    fi
    export DISPLAY=:99
    echo "Set DISPLAY=:99"
fi

# Ensure Rust environment is available
if ! command -v cargo &> /dev/null; then
    echo "Cargo not found. Please ensure Rust is installed."
    exit 1
fi

# Source cargo environment if rustup was used
if [[ -f "$HOME/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
fi

echo "Starting Bevy Test App..."
cd "$(dirname "$0")/.."
cargo run