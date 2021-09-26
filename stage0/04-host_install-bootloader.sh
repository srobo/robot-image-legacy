#!/bin/bash
set -e

source ./util.sh

xargs -a "platforms/$PLATFORM/packages" arch-chroot "$BUILD_DIR" pacman -S --noconfirm

if [ -f "platforms/$PLATFORM/install-bootloader.sh" ]; then
	"platforms/$PLATFORM/install-bootloader.sh"
fi
