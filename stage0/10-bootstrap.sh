#!/bin/bash
set -e

# TODO: This could be replaced with a pacstrap
ROOTFS_TARBALL_PATH="$CACHE_DIR/alarm-rootfs-$PLATFORM.tar.gz"

if [ ! -f "$ROOTFS_TARBALL_PATH" ]; then
	info "Downloading Arch Linux ARM rootfs for" "$PLATFORM"
	curl -Lo "$ROOTFS_TARBALL_PATH" "http://os.archlinuxarm.org/os/ArchLinuxARM-odroid-latest.tar.gz"
fi

info "Extracting" "ArchLinuxARM base filesystem"
bsdtar -xpf "$ROOTFS_TARBALL_PATH" -C "$BUILD_DIR"

info "Flashing" "U-Boot"
cd "$BUILD_DIR/boot"
./sd_fusing.sh "$OUTPUT_DEVICE"
cd "$BUILD_DIR/.."

info "Injecting" "bees 🐝🐝🐝🐝"
cat res/bee >> "$BUILD_DIR/etc/issue"
