# SR Robot Base System

Scripts used to create a system image for SR brain board SD cards.

## Requirements

- bash
- debootstrap
- f2fs-tools
- fdisk

You will also need to be running a system which is either ARM native or have binfmt_misc set up on your system. On Debian, this can be set up by installing `qemu-user-static`.

If you would like to run this under Docker, you can do so using [multiarch/qemu-user-static](https://github.com/multiarch/qemu-user-static).
