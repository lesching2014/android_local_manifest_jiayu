#!/bin/bash

script=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "Select lineage version"
echo "1. lineageos 14.1"
echo "2. lineageos 15.1"
echo "3. android 8.1.0"
read -p "Choose your option:[1-3]" input
echo ""
echo "Select patch method"
echo "c. patch apply -v --check"
echo "i. patch apply -v"
echo "u. git clean -df"
read -p "Choose your option:[C,i,u]" patches
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

if [ -d "$PWD/$pathname" ] ; then
    cd $pathname

    case $patches in
        c|C|"") type="-c" ;; 
        i|I) type="-i" ;; 
        u|U) type="-u" ;;
        *) type=""
        echo dont know 
        ;; 
    esac
    if [[ "$type" != "" ]]; then
        path=$(dirname "$(find ../lineage-14.1 -type f -name 'patch.sh')")
        cd $path
        bash patch.sh $type
    fi
fi

cd $script
