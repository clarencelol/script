#!/bin/bash
#
# Script for Illium Kernel by Clarence
#
# USage: . kernel.sh device version
#

export KBUILD_BUILD_USER=Clarence
export KBUILD_BUILD_HOST=Acer@Nitro5

echo "Illium Kernel Buildbot"

LC_ALL=C date +%Y-%m-%d
date=`date +"%Y%m%d-%H%M"`
BUILD_START=$(date +"%s")
KERNEL_DIR=$PWD
REPACK_DIR=$KERNEL_DIR/Anykernel3
OUT=$KERNEL_DIR/out

rm -rf out
mkdir -p out
make O=out clean
make O=out mrproper
make O=out ARCH=arm64 wayne_defconfig
PATH="/home/clarence/proton-clang/bin:${PATH}" \
TOOL_DIR="/home/clarence/proton-clang/"
TOOL="/home/clarence/proton-clang/"
make -j$(nproc --all) O=out \
                      ld-name=lld \
                      ARCH=arm64 \
                      CC=clang \
                      HOSTCC=clang \
                      LD=ld.lld \
                      AR=llvm-ar \
                      NM=llvm-nm \
                      OBJCOPY=llvm-objcopy \
                      OBJDUMP=llvm-objdump \
                      STRIP=llvm-strip \
                      CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
                      CROSS_COMPILE=aarch64-linux-gnu- ;

cd $REPACK_DIR
cp $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb $REPACK_DIR/
FINAL_ZIP="Illium Kernel-EAS-${date}.zip"
zip -r9 "${FINAL_ZIP}" *
cp *.zip $OUT
rm *.zip
cd $KERNEL_DIR
rm Anykernel3/Image.gz-dtb

BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo -e "Done"
