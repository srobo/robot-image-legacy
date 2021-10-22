#!/bin/bash
set -e

source ./util.sh

info "Disabling unwanted kernel modules"
cp "stage1/files/disabled_modules.conf" "$BUILD_DIR/etc/modprobe.d/"

