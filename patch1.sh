#!/bin/bash

script=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "Select lineage version"
echo "1. lineageos 14.1"
echo "2. lineageos 15.1"
echo "3. android-7.1"
echo "4. android-8.1"
read -p "Choose your option:[1-4]" input

if [[ "$input" == "1" || "$input" == "2" || "$input" == "3" || "$input" == "4" ]]; then
cd ..
if [[ "$input" == "1" ]]; then
    cd lineage-14.1
elif [[ "$input" == "2" ]]; then
    cd lineage-15.1
elif [[ "$input" == "3" ]]; then
    cd android-7.1
elif [[ "$input" == "4" ]]; then
    cd android-8.1
fi

cd device/jiayu/s3_h560/patches_mtk
bash install.sh
cd ../../../..

cd vendor/opengapps/sources
for d in ./*/ ; do (cd "$d" && git lfs pull); done
cd ../../..
fi
