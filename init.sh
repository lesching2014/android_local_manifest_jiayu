#!/bin/bash

script=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "Select lineage version"
echo "1. lineageos 14.1"
echo "2. lineageos 15.1"
echo "3. android 8.1.0"
read -p "Choose your option:[1-3]" input
echo ""
read -p "Do you wnat to include GAPPS?[y/N]" opengapps
echo ""
read -p "Do you wnat to include MAGISK?[y/N]" magisk
echo ""

cd ..
if [[ "$input" == "1" ]]; then
    branch=cm-14.1
    pathname=lineage-14.1
elif [[ "$input" == "2" ]]; then
    branch=lineage-15.1
    pathname=lineage-15.1
elif [[ "$input" == "3" ]]; then
    branch=android-8.1.0_r81
    pathname=android-8.1.0
else
    pathname=""
fi
mkdir -p $pathname
cd $pathname

if [[ "$pathname" != "" ]]; then
    if [ -z "$(git config user.name)" ]; then
        read -p -t 10 "Input display name:[anonymous]" input
        if [ -z "$input" ]; then
            input="anonymous"
        fi
        git config --global user.name $input
    fi
    if [ -z "$(git config user.email)" ]; then
        read -p -t 10 "Input email address:[anonymous@example.com]" input
        if [ -z "$input" ]; then
            input="anonymous@example.com"
        fi
        git config --global user.email $input
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

    if [ ! -f "$HOME/bin/repo" ]; then
        mkdir -p "$HOME/bin"
        curl https://storage.googleapis.com/git-repo-downloads/repo > "$HOME/bin/repo"
        chmod a+x "$HOME/bin/repo"

        FILE="$HOME/.profile"
        if [ -d "$HOME/bin" ] ; then
            echo PATH="$HOME/bin:$PATH" >> $FILE
        fi
        source $FILE
    fi

    repo init --depth=1 --manifest-url=https://github.com/LineageOS/android -b $branch
    mkdir -p .repo/local_manifests
    cp -f ../android_local_manifest_jiayu/$pathname.xml .repo/local_manifests
    # repo forall -vc "git reset --hard"
    if [[ "$opengapps" == "y" ]] || [[ "$opengapps" == "Y" ]]; then
        cp -f ../android_local_manifest_jiayu/opengapps.xml .repo/local_manifests
    fi
    if [[ "$magisk" == "y" ]] || [[ "$magisk" == "Y" ]]; then
        cp -f ../android_local_manifest_jiayu/magisk.xml .repo/local_manifests
    fi    
    newer=$(repo --version | grep -oP '(?<=repo version v).*')
    current=$(repo --version | grep -oP '(?<=repo launcher version ).*')
    if [[ "$newer" != "" ]] && [[ "$newer" != "$current" ]] ; then
        repopath=$(which repo)
        if [ "$repopath" ] ; then
            cp -f .repo/repo/repo $repopath
        fi
    fi
fi

cd $script
