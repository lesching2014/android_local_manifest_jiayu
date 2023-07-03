#repo forall -c git lfs pull
#for d in ./*/ ; do (cd "$d" && git lfs pull); done

echo "Select lineage version"
echo "1. lineageos 14.1"
echo "2. lineageos 15.1"
echo "3. android-7.1"
echo "4. android-8.1"
read -p "Choose your option:[1-4]" input

if [[ "$input" == "1" || "$input" == "2" || "$input" == "3" || "$input" == "4" ]]; then
cd ../
if [[ "$input" == "1" ]]; then
    cd lineage-14.1
elif [[ "$input" == "2" ]]; then
    cd lineage-15.1
elif [[ "$input" == "3" ]]; then
    cd android-7.1
elif [[ "$input" == "4" ]]; then
    cd android-8.1
fi

echo "Method for cleaning out folder"
echo "1. make clean"
echo "2. make installclean"
echo ""
echo "0. no clean made"
read -t 10 -p "Choose your option:[1,2,0](default:0)" -i 0 input

size="30G"
file_swap=/swapfile_$size.img
if [ "$(swapon --show --noheadings | grep "$file_swap" | wc -l)" -lt 1 ]; then
    sudo touch $file_swap && sudo chmod 600 $file_swap && sudo fallocate -l $size /$file_swap && sudo mkswap /$file_swap && sudo swapon -p 20 /$file_swap
fi
source build/envsetup.sh
breakfast s3_h560
case $input in  
  1) make clean ;; 
  2) make install ;; 
  0) ;;
  *) echo dont know ;; 
esac
export ALLOW_MISSING_DEPENDENCIES=true
export JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx8192M"
export     ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx8192M"
export LC_ALL=C
#export CROSS_COMPILE=./aarch64-linux-android-opt-gnu-8.x/bin/aarch64-opt-linux-android-
#export TARGET_KERNEL_CROSS_COMPILE_PREFIX="aarch64-opt-linux-android-"
#export KERNEL_TOOLCHAIN="./aarch64-linux-android-opt-gnu-8.x/bin"


# Increase Java maximum memory to 4G
read -p "Do you want to increase Java memory to 4G? [Y,n]" -i Y IncreaseAns

# Build ROM
echo "Building ROM"
echo "1. boot image only"
echo "2. recovery image only"
echo "3. system image only"
echo "4. all image (boot + recovery + system)"
echo "5. clean"
read -p "Choose your option:[Enter key:4]" input

source build/envsetup.sh
breakfast s3_h560
if [[ $IncreaseAns == "Y" || $IncreaseAns == "y" || $IncreaseAns == "" ]]; then
    ./prebuilts/sdk/tools/jack-admin kill-server
    export JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4G"
fi
export LC_ALL=C

case $input in  
  1) make -j4 bootimage ;; 
  2) make -j4 recoveryimage ;; 
  3) make -j4 systemimage ;;
  4|"") brunch s3_h560 ;;
  5) make clean ;;
  *) echo dont know ;; 
esac
fi
