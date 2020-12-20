#!/bin/bash
set -eE
trap 'cleanup' EXIT
source ./util.sh

VERBOSE=0
BUILD_DIR="$(pwd)/mnt"
CACHE_DIR="$(pwd)/.cache"
DEB_CACHE_DIR="$CACHE_DIR/deb"
LOOP_DEV="$(losetup -f)"
IMAGE_OUTPUT_PATH="$(pwd)/out.img"

ARGS=$(getopt -o "d::o::v" --long 'build-dir:,debug' -- "$@")
eval "set -- $ARGS"

while true; do
  case $1 in
    (-d|--build-dir)
      BUILD_DIR=$(readlink -f "$2"); shift 2;;
    (--debug)
      set -x; shift;;
    (-o)
      IMAGE_OUTPUT_PATH=$(readlink -f "$2"); shift 2;;
    (-v)
      # TODO: This currently seems to cause the script to crash
      ((VERBOSE++)); shift;;
    (--) shift; break;;
    (*) exit 1;
  esac
done

export VERBOSE
export BUILD_DIR
export CACHE_DIR
export DEB_CACHE_DIR
export LOOP_DEV
export IMAGE_OUTPUT_PATH

vinfo "Build directory:" "$BUILD_DIR"

# Stage 0
./stage0/00-create-image.sh
./stage0/10-boostrap.sh
