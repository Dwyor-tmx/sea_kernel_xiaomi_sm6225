export TZ='Asia/Jakarta'
BUILDDATE=$(date +%Y%m%d)
# BUILDTIME=$(date +%H%M)

# Install dependencies
sudo apt update && sudo apt install -y bc cpio nano bison ca-certificates curl flex gcc git libc6-dev libssl-dev openssl python-is-python3 ssh wget zip zstd sudo make clang gcc-arm-linux-gnueabi software-properties-common build-essential libarchive-tools gcc-aarch64-linux-gnu

# clone clang and gcc
# AOSP clang
# git clone --depth=1 https://gitlab.com/anandhan07/aosp-clang.git clang-llvm
# use weebX clang now lol
# wget "$(curl -s https://raw.githubusercontent.com/XSans0/WeebX-Clang/main/main/link.txt)" -O "weebx-clang.tar.gz"
#mkdir clang-llvm && tar -xf weebx-clang.tar.gz -C clang-llvm && rm -rf weebx-clang.tar.gz
# curl https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/main/clang-r510928.tar.gz -RLO && tar -C clang-llvm/ -xf clang-*.tar.gz

# Set variable
export KBUILD_BUILD_USER=Notlooshy
export KBUILD_BUILD_HOST=Arch

# Build
# Prepare
make -j$(nproc --all) O=out ARCH=arm64 CC=$(pwd)/clang/bin/clang CROSS_COMPILE=aarch64-linux-gnu- CLANG_TRIPLE=aarch64-linux-gnu- LLVM_IAS=1 vendor/fog-perf_defconfig
# Execute
make -j$(nproc --all) O=out ARCH=arm64 CC=$(pwd)/clang/bin/clang CROSS_COMPILE=aarch64-linux-gnu- CLANG_TRIPLE=aarch64-linux-gnu- LLVM_IAS=1 2>&1 | tee output.log
git clone --depth=1 https://github.com/Dwyor-tmx/AnyKernel3-680 -b master AnyKernel3
cp -R out/arch/arm64/boot/Image.gz AnyKernel3/Image.gz
# Zip it and upload it
cd AnyKernel3
zip -r9 Prism-kernel+KSU-"$BUILDDATE" . -x ".git*" -x "README.md" -x "*.zip"
curl -T Prism-kernel+KSU-"$BUILDDATE".zip -u :e3e81e86-d14d-4354-b989-db2c8f7e237f https://pixeldrain.com/api/file/
# finish
cd ..
echo "Build finished"
