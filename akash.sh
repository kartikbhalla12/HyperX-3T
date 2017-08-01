#!/bin/bash
rm .version
# Bash Color
green='\033[01;32m'
red='\033[01;31m'
cyan='\033[01;36m'
blue='\033[01;34m'
blink_red='\033[05;31m'
restore='\033[0m'

clear

# Resources
THREAD="-j$(grep -c ^processor /proc/cpuinfo)"
DEFCONFIG="HyperX_oneplus3_defconfig"
KERNEL="Image.gz-dtb"

# Hyper Kernel Details
BASE_VER="HyperX"
VER="-$(date +"%Y-%m-%d"-%H%M)-"
TC="Linaro-7.x"
K_VER="$BASE_VER$VER$TC"


# Vars
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER=TheDemon
export KBUILD_BUILD_HOST=Kek


# Paths
KERNEL_DIR=`pwd`
RESOURCE_DIR="/home/kartikbhalla12/pa"
ANYKERNEL_DIR="/home/kartikbhalla12/anykernel"
TOOLCHAIN_DIR="/home/kartikbhalla12/tc/aarch64-linux-gnu"
REPACK_DIR="$ANYKERNEL_DIR"
PATCH_DIR="$ANYKERNEL_DIR/patch"
ZIP_MOVE="$RESOURCE_DIR/kernel_out"
ZIMAGE_DIR="$KERNEL_DIR/arch/arm64/boot"


# Functions
function make_kernel {
		make $DEFCONFIG $THREAD
                make $THREAD
		cp -vr $ZIMAGE_DIR/$KERNEL $REPACK_DIR/zImage
}


function make_zip {
		cd $REPACK_DIR
                zip -r `echo $K_VER`.zip *
                mkdir $ZIP_MOVE
		mv  `echo $K_VER`.zip $ZIP_MOVE
		cd $KERNEL_DIR
}

DATE_START=$(date +"%s")

		export CROSS_COMPILE=$TOOLCHAIN_DIR/bin/aarch64-linux-gnu-
		export LD_LIBRARY_PATH=$TOOLCHAIN_DIR/lib/
		rm -rf $ZIP_MOVE/*
		cd $ANYKERNEL_DIR
		rm -rf zImage
                cd $KERNEL_DIR
		echo "Compiling HyperX"

echo -e "${restore}"

		make_kernel
		make_zip

echo -e "${green}"
echo $K_VER$TC.zip
echo "------------------------------------------"
echo -e "${restore}"

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo " "
cd $ZIP_MOVE
ls
