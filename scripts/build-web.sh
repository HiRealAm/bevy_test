#!/usr/bin/env bash
set -euo pipefail

# Web build script for Bevy Test App
# Builds the app for web using wasm-pack

echo "Building Bevy Test App for web..."

# Ensure wasm-pack is available
if ! command -v wasm-pack &> /dev/null; then
    echo "wasm-pack not found. Installing..."
    curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh
fi

# Source cargo environment
if [[ -f "$HOME/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
fi

# Build for web
wasm-pack build --target web --out-dir web-build

# Create index.html
cat > web-build/index.html << 'EOF'
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Bevy Test App</title>
    <style>
      body {
        margin: 0;
        padding: 0;
        background: #000;
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
      }
      canvas {
        border: 1px solid #333;
      }
    </style>
  </head>
  <body>
    <script type="module">
      import init from './bevy_test.js';
      init();
    </script>
  </body>
</html>
EOF

echo "Web build complete! Files are in web-build/"
echo "To serve locally, run: python3 -m http.server 8000 -d web-build"
echo "Then open http://localhost:8000 in your browser"