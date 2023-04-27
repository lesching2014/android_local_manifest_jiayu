Local manifest for Jiayu s3 (Lineage os 14.1) 


Initialize a repository with LineageOS:

repo init -u git://github.com/LineageOS/android.git -b cm-14.1

git clone https://github.com/lesching2014/android_local_manifest_jiayu

mkdir .repo/local_manifests

cp android_local_manifest_jiayu/local_manifests.xml .repo/local_manifests

repo forall -vc "git reset --hard"

repo sync 

Build the code:

turn on OMS Support:
```
cd device/jiayu/s3_h560/patches_mtk/oms
sh apply-oms.sh
cd ../../../../..
```

insert Mediatek patches:
```
sh device/jiayu/s3_h560/patches_mtk/revert-patches.sh
sh device/jiayu/s3_h560/patches_mtk/apply-patches.sh
```

build ROM:
```
sudo apt-get install openjdk-8-jdk
export LC_ALL=C
source build/envsetup.sh
breakfast s3_h560
brunch s3_h560
```

