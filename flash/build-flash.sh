#!/usr/bin/bash 

OPENSBI_DIR=~/repo/qemu-opensbi/build/platform/generic/firmware
UBOOT_DIR=~/repo/u-boot/
ROOTFS_DIR=~/repo/riscv-linux-from-scratch/flash
DTB_DIR=~/repo/riscv-linux-from-scratch/flash/dtb 
CROSS_PREFIX=riscv64-linux-gnu
$CROSS_PREFIX-gcc -fno-asynchronous-unwind-tables -fno-pic -fno-builtin -fdata-sections -ffunction-sections -static -ggdb -x assembler-with-cpp -c crt0.S -o crt0.o

$CROSS_PREFIX-ld -T./boot.ld -Map=crt0.map --gc-sections crt0.o -o crt0.elf
$CROSS_PREFIX-objcopy -O binary -S crt0.elf crt0.bin

rm $ROOTFS_DIR/jffs2/Image
cp ~/repo/linux-5.15.175/arch/riscv/boot/Image $ROOTFS_DIR/jffs2/
mkfs.jffs2 -s 0x100 -e 0x40000 -n -p 0x1f00000 -d $ROOTFS_DIR/jffs2 -o jffs2.img 
# dbt device tree compile
#dtc -I dts -O dtb $DTB_DIR/qemu_board_uboot.dts -o $DTB_DIR/qemu_board_uboot.dtb
dtc -I dts -O dtb $DTB_DIR/qemu_virt.dts -o $DTB_DIR/qemu_board_uboot.dtb
#dd of=fw.img bs=1k count=32k if=/dev/zero
tr '\000' '\377' < /dev/zero | dd of=fw.img bs=1k count=32k > /dev/null
dd of=fw.img bs=1k conv=notrunc seek=0 if=$ROOTFS_DIR/crt0.bin
dd of=fw.img bs=1k conv=notrunc seek=512 if=$DTB_DIR/qemu_board_uboot.dtb
dd of=fw.img bs=1k conv=notrunc seek=1k if=$ROOTFS_DIR/jffs2.img
