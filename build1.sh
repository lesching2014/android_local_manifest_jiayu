#repo forall -c git lfs pull
#for d in ./*/ ; do (cd "$d" && git lfs pull); done

echo "Select lineage version"
echo "1. lineageos 14.1"
echo "2. lineageos 15.1"
read -p "Choose your option:[1,2]" input

cd ../
if [[ "$input" == "1" ]]; then
    cd lineage-14.1
elif [[ "$input" == "2" ]]; then
    cd lineage-15.1
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
brunch s3_h560
