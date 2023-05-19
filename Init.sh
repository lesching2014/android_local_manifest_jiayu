#!/bin/bash

# Initialize a repository with LineageOS
repo init -u https://github.com/LineageOS/android -b cm-14.1
git clone https://github.com/lesching2014/android_local_manifest_jiayu
mkdir .repo/local_manifests
cp android_local_manifest_jiayu/local_manifests.xml .repo/local_manifests
repo forall -vc "git reset --hard"
read -p "Do you want to sync NOW? [Y,n]" -i Y input
if [[ $input == "Y" || $input == "y" ]]; then
    repo sync 
fi
