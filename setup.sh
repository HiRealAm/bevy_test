#!/usr/bin/env bash
set -euo pipefail

# Comprehensive setup and run script for Bevy Test App
# This script handles all setup and provides access to both native and web versions

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running in codespaces
is_codespaces() {
    [[ -n "${CODESPACE_NAME:-}" ]]
}

# Setup function
setup_environment() {
    log_info "Setting up Bevy Test App environment..."

    # Kill any stale cargo processes from previous failed builds
    pkill -9 cargo 2>/dev/null || true
    pkill -9 rustc 2>/dev/null || true
    sleep 1

    # Install system dependencies
    log_info "Installing system dependencies..."
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
        xvfb \
        python3

    # Install latest Rust if not present
    if ! command -v cargo &> /dev/null; then
        log_info "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    fi

    # Source cargo environment
    if [[ -f "$HOME/.cargo/env" ]]; then
        source "$HOME/.cargo/env"
    fi

    # Start virtual display if not running
    if ! pgrep -x "Xvfb" > /dev/null; then
        log_info "Starting virtual display..."
        Xvfb :99 -screen 0 1024x768x24 &
        sleep 2
    fi

    export DISPLAY=:99

    log_success "Environment setup complete!"
}

# Build the project
build_project() {
    log_info "Building Bevy project..."
    cd "$PROJECT_DIR"

    # Clean any problematic lock files and cache directories
    rm -f Cargo.lock
    find target -name ".cargo-lock" -delete 2>/dev/null || true
    rm -rf target/.fingerprint 2>/dev/null || true

    cargo build --release
    log_success "Build complete!"
}

# Start web server
start_web_server() {
    log_info "Starting web server..."

    # Kill any existing servers
    pkill -f "python3 -m http.server" || true

    cd "$PROJECT_DIR"
    python3 -m http.server 8000 &
    sleep 1

    if is_codespaces; then
        WEB_URL="https://${CODESPACE_NAME}-8000.app.github.dev/"
        log_success "Web demo available at: $WEB_URL"
        echo "$WEB_URL" > /tmp/web_demo_url.txt
    else
        WEB_URL="http://localhost:8000/web-demo.html"
        log_success "Web demo available at: $WEB_URL"
    fi
}

# Run native app
run_native() {
    log_info "Starting native Bevy app..."
    cd "$PROJECT_DIR"

    export DISPLAY=:99
    timeout 30 cargo run || log_warning "App exited (timeout or user interrupt)"
}

# Show menu
show_menu() {
    echo
    echo "========================================"
    echo "       Bevy Test App Launcher"
    echo "========================================"
    echo
    echo "Choose an option:"
    echo "1) Setup environment and build"
    echo "2) Run native Bevy app"
    echo "3) Start web demo server"
    echo "4) Open web demo in browser"
    echo "5) Run everything (setup + web demo)"
    echo "6) Exit"
    echo
    read -p "Enter choice (1-6): " choice
    echo
}

# Open web demo
open_web_demo() {
    if [[ -f /tmp/web_demo_url.txt ]]; then
        WEB_URL=$(cat /tmp/web_demo_url.txt)
        log_info "Opening web demo: $WEB_URL"

        if command -v xdg-open &> /dev/null; then
            xdg-open "$WEB_URL"
        elif command -v open &> /dev/null; then
            open "$WEB_URL"
        else
            log_warning "Unable to open browser automatically. Please visit: $WEB_URL"
        fi
    else
        log_error "Web server not started. Run option 3 first."
    fi
}

# Main function
main() {
    cd "$PROJECT_DIR"

    # Check for command line argument (non-interactive mode)
    if [[ $# -gt 0 ]]; then
        choice="$1"
        case $choice in
            1)
                setup_environment
                build_project
                ;;
            2)
                if [[ ! -f "$PROJECT_DIR/target/release/bevy_test" ]]; then
                    log_warning "Project not built. Building first..."
                    build_project
                fi
                run_native
                ;;
            3)
                start_web_server
                ;;
            4)
                open_web_demo
                ;;
            5)
                setup_environment
                build_project
                start_web_server
                log_info "Setup complete! The web demo is now running."
                if is_codespaces; then
                    WEB_URL=$(cat /tmp/web_demo_url.txt)
                    log_success "Access your Bevy app at: $WEB_URL"
                fi
                exit 0
                ;;
            6)
                log_info "Goodbye!"
                exit 0
                ;;
            *)
                log_error "Invalid choice: $choice. Use 1-6."
                exit 1
                ;;
        esac
        exit 0
    fi

    # Interactive mode
    while true; do
        show_menu

        case $choice in
            1)
                setup_environment
                build_project
                ;;
            2)
                if [[ ! -f "$PROJECT_DIR/target/release/bevy_test" ]]; then
                    log_warning "Project not built. Building first..."
                    build_project
                fi
                run_native
                ;;
            3)
                start_web_server
                ;;
            4)
                open_web_demo
                ;;
            5)
                setup_environment
                build_project
                start_web_server
                log_info "Setup complete! The web demo is now running."
                if is_codespaces; then
                    WEB_URL=$(cat /tmp/web_demo_url.txt)
                    log_success "Access your Bevy app at: $WEB_URL"
                fi
                ;;
            6)
                log_info "Goodbye!"
                exit 0
                ;;
            *)
                log_error "Invalid choice. Please select 1-6."
                ;;
        esac

        echo
        read -p "Press Enter to continue..."
        clear
    done
}

# Run main function
main "$@"