Local manifest for Jiayu s3 (Lineage os 14.1) 

Clone local manifest
```
git clone https://github.com/lesching2014/android_local_manifest_jiayu
cp -f ./android_local_manifest_jiayu/init.sh init.sh
cp -f ./android_local_manifest_jiayu/prebuilt.sh prebuilt.sh
cp -f ./android_local_manifest_jiayu/build.sh build.sh
```

Initialize a repository with LineageOS:
```
bash init.sh
```

Prebuild:
```
bash prebuilt.sh
```

Build ROM:
```
bash build.sh
```
