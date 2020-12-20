#!/bin/bash
if [ -z "$(which debootstrap)" ]; then
  echo "debootstrap is not installed"
  exit 1
fi

mkdir -p "$DEB_CACHE_DIR"
sudo debootstrap --arch=armhf --cache-dir="$DEB_CACHE_DIR" buster "$BUILD_DIR"
