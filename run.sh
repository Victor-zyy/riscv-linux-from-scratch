#!/usr/bin/bash

QEMU_DIR=/opt/riscv-qemu-7.0.0/bin
OPENSBI_DIR=~/repo/qemu-opensbi/build/platform/generic/firmware
UBOOT_DIR=~/repo/u-boot/
ROOTFS_DIR=~/repo/riscv-linux-from-scratch
ROOTFS_FLASH_DIR=~/repo/riscv-linux-from-scratch/flash
DTB_DIR=~/repo/riscv-linux-from-scratch/flash/dtb

if [ "$1" = "debug" ]; then
  DEBUG="-gdb tcp::26000 -D qemu.log -S"
fi

$QEMU_DIR/qemu-system-riscv64 \
    -M virt \
    -m 1G \
    -nographic \
    -smp 1 \
    -bios $OPENSBI_DIR/fw_jump.bin \
    -serial mon:stdio \
    -kernel $UBOOT_DIR/u-boot-nodtb.bin \
    -drive file=$ROOTFS_DIR/rootfs.img,format=raw,id=hd0 \
    -drive if=pflash,unit=0,format=raw,file=$ROOTFS_FLASH_DIR/fw.img \
    -device virtio-blk-device,drive=hd0 \
    -append "root=/dev/vda rw console=ttyS0" $DEBUG
