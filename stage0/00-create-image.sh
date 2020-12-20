#!/bin/bash
info "Creating disk image"
fallocate -l 8G out.img

info "Partitioning disk image"
(
  echo g # create a new GPT partition table

  # ESP
  echo n # new partition
  echo 1 # partition number
  echo   # first sector (accept default)
  echo +300M # last sector
  echo t # change partition type
  echo 1 # EFI System

  echo n # new partition
  echo 2 # partition number
  echo   # first sector (accept default)
  echo   # last sector (accept default)
  # TODO: Secondary system partition for AB

  echo w # write changes
) | /sbin/fdisk "$IMAGE_OUTPUT_PATH" > /dev/null

info "Setting up loop device"
sudo losetup -P "$LOOP_DEV" out.img

info "Creating f2fs root filesystem"
mkfs.f2fs "${LOOP_DEV}p2"

if [ ! -d "mnt" ]; then
  mkdir mnt
fi

info "Mounting root partition"
sudo mount -t f2fs -o rw,defaults "${LOOP_DEV}p2" mnt

