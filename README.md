Local manifest for Jiayu s3 (LineageOS 14.1) 

Download settings.sh
```
wget https://raw.githubusercontent.com/lesching2014/android_local_manifest_jiayu/master/settings.sh
```

Clone local manifest
```
git clone https://github.com/lesching2014/android_local_manifest_jiayu
```

Install essential packages and Modify settings
```
bash ./android_local_manifest_jiayu/settings.sh
```

Initialize a repository with LineageOS:
```
bash ./android_local_manifest_jiayu/init.sh
```

Synchronize a repository
```
bash ./android_local_manifest_jiayu/sync.sh
```

Prebuild setting
```
bash ./android_local_manifest_jiayu/prebuild.sh
```

Build ROM
```
bash ./android_local_manifest_jiayu/build.sh
```
