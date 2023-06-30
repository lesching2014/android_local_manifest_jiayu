#!/bin/bash

echo "Select lineage version"
echo "1. lineageos 14.1"
echo "2. lineageos 15.1"
read -p "Choose your option:[1,2]" input

cd ../
if [[ "$input" == "1" ]]; then
    # Initialize a repository with LineageOS
    mkdir -p lineage-14.1
    cd lineage-14.1
elif [[ "$input" == "2" ]]; then
    mkdir -p lineage-15.1
    cd lineage-15.1
fi

if [ -z "$(git config user.name)" ]; then
    git config --global user.name "Your Name"
fi
if [ -z "$(git config user.email)" ]; then
    git config --global user.email "you@example.com"
fi

version=$(python -V 2>&1 | grep -Po '(?<=Python )(.+)')
version2=$(python2 -V 2>&1 | grep -Po '(?<=Python )(.+)')
version3=$(python3 -V 2>&1 | grep -Po '(?<=Python )(.+)')
if [ -z "$version2" ] ; then
    sudo apt install python2.7
    sudo ln -s /usr/bin/python2.7 /usr/bin/python2
fi
version2=$(python2 -V 2>&1 | grep -Po '(?<=Python )(.+)')
if [ "$version" = "$version3" ] ; then
    sudo rm -f /usr/bin/python
fi
version=$(python -V 2>&1 | grep -Po '(?<=Python )(.+)')
if [ -z "$version" ] ; then
    sudo ln -s /usr/bin/python2 /usr/bin/python
fi

mkdir -p ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo

FILE=~/.profile
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    echo PATH="$HOME/bin:$PATH" >> $FILE
fi
source $FILE

if [[ "$input" == "1" ]]; then
    # Initialize a repository with LineageOS
    repo init --depth=1 --manifest-url=https://github.com/LineageOS/android -b cm-14.1
    mkdir -p .repo/local_manifests
    cp -f ../android_local_manifest_jiayu/lineage-14.1.xml .repo/local_manifests
    # repo forall -vc "git reset --hard"
elif [[ "$input" == "2" ]]; then
    # Initialize a repository with LineageOS
    repo init --depth=1 --manifest-url=https://github.com/LineageOS/android -b lineage-15.1
    mkdir -p .repo/local_manifests
    cp -f ../android_local_manifest_jiayu/lineage-15.1.xml .repo/local_manifests
    # repo forall -vc "git reset --hard"
fi

repopath=$(which repo)
if [ "$repopath" ] ; then
    sudo cp -f .repo/repo/repo $repopath 
fi
