#!/bin/bash

# git clone https://github.com/lesching2014/android_local_manifest_jiayu

# Initialize a repository with LineageOS
repo init --depth 1 -u https://github.com/LineageOS/android -b cm-14.1
mkdir .repo/local_manifests
cp android_local_manifest_jiayu/local_manifests.xml .repo/local_manifests
repo forall -vc "git reset --hard"
read -p "Do you want to sync NOW? [Y,n]" -i Y input
if [[ $input == "Y" || $input == "y" ]]; then
    repo sync 
fi
