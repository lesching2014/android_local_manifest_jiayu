#!/bin/bash

script=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "Select lineage version"
echo "1. lineageos 14.1"
echo "2. lineageos 15.1"
echo "3. android 8.1.0"
read -p "Choose your option:[1-3]" input

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

if [ -d "$PWD/$pathname" ] ; then
    cd $pathname

    newer=$(repo --version | grep -oP '(?<=repo version v).*')
    current=$(repo --version | grep -oP '(?<=repo launcher version ).*')
    if [[ "$newer" != "" ]] && [[ "$newer" != "$current" ]] ; then
        repopath=$(which repo)
        if [ "$repopath" ] ; then
            cp -f .repo/repo/repo $repopath
        fi
    fi

    echo "Repo sync method"
    echo "n. network only"
    echo "l. local only"
    echo "f. full sync"
    read -p "Choose your option:[n,l,F]" input

    case $input in
        n|N) repo sync -n ;; 
        l|L) repo sync -l ;; 
        f|F|"") repo sync ;;
        *) echo dont know ;; 
    esac
fi

cd $script
