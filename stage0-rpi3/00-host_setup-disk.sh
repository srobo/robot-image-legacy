#!/bin/bash
set -e

source ./util.sh

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
  echo n      # new partition
  echo p      # primary partition
  echo 1      # partition number
  echo        # first sector (accept default)
  echo +200M  # last sector (accept default)
  echo t      # Set partition type
  echo c      # Set W95 FAT32 (LBA)

  # Root FS
  echo n # new partition
  echo p # primary partition
  echo 2 # partition number
  echo   # first sector (accept default)
  echo   # last sector (accept default)

  echo w # write changes
) | /sbin/fdisk "$IMAGE_OUTPUT_PATH" > /dev/null


if [[ "$OUTPUT_DEVICE" =~ ^/dev/loop ]]; then
  info "Setting up loop device"
  losetup -P "$OUTPUT_DEVICE" "$IMAGE_OUTPUT_PATH"
  boot_part="${OUTPUT_DEVICE}p1"
  rootfs_part="${OUTPUT_DEVICE}p2"
else
  boot_part="${OUTPUT_DEVICE}1"
  rootfs_part="${OUTPUT_DEVICE}2"
fi

info "Creating boot filesystem"
mkfs.vfat "$boot_part"

info "Creating root filesystem"
mkfs.ext4 "$rootfs_part"

if [ ! -d "mnt" ]; then
  mkdir "$BUILD_DIR"
fi

info "Mounting root partition"
mount -t ext4 -o rw,defaults,noatime "$rootfs_part" "$BUILD_DIR"
