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

# Determine target installation directory
# /usr/local/bin is in macOS /etc/paths by default for all users.
INSTALL_DIR=""
USE_SUDO=false

if [ -d "/opt/homebrew/bin" ] && [[ ":$PATH:" == *":/opt/homebrew/bin:"* ]] && [ -w "/opt/homebrew/bin" ]; then
    INSTALL_DIR="/opt/homebrew/bin"
elif [ -d "/usr/local/bin" ] && [ -w "/usr/local/bin" ]; then
    INSTALL_DIR="/usr/local/bin"
elif command -v sudo >/dev/null 2>&1; then
    INSTALL_DIR="/usr/local/bin"
    USE_SUDO=true
else
    INSTALL_DIR="$HOME/.local/bin"
    mkdir -p "$INSTALL_DIR"
fi

# Prepare source file
REPO_RAW_URL="https://raw.githubusercontent.com/morevolk-latei/macspoof/main/bin/macspoof"
LOCAL_BIN="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/bin/macspoof"
TEMP_FILE="/tmp/macspoof.$$"

if [ -f "$LOCAL_BIN" ]; then
    echo "==> Installing from local source: $LOCAL_BIN"
    cp "$LOCAL_BIN" "$TEMP_FILE"
else
    echo "==> Downloading macspoof from GitHub..."
    curl -fsSL "$REPO_RAW_URL" -o "$TEMP_FILE"
fi

chmod +x "$TEMP_FILE"
TARGET="$INSTALL_DIR/macspoof"

if [ "$USE_SUDO" = true ]; then
    echo "==> Installing to $INSTALL_DIR (system-wide, requires sudo)..."
    sudo mkdir -p "$INSTALL_DIR"
    sudo cp "$TEMP_FILE" "$TARGET"
    sudo chmod +x "$TARGET"
else
    mkdir -p "$INSTALL_DIR"
    cp "$TEMP_FILE" "$TARGET"
    chmod +x "$TARGET"
fi

rm -f "$TEMP_FILE"
echo "==> Successfully installed macspoof to $TARGET"

# Verify whether INSTALL_DIR is in the active PATH
PATH_UPDATED=false
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    SHELL_CONFIG=""
    if [ -n "$ZSH_VERSION" ] || [ -f "$HOME/.zshrc" ] || [[ "$SHELL" == */zsh ]]; then
        SHELL_CONFIG="$HOME/.zshrc"
    elif [ -f "$HOME/.bash_profile" ] || [[ "$SHELL" == */bash ]]; then
        SHELL_CONFIG="$HOME/.bash_profile"
    fi

    if [ -n "$SHELL_CONFIG" ]; then
        if ! grep -q "$INSTALL_DIR" "$SHELL_CONFIG" 2>/dev/null; then
            echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$SHELL_CONFIG"
            PATH_UPDATED=true
        fi
    fi
fi

echo ""
if [ "$PATH_UPDATED" = true ]; then
    echo "⚡ Important: Added $INSTALL_DIR to your PATH in $SHELL_CONFIG."
    echo "   To start using macspoof right away, reload your shell:"
    echo "       source $SHELL_CONFIG"
    echo "   or open a new terminal window."
else
    echo "✓ Ready to use! Try running:"
    echo "    macspoof status"
fi
