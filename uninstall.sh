#!/usr/bin/env bash
#
# Uninstaller for macspoof
# https://github.com/morevolk-latei/macspoof
#

set -e

LOCATIONS=(
    "/usr/local/bin/macspoof"
    "/opt/homebrew/bin/macspoof"
    "$HOME/.local/bin/macspoof"
)

FOUND=false

for loc in "${LOCATIONS[@]}"; do
    if [ -f "$loc" ]; then
        FOUND=true
        if [ -w "$(dirname "$loc")" ]; then
            rm -f "$loc"
            echo "==> Removed $loc"
        else
            echo "==> Administrator (sudo) required to remove $loc:"
            sudo rm -f "$loc"
            echo "==> Removed $loc"
        fi
    fi
done

if [ "$FOUND" = false ]; then
    echo "macspoof was not found in standard installation directories."
else
    echo "==> macspoof successfully uninstalled."
fi
