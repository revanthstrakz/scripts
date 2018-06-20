#!/bin/bash
source "env.sh";
alias setperf='echo "performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'
alias setsave='echo "powersave" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'

# Set timezone
export TZ="Asia/Kolkata";

# Colors
black='\e[0;30m'
blue='\e[0;34m'
green='\e[0;32m'
cyan='\e[0;36m'
red='\e[0;31m'
purple='\e[0;35m'
brown='\e[0;33m'
lightgray='\e[0;37m'
darkgray='\e[1;30m'
lightblue='\e[1;34m'
lightgreen='\e[1;32m'
lightcyan='\e[1;36m'
lightred='\e[1;31m'
lightpurple='\e[1;35m'
yellow='\e[1;33m'
white='\e[1;37m'
nc='\e[0m'

function transfer() {

zipname="$(echo $1 | awk -F '/' '{print $NF}')";
url="$(curl -# -T $1 https://transfer.sh)";
printf '\n';
echo -e "Download $zipname at $url";
}

sudo apt-get update -y
sudo add-apt-repository --yes ppa:webupd8team/java
sudo apt-get install -y oracle-java9-installer
sudo apt install -y oracle-java9-set-default
sudo apt-get install -y libncurses5-dev
sudo apt-get install -y git-core gnupg flex bison gperf
sudo apt-get install -y build-essential
sudo apt-get install -y zip
sudo apt-get install -y curl 
sudo apt-get install -y libc6-dev
sudo apt-get install -y libncurses5-dev:i386 
sudo apt-get install -y x11proto-core-dev libx11-dev:i386 libreadline6-dev:i386
sudo apt-get install -y libgl1-mesa-glx:i386 libgl1-mesa-dev 
sudo apt-get install -y g++-multilib tofrodos python-markdown
sudo apt-get install -y libxml2-utils xsltproc zlib1g-dev:i386
sudo  ln -s /usr/lib/i386-linux-gnu/mesa/libGL.so.1 /usr/lib/i386-linux-gnu/libGL.so
sudo apt-get install -y ccache &&echo 'export PATH="/usr/lib/ccache:$PATH"' | tee -a ~/.bashrc &&source ~/.bashrc && echo $PATH
git clone --branch=oreo-mr1 https://github.com/revanthstrakz/StRaKz-KeRnEl-MiDo ~/SK
git clone --branch=opt-gnu-8.x https://github.com/krasCGQ/aarch64-linux-android ~/gcc8opt
mkdir ~/clang
cd ~/clang
wget https://github.com/revanthstrakz/zip/raw/master/dragontc.zip
mv dragontc.zip ~/clang/dragontc.zip
unzip dragontc.zip
export USE_CCACHE=1
export ARCH=arm64
export KD=$HOME/SK
cd $HOME/SK

kernel_dir=${HOME}/SK
export V="-😂🐼-v7-EAS"
export CONFIG_FILE="strakz_defconfig"
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER=ReVaNtH
export KBUILD_BUILD_HOST=StRaKz
export TOOL_CHAIN_PATH="${HOME}/gcc8opt/bin/aarch64-opt-linux-android-"
export CLANG_TCHAIN="${HOME}/clang/bin/clang"
export IMAGE2="${OUTDIR}/arch/${ARCH}/boot/Image.gz";
export CLANG_VERSION="$(${CLANG_TCHAIN} --version | head -n 1 | cut -d'(' -f1,4)"
export LD_LIBRARY_PATH="${TOOL_CHAIN_PATH}/../lib"
export PATH=$PATH:${TOOL_CHAIN_PATH}
export builddir="${kernel_dir}/SK/anykernel"
#export modules_dir="zip/system/lib/modules"
export ZIPPER_DIR="${kernel_dir}/zip"
export ZIP_NAME="StRaKz-KeRnEl™${V}_Oreo.zip"
export ZIPNAME="StRaKz-KeRnEl™${V}_Oreo.zip"
export FINAL_ZIP=${HOME}/SK/SK/anykernel/${ZIPNAME}
export IMAGE="arch/arm64/boot/Image.gz-dtb";
JOBS="-j4"
cd $kernel_dir
make clean && make mrproper

make_a_fucking_defconfig() {
	make $CONFIG_FILE
}

compile() {
	PATH=${BIN_FOLDER}:${PATH} make \
	O=${out_dir} \
	CC="${CLANG_TCHAIN}" \
	CLANG_TRIPLE=aarch64-opt-linux-android- \
	CROSS_COMPILE=${TOOL_CHAIN_PATH} \
    KBUILD_COMPILER_STRING="${CLANG_VERSION}" \
	HOSTCC="${CLANG_TCHAIN}" \
    $JOBS
}


make_a_fucking_defconfig
compile
echo -e "Copying kernel image";
cp -v "${IMAGE}" "${ANYKERNEL}/";
cp -v "${IMAGE2}" "${ANYKERNEL}/";
cp ${OUTDIR}/net/ipv4/tcp_bic.ko ${ANYKERNEL}/
cp ${OUTDIR}/net/ipv4/tcp_htcp.ko ${ANYKERNEL}/
cp ${OUTDIR}/arch/arm64/boot/dts/qcom/msm8953-qrd-sku3-mido-t.dtb ${ANYKERNEL}/
cp ${OUTDIR}/arch/arm64/boot/dts/qcom/msm8953-qrd-sku3-mido-nt.dtb ${ANYKERNEL}/
cp ${OUTDIR}/arch/arm64/boot/dts/msm8953-qrd-sku3-mido-t.dtb ${ANYKERNEL}/
cp ${OUTDIR}/arch/arm64/boot/dts/msm8953-qrd-sku3-mido-nt.dtb ${ANYKERNEL}/

cd -;
cd ${ANYKERNEL};
zip -r9 ${FINAL_ZIP} *;
cd -;

if [ -f "$FINAL_ZIP" ];
then
echo -e "$ZIPNAME zip can be found at $FINAL_ZIP";
echo -e "Uploading ${ZIPNAME} to https://transfer.sh/";
transfer "${FINAL_ZIP}";
else
echo -e "Zip Creation Failed =(";
fi # FINAL_ZIP check 
