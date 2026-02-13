#!/bin/bash

#URLBASE="https://downloads.openwrt.org"
#RELEASE="/releases/$(cat /etc/openwrt_release | grep DISTRIB_RELEASE | cut -d"'" -f2)/packages/$(cat /etc/apk/arch)/packages/"
mkdir apps
cd apps

mkdir list_apps
cd list_apps

wget https://downloads.openwrt.org/releases/25.12.0-rc3/packages/aarch64_cortex-a53/packages/ -O  packages
cat packages | grep -Eoi 'href="([^"]+)"' | cut -d'"' -f2 | grep .apk > list

while IFS= read -r app; do
    wget "https://downloads.openwrt.org/releases/25.12.0-rc3/packages/aarch64_cortex-a53/packages/$app"
done < list

cd.. 

wget https://downloads.openwrt.org/releases/25.12.0-rc4/targets/mediatek/filogic/openwrt-sdk-25.12.0-rc4-mediatek-filogic_gcc-14.3.0_musl.Linux-x86_64.tar.zst -O openwrt-sdk-25.12.0-rc4-mediatek-filogic_gcc-14.3.0_musl.Linux-x86_64.tar.zst
tar -I zstd -xvf openwrt-sdk-25.12.0-rc4-mediatek-filogic_gcc-14.3.0_musl.Linux-x86_64.tar.zst
cd list_apps

$(pwd)/apps/openwrt-sdk-25.12.0-rc4-mediatek-filogic_gcc-14.3.0_musl.Linux-x86_64/staging_dir/host/bin/apk --allow-untrusted mkndx -o packages.adb *.apk
