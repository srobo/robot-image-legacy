#!/bin/bash
set -e

source ./util.sh

export CARCH=armv7l
info "Bootstrapping" "Arch Linux ARM"
# Reads in common and platform packages and runs pacstrap with them
pacstrap -cMGC stage0-odroid/pacman.conf "$BUILD_DIR" base