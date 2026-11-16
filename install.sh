#!/usr/bin/env bash
#
# Installer for macspoof (Apple Silicon Edition)
# https://github.com/morevolk-latei/macspoof
#

set -e

# Verify Apple Silicon
ARCH=$(uname -m 2>/dev/null || echo "Unknown")
CHIP=$(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "Unknown")

if [[ "$ARCH" != "arm64" ]] || [[ ! "$CHIP" =~ Apple\ M[0-9] ]]; then
    echo "Error: Incompatible architecture ($ARCH / $CHIP)." >&2
    echo "macspoof is exclusively designed for Apple Silicon (M1, M2, M3, M4) Macs." >&2
    exit 1
fi

echo "==> Detected $CHIP ($ARCH)..."

# Determine installation directory
INSTALL_DIR="/usr/local/bin"
USE_SUDO=false

if [ ! -d "$INSTALL_DIR" ]; then
    INSTALL_DIR="$HOME/.local/bin"
    mkdir -p "$INSTALL_DIR"
elif [ ! -w "$INSTALL_DIR" ]; then
    USE_SUDO=true
fi

# Source location: check if running from cloned repository or curl pipe
REPO_RAW_URL="https://raw.githubusercontent.com/morevolk-latei/macspoof/main/bin/macspoof"
LOCAL_BIN="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/bin/macspoof"

TARGET="$INSTALL_DIR/macspoof"
TEMP_FILE="/tmp/macspoof.$$"

if [ -f "$LOCAL_BIN" ]; then
    echo "==> Installing from local source: $LOCAL_BIN"
    cp "$LOCAL_BIN" "$TEMP_FILE"
else
    echo "==> Downloading macspoof from GitHub..."
    curl -fsSL "$REPO_RAW_URL" -o "$TEMP_FILE"
fi

chmod +x "$TEMP_FILE"

if [ "$USE_SUDO" = true ]; then
    echo "==> Administrator (sudo) password required to install to $INSTALL_DIR:"
    sudo cp "$TEMP_FILE" "$TARGET"
    sudo chmod +x "$TARGET"
else
    cp "$TEMP_FILE" "$TARGET"
    chmod +x "$TARGET"
fi

rm -f "$TEMP_FILE"

echo "==> Successfully installed macspoof to $TARGET"

# Check PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo "==> Warning: $INSTALL_DIR is not currently in your PATH."
    echo "    Add this line to your ~/.zshrc or ~/.bash_profile:"
    echo "    export PATH=\"$INSTALL_DIR:\$PATH\""
fi

echo ""
echo "Test the installation by running:"
echo "  macspoof status"
