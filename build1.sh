#repo forall -c git lfs pull
#for d in ./*/ ; do (cd "$d" && git lfs pull); done
size="10G"
file_swap=/swapfile_$size.img
if [ "$(swapon --show --noheadings | grep "$file_swap" | wc -l)" -lt 1 ]; then
    sudo touch $file_swap && sudo chmod 600 $file_swap && sudo fallocate -l $size /$file_swap && sudo mkswap /$file_swap && sudo swapon -p 20 /$file_swap
fi
read input
source build/envsetup.sh
breakfast s3_h560
export JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx8192M"
export     ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx8192M"
export LC_ALL=C
brunch s3_h560
