#!/bin/bash
set -eE
trap 'cleanup' EXIT
source ./util.sh

VERBOSE=0
BUILD_DIR="$(pwd)/mnt"
CACHE_DIR="$(pwd)/cache"
OUTPUT_DEVICE="$(losetup -f)"
IMAGE_OUTPUT_PATH="$(pwd)/out.img"
IMAGE_OUTPUT_SIZE=8G
PLATFORM=odroid

mkdir -p "$BUILD_DIR" "$CACHE_DIR"

ARGS=$(getopt -o "d::o::v" --long 'build-dir:,debug' -- "$@")
eval "set -- $ARGS"

while true; do
  case $1 in
    (-d|--build-dir)
      BUILD_DIR=$(readlink -f "$2"); shift 2;;
    (--debug)
      set -x; shift;;
    (-v)
      ((++VERBOSE)); shift;;
    (--) shift; break;;
    (*) echo "Invalid argument: $1"; exit 1;
  esac
done

remaining_args=("$@")

if [ -z "${remaining_args[0]}" ]; then
  echo "An output image path or device is required."
  exit 1
else
  out_path="${remaining_args[0]}"

  if [ -b "$out_path" ]; then
    OUTPUT_DEVICE="$out_path"
    IMAGE_OUTPUT_PATH="$out_path"
  else
    IMAGE_OUTPUT_PATH=$(readlink -f "$out_path")
  fi
fi

export OUTPUT_DEVICE
export VERBOSE
export BUILD_DIR
export CACHE_DIR
export IMAGE_OUTPUT_PATH
export IMAGE_OUTPUT_SIZE
export PLATFORM

vinfo "Build directory:" "$BUILD_DIR"

# Stage 0
stage_banner 0
./stage0/00-create-image.sh
./stage0/10-bootstrap.sh

# Stage 1
stage_banner 1
cp -r stage1 "$BUILD_DIR/stage1"
arch-chroot "$BUILD_DIR" "/stage1/00-init.sh"
rm -rf "$BUILD_DIR/stage1"