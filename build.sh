#!/bin/bash

# Custom Kernel build script

# Constants
green='\033[01;32m'
red='\033[01;31m'
cyan='\033[0;36m'
yellow='\033[0;33m'
blue='\033[0;34m'
default='\033[0m'

# Resources
ANDROID_DIR=~/android
KERNEL_DIR=$PWD
IMAGE=$KERNEL_DIR/arch/arm64/boot/Image
DTBTOOL=$KERNEL_DIR/scripts/dtbTool
TOOLCHAIN=$ANDROID_DIR/ubertc/bin
STRIP=$TOOLCHAIN/aarch64-linux-android-strip

#Paths
OUT_DIR=$KERNEL_DIR/AnyKernel2
OUT_ZIP=$KERNEL_DIR/Releases
MODULES_DIR=$OUT_DIR/modules/system/lib/modules

# Kernel Version Info
BASE="Astral-Kernel"
CUR_VER="-6.0.3"
AK_VER="$BASE$CUR_VER"


# Variables

DEFCONFIG="ak_defconfig"
export LOCALVERSION=~`echo $AK_VER`
export CROSS_COMPILE=$TOOLCHAIN/aarch64-linux-android-
export ARCH=arm64
export USE_CCACHE=1
export CCACHE_DIR="/home/matt/.ccache"
export KBUILD_BUILD_USER="TheOTO"
export KBUILD_BUILD_HOST="XDA-Developers"

function make_ak {
		echo -e "${green}"
		echo "**********    Compiling $AK_VER    **********"
		echo
		make $DEFCONFIG
		make menuconfig
		make -j2
		rm -rf $OUT_DIR/Image
		cp -vr $IMAGE $OUT_DIR
		make_modules
		make_dtb
		make_zip
		housekeeping
		echo -e "${green}"
		echo "**********    Build complete!    **********"
		echo -e "${default}"
}

function make_clean {
		echo -e "${green}"
		echo "**********    Cleaning up the build    **********"
		echo -e "${default}"
		echo
		make clean && make mrproper
		git clean -f -d > /dev/null 2>&1
}

function make_modules {
		echo -e "${cyan}"
		echo "**********    Building modules...    **********"
		if [ -f "$MODULES_DIR/*.ko" ]; then
			rm `echo $MODULES_DIR"/*.ko"`
		fi
		cd $KERNEL_DIR
		find -name '*.ko' -exec cp -v {} $MODULES_DIR \;
		cd $MODULES_DIR
		$STRIP --strip-unneeded *.ko
		cd $KERNEL_DIR
}

function make_dtb {
		echo -e "${blue}"
		echo "**********    Creating dt.img...    **********"
		rm -rf $OUT_DIR/dt.img
		$DTBTOOL -v -s 2048 -o $OUT_DIR/dt.img -p scripts/dtc/ arch/arm64/boot/dts/
}

function make_zip {
		echo -e "${yellow}"
		echo "**********    Zipping up...    **********"
		cd $OUT_DIR
		rm -f '*.zip'
		zip -yr Astral-Kernel`echo $CUR_VER`.zip *
		mv Astral-Kernel`echo $CUR_VER`.zip $OUT_ZIP
		echo -e "${default}"
		echo -e "${red}"
		echo "+++   Find your zip in Releases directory   +++"
		echo -e "${default}"
		cd $KERNEL_DIR
}

function housekeeping {
		echo -e "${green}"
		echo "**********    Cleaning up the mess created...    **********"
		echo -e "${default}"
		rm -rf $OUT_DIR/Image
		rm -rf $OUT_DIR/dt.img
}


BUILD_START=$(date +"%s")
while read -p " Choose 'Y' to compile all , 'C' to clean all , or 'N' to exit = " choice
do
case "$choice" in
	y|Y)
		make_ak
		break
		;;
	c|C )
		make_clean
		break;
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid selection"
		echo
		;;
esac
done
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "${green}"
echo "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo -e "${default}"
