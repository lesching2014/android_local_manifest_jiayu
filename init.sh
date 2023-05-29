#!/bin/bash

mkdir -p ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo

FILE=~/.profile
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    echo PATH="$HOME/bin:$PATH" >> $FILE
fi
source $FILE

# Initialize a repository with LineageOS
repo init --depth=1 --manifest-url=https://github.com/LineageOS/android -b cm-14.1
mkdir -p .repo/local_manifests
cp -f android_local_manifest_jiayu/local_manifests.xml .repo/local_manifests
# repo forall -vc "git reset --hard"
