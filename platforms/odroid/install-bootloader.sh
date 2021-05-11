#!/bin/bash
set -e

cp "platforms/$PLATFORM/boot.txt" "$BUILD_DIR/boot/boot.txt"
pushd "$BUILD_DIR/boot"
mkimage -A arm -O linux -T script -C none -n "U-Boot boot script" -d boot.txt boot.scr
bash "$BUILD_DIR/boot/sd_fusing.sh" "$OUTPUT_DEVICE"
popd
