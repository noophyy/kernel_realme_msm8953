#!/bin/bash
# copy right by zetaxbyte
# you can rich me on telegram t.me/@zetaxbyte
# flags of proton clang

cyan="\033[96m"
green="\033[92m"
red="\033[91m"
blue="\033[94m"
yellow="\033[93m"

echo -e "$cyan===========================\033[0m"
echo -e "$cyan= START COMPILING KERNEL  =\033[0m"
echo -e "$cyan===========================\033[0m"

echo -e "$blue...LOADING...\033[0m"

echo -e -ne "$green## (10%\r"
sleep 0.7
echo -e -ne "$green#####                     (33%)\r"
sleep 0.7
echo -e -ne "$green#############             (66%)\r"
sleep 0.7
echo -e -ne "$green#######################   (100%)\r"
echo -ne "\n"

echo -e -n "$yellow\033[104mPRESS ENTER TO CONTINUE\033[0m"
read P
echo  $P

# change DEFCONFIG to you are defconfig name or device codename

DEFCONFIG="mikasa_defconfig"

# you can set you name or host name(optional)

export KBUILD_BUILD_USER=Nop
export KBUILD_BUILD_HOST=Notedphy

mkdir -p out
make O=out ARCH=arm64 $DEFCONFIG

make -j$(nproc --all) O=out ARCH=arm64  CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi- 2>&1 | tee log.txt

if [ -f out/arch/arm64/boot/Image.gz ] ; then
    echo -e "$cyan===========================\033[0m"
    echo -e "$cyan=  SUCCESS COMPILE KERNEL =\033[0m"
    echo -e "$cyan===========================\033[0m"
else
echo -e "$red!ups...something wrong!?\033[0m"
fi
