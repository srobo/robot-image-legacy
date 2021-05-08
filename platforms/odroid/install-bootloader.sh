#!/bin/bash
set -e

pushd "$BUILD_DIR/boot"
mkimage -A arm -O linux -T script -C none -n "U-Boot boot script" -d "${oldpwd}/platforms/odroid/boot.txt" "$BUILD_DIR/boot/boot.scr"
bash "$BUILD_DIR/boot/sd_fusing.sh" "$OUTPUT_DEVICE"
popd
