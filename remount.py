#!/usr/bin/env python3
import argparse
import subprocess
import os
import sys
from tempfile import mkdtemp
from typing import Dict
from pathlib import Path


def check_pkg(mountpoint: str, pkg: str) -> bool:
    """Checks if a package is present in a chroot"""
    try:
        subprocess.check_output(['chroot', str(mountpoint), '/usr/bin/pacman', '-Qqs', pkg])
        return True
    except subprocess.CalledProcessError:
        return False


def determine_platform(mountpoint: str) -> str:
    platform_pkgs = {
        "rpi3": "linux-raspberrypi",
        "rpi4": "linux-raspberrypi4",
        "odroid": "uboot-odroid",
    }

    for platform, pkg in platform_pkgs.items():
        if check_pkg(mountpoint, pkg):
            return platform
    return "odroid"  # default to ODroid U3


def read_build_info(contents: str) -> Dict[str, str]:
    lines = contents.strip().split("\n")
    return dict(map(lambda line: line.split("=", 2), lines))


if __name__ == "__main__":
    if os.geteuid() != 0:
        sys.stderr.write("This script must be run as superuser.\n")
        sys.exit(1)
    
    parser = argparse.ArgumentParser()
    
    parser.add_argument(
        "-c",
        "--chroot",
        help="Enters in to a chroot",
        action="store_true",
    )
    
    parser.add_argument(
        "-n",
        "--no-shell",
        help="Mount without opening a shell or chroot",
        action="store_true",
    )
    
    parser.add_argument(
        "source_file",
        help="Image or block device to remount",
        type=Path,
    )
    args = parser.parse_args()
    
    is_block_device = Path(args.source_file).is_block_device()
    
    dev = args.source_file
    
    if not is_block_device:
        dev = subprocess.check_output(['losetup', '-f']).decode().strip()
        subprocess.run(['losetup', '-P', dev, str(args.source_file)]).check_returncode()
    mount_path = Path(mkdtemp(prefix='robot-build-'))

    mountpoints = {
        '@': '',
        '@home': 'home',
        '@snapshots': '.snapshots',
        '@var_log': 'var/log',
        '@var_srobo': 'var/srobo',
    }
    btrfs_flags = 'rw,defaults,noatime,ssd,compress=zstd'

    if is_block_device:
        boot_part = f"{dev}1"
        root_part = f"{dev}2"
    else:
        boot_part = f"{dev}p1"
        root_part = f"{dev}p2"

    for subvol, mountpoint in mountpoints.items():
        subprocess.run(['mount', '-o', f"{btrfs_flags},subvol={subvol}", root_part, str(mount_path / mountpoint)]).check_returncode()
    subprocess.run(['mount', '-o', 'rw,defaults,noatime', boot_part, str(mount_path / "boot")]).check_returncode()
    
    if not is_block_device:
        print(f"Assigned loop device: {dev}")
    
    if args.no_shell:
        print(str(mount_path))
        exit(0)
    
    print(f"Mounted to {mount_path}")
    print("Press ^D to exit and unmount")
    
    build_info = read_build_info((mount_path / "etc/build-info").read_text())
    
    environment = {
        "BUILD_DIR": str(mount_path),
        "PLATFORM": build_info.get("BUILD_PLATFORM", determine_platform(str(mount_path))),
    }
    
    if args.chroot:
        subprocess.run(['arch-chroot', str(mount_path)], env=environment)
    else:
        subprocess.run(os.environ["SHELL"], cwd=str(mount_path), env=environment)
    
    print("Unmounting")
    subprocess.run(['umount', '-R', str(mount_path)]).check_returncode()
    mount_path.rmdir()
