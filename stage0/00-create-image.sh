#!/bin/bash
set -e

if [[ "$OUTPUT_DEVICE" =~ ^/dev/loop ]]; then
  info "Creating disk image"
  fallocate -l "$IMAGE_OUTPUT_SIZE" "$IMAGE_OUTPUT_PATH"
else
  info "Zeroing the beginning of the SD card"
  dd if=/dev/zero of="$OUTPUT_DEVICE" bs=1M count=8
fi

info "Partitioning disk image"
(
  echo o # create a new MS-DOS partition table

  # TODO: Separate boot partition
  # TODO: Secondary system partition for AB

  # Boot partition
  echo n # new partition
  echo p # primary partition
  echo 1 # partition number
  echo 4096 # first sector
  echo  # last sector (accept default)

  echo w # write changes
) | /sbin/fdisk "$IMAGE_OUTPUT_PATH" > /dev/null


if [[ "$OUTPUT_DEVICE" =~ ^/dev/loop ]]; then
  info "Setting up loop device"
  losetup -P "$OUTPUT_DEVICE" "$IMAGE_OUTPUT_PATH"
  rootfs_part="${OUTPUT_DEVICE}p1"
else
  rootfs_part="${OUTPUT_DEVICE}1"
fi

info "Creating root filesystem"
mkfs.ext4 "$rootfs_part"

if [ ! -d "mnt" ]; then
  mkdir "$BUILD_DIR"
fi

info "Mounting root partition"
mount -t ext4 -o rw,defaults,noatime "$rootfs_part" "$BUILD_DIR"
