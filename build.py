#!/usr/bin/env python3
import argparse
import atexit
import os
import re
import subprocess
from pathlib import Path
from shutil import copytree, rmtree
from typing import List

REPO_DIR = Path(__file__).absolute().parent
IMAGE_OUTPUT_SIZE = "8G"
PLATFORM = "odroid"
# Either a block device or disk image file
OUTPUT_DEVICE = subprocess.check_output(['losetup', '-f']).decode()
IS_BLOCK_DEVICE = True
STAGE_REGEX = re.compile("^stage([0-9]+)-([a-z0-9]+)$")


def cleanup(build_dir):
    subprocess.run(
        ["umount", build_dir],
    )
    if not IS_BLOCK_DEVICE:
        subprocess.run(
            ["losetup", "-d", OUTPUT_DEVICE],
        )


def determine_stage_list(platform: str) -> List[Path]:
    stage_list = []
    for stage in sorted(REPO_DIR.glob("stage*")):
        if match := STAGE_REGEX.match(stage.name):
            num, plat = match.groups()
            if num == "0" and plat == platform:
                stage_list.append(stage)
        else:
            stage_list.append(stage)
    return stage_list


def run_stage(stage: Path, environment, build_dir):
    stage_path = build_dir / "stage"
    for i in [str(x).zfill(2) for x in range(100)]:

        for run_script in stage.glob(f"{i}-host_*.sh"):
            subprocess.run(
                [str(run_script)],
                cwd=REPO_DIR,
                env=environment,
            )

        for run_script in stage.glob(f"{i}-chroot_*.sh"):
            copytree(stage, stage_path)
            subprocess.run(
                ["arch-chroot", str(args.build_dir), f"/stage/{run_script.name}"],
                cwd=REPO_DIR,
                env=environment,
            )
            rmtree(stage_path)

        for run_script in stage.glob(f"{i}-packages*"):
            subprocess.run(
                ["arch-chroot", str(args.build_dir), "pacman", "-S", "--noconfirm"]
                + run_script.open("r").read().splitlines(),
                cwd=REPO_DIR,
                env=environment,
            )


if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "-v",
        "--verbose",
        help="increase output verbosity",
        action="store_true",
    )
    parser.add_argument(
        "-d",
        "--build-dir",
        help="build directory",
        type=Path,
        default=REPO_DIR / "mnt",
    )
    parser.add_argument(
        "-c",
        "--cache-dir",
        help="cache directory",
        type=Path,
        default=REPO_DIR / "cache",
    )
    parser.add_argument(
        "output_file",
        help="file to write image to",
        type=Path,
    )
    args = parser.parse_args()

    print("SR Image Builder")
    print(f"Build directory: {args.build_dir}")

    stages = determine_stage_list(PLATFORM)

    if args.output_file.is_block_device():
        OUTPUT_DEVICE = str(args.output_file)

    existing_path = os.environ["PATH"]
    environment = {
        "OUTPUT_DEVICE": OUTPUT_DEVICE,
        "IMAGE_OUTPUT_SIZE": IMAGE_OUTPUT_SIZE,
        "IMAGE_OUTPUT_PATH": str(args.output_file),
        "BUILD_DIR": str(args.build_dir),
        "CACHE_DIR": str(args.cache_dir),
    }

    atexit.register(cleanup, args.build_dir)

    for stage in stages:
        run_stage(stage, environment, args.build_dir)
