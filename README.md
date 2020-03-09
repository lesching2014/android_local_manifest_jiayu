Local manifest for Samsung Galaxy Tab A 2016 (LineageOS 16.0) 


Initialize a repository with LineageOS:

repo init -u git://github.com/LineageOS/android.git -b lineage-16.0

Copy "gtaxlwifi.xml" under android_src/.repo/local_manifests

repo sync 

Build the code:

turn on MicroG Support:
```
device/samsung/gtaxlwifi/patches/revert_patches.sh
device/samsung/gtaxlwifi/patches/apply_patches.sh
```

build ROM:
```
source build/envsetup.sh
brunch gtaxlwifi 
```

