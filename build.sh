#!/bin/bash

# export     ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx3G"
# export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
# export PATH=$JAVA_HOME/bin:$PATH

# Increase Java maximum memory to 4G
read -p "Do you want to increase to 4G? [Y,n]" -i Y IncreaseAns

# Build ROM
echo "Building ROM"
echo "1. boot image only"
echo "2. recovery image only"
echo "3. system image only"
echo "4. all image (boot + recovery + system)"
read -p "Choose your option:[Enter key:4]" input

if [[ $IncreaseAns == "Y" || $IncreaseAns == "y" || $IncreaseAns == "" ]]; then
    export JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx8g"
    # ./prebuilts/sdk/tools/jack-admin kill-server
    # ./prebuilts/sdk/tools/jack-admin start-server
fi
export LC_ALL=C
source build/envsetup.sh
breakfast s3_h560

case $input in  
  1) make -j4 bootimage ;; 
  2) make -j4 recoveryimage ;; 
  3) make -j4 systemimage ;;
  4|"") brunch s3_h560 ;;  
  *) echo dont know ;; 
esac
