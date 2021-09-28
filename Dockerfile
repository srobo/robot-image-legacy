FROM archlinux:latest
RUN pacman-key --init
RUN pacman-key --populate archlinux
RUN pacman -Syu --noconfirm curl gptfdisk arch-install-scripts uboot-tools python dosfstools btrfs-progs parted
RUN curl -LO http://mirror.archlinuxarm.org/armv6h/core/archlinuxarm-keyring-20140119-1-any.pkg.tar.xz
RUN pacman -U --noconfirm archlinuxarm-keyring-20140119-1-any.pkg.tar.xz
RUN rm archlinuxarm-keyring-20140119-1-any.pkg.tar.xz
RUN pacman-key --populate archlinuxarm
