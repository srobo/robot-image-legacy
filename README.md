# SR Robot Base System

[![Image Build](https://github.com/srobo/robot-base/actions/workflows/image.yml/badge.svg)](https://github.com/srobo/robot-base/actions/workflows/image.yml)
[![Lint](https://github.com/srobo/robot-base/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/srobo/robot-base/actions/workflows/shellcheck.yml)

Scripts used to create a system image for SR brain board SD cards.

## Requirements

- bash
- curl
- fdisk
- [arch-install-scripts](https://archlinux.org/packages/extra/any/arch-install-scripts/)
- [archlinuxarm-keyring (AUR)](https://aur.archlinux.org/packages/archlinuxarm-keyring/)

You will also need to be running a system which is either running on an ARM platform (armv7 or newer) or have `binfmt_misc` set up on your system. 

You can do this on arch by installing the [qemu-user-static-bin AUR package](https://aur.archlinux.org/packages/qemu-user-static-bin/)

If you would like to run this under Docker, you can do so using [multiarch/qemu-user-static](https://github.com/multiarch/qemu-user-static).
