# SR Robot Base System

Scripts used to create a system image for SR brain board SD cards.

## Requirements

- bash
- curl
- [arch-install-scripts](https://archlinux.org/packages/extra/any/arch-install-scripts/)
- fdisk

You will also need to be running a system which is either running on an ARM platform (armv7 or newer) or have binfmt_misc set up on your system. 

You can do this on arch by installing the [qemu-user-static-bin AUR package](https://aur.archlinux.org/packages/qemu-user-static-bin/)

If you would like to run this under Docker, you can do so using [multiarch/qemu-user-static](https://github.com/multiarch/qemu-user-static).
