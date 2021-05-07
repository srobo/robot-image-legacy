info "Partitioning disk image"
(
  echo o # create a new MS-DOS partition table

  # TODO: Secondary system partition for AB

  # Boot partition
  echo n     # new partition
  echo p     # primary partition
  echo 1     # partition number
  echo 4096  # first sector (accept default)
  echo +200M # last sector
  echo t     # change partition type
  echo 0b    # W95 FAT32 (LBA)

  # Root filesystem
  echo n      # new partition
  echo p      # primary partition
  echo 2      # partition number
  echo 413696 # first sector (accept default)
  echo        # last sector (accept default)

  echo w # write changes
) | /sbin/fdisk "$IMAGE_OUTPUT_PATH" #> /dev/null
