Local manifest for Jiayu s3 (Lineage os 14.1) 


Initialize a repository with LineageOS:

repo init -u git://github.com/LineageOS/android.git -b cm-14.1

repo clone local_manifests.xml .repo/local_manifests

Copy "s3_h560.xml" under android_src/.repo/local_manifests

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
source build/envsetup.sh
breakfast s3_h560
brunch s3_h560
```

