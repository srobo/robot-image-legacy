#!/bin/bash
set -e

export CARCH=armv7l
info "Bootstrapping" "Arch Linux ARM"
# Reads in common and platform packages and runs pacstrap with them
cat stage0/packages{,-"$PLATFORM"} | xargs pacstrap -cMGC stage0/pacman.conf "$BUILD_DIR"

info "Flashing" "U-Boot"
cd "$BUILD_DIR/boot"
./sd_fusing.sh "$OUTPUT_DEVICE"
cd "$BUILD_DIR/.."

info "Injecting" "bees 🐝🐝🐝🐝"
cat res/bee >> "$BUILD_DIR/etc/issue"

info "Creating build metadata"
(
  echo BUILD_USER="$(whoami)"
  echo BUILD_HOST="$(hostname)"
  echo BUILD_TIME="$(date)"
  echo BUILD_COMMIT="$(git rev-parse --short HEAD)"
  echo BUILD_TAG="$(git describe --exact-match --tags)"
  if [ -n "$GITHUB_ACTIONS" ]; then
    echo GITHUB_ACTOR="${GITHUB_ACTOR}"
    echo GITHUB_REF="${GITHUB_REF}"
    echo GITHUB_REPOSITORY="${GITHUB_REPOSITORY}"
  fi
) > "$BUILD_DIR/etc/build-info"
