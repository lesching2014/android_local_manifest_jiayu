#!/bin/bash

# Initialize a repository with LineageOS
repo init --depth 1 -u https://github.com/LineageOS/android -b cm-14.1
mkdir -p .repo/local_manifests
cp -f android_local_manifest_jiayu/local_manifests.xml .repo/local_manifests
# repo forall -vc "git reset --hard"
