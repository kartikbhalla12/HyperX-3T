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
TIME="-$(date +"%Y-%m-%d"-%H%M)-"
TC="Linaro-7.x"


# Vars
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER=TheDemon
export KBUILD_BUILD_HOST=Kek
# Paths
KERNEL_DIR=`pwd`
RESOURCE_DIR="/home/kartikbhalla12/pa"
ANYKERNEL_DIR="/home/kartikbhalla12/anykernel"
TOOLCHAIN_DIR="/home/kartikbhalla12/linaro-7.x"
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
echo -e " "
echo -n " INPUT THE VERSION : "
read VER
echo -e " "
echo -e " SELECT ONE OF THE FOLLOWING TYPES TO BUILD : "
echo -e " 1.BETA"
echo -e " 2.STABLE"
echo -e " 3.TEST"
echo -n " YOUR CHOICE : ? "
read type
echo -e " "
echo -e " SELECT ONE OF THE FOLLOWING TYPES TO BUILD : "
echo -e " 1.PA"
echo -e " 2.OTHER"
echo -n " YOUR CHOICE : ? "
read rom
case $type in
1) echo -e "                            BETA"
   echo -e "                           BUILDING NOW .."
	echo -n " INPUT NUMBER : "
	read no
	ch="BETA_$no-" ;;
2) echo -e "                            STABLE"
   echo -e "                          BUILDING NOW .."
	ch="STABLE-";;

3) echo -e "                            TEST"
   echo -e "                          BUILDING NOW .."
	value=`cat test_no.txt`
	ch="TEST_$value-"
	value=$((value+1))
	echo "$value" > "test_no.txt";;
esac

case $rom in
1) echo -e "                            CHECKING OUT TO PA BRANCH"
   echo -e "                          BUILDING NOW .."
	ch2="-PA"
   git checkout HyperX-PA ;;
2) echo -e "                            CHECKING OUT TO ALPHA BRANCH"
   echo -e "                          BUILDING NOW .."
	ch2=""
   git checkout HyperX-alpha ;;
esac
		K_VER="$BASE_VER$ch2-v$VER-$ch$TC"
                export CROSS_COMPILE=$TOOLCHAIN_DIR/bin/aarch64-linaro-linux-gnu-
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
echo $K_VER.zip
echo "------------------------------------------"
echo -e "${restore}"
DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo " "
cd $ZIP_MOVE
curl --upload-file * https://transfer.sh
cd ..
