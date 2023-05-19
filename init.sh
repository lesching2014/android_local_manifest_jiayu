#!/bin/bash

# git clone https://github.com/lesching2014/android_local_manifest_jiayu
# cp -f ./android_local_manifest_jiayu/init.sh init.sh
# cp -f ./android_local_manifest_jiayu/prebuilt.sh prebuilt.sh
# cp -f ./android_local_manifest_jiayu/build.sh build.sh

# Initialize a repository with LineageOS
repo init --depth 1 -u https://github.com/LineageOS/android -b cm-14.1
mkdir .repo/local_manifests
cp -f android_local_manifest_jiayu/local_manifests.xml .repo/local_manifests
repo forall -vc "git reset --hard"
