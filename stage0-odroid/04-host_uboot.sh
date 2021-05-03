#!/bin/bash
set -e

source ./util.sh

info "Flashing" "U-Boot"
cd "$BUILD_DIR/boot"
./sd_fusing.sh "$OUTPUT_DEVICE"
cd "$BUILD_DIR/.."