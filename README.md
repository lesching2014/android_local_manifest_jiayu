Local manifest for Jiayu s3 (Lineage os 14.1) 


Initialize a repository with LineageOS:

repo init -u https://github.com/LineageOS/android -b cm-14.1

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
export JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx8g"
export     ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx3G"
./prebuilts/sdk/tools/jack-admin kill-server
./prebuilts/sdk/tools/jack-admin start-server
source build/envsetup.sh
breakfast s3_h560
brunch s3_h560
```

.jack-settings
```
# Server settings
SERVER_HOST=127.0.0.1
SERVER_PORT_SERVICE=8076
SERVER_PORT_ADMIN=8077
SERVER_NB_COMPILE=1

# Internal, do not touch
SETTING_VERSION=4
```

.jack-server/config-property
```
#
#Thu Apr 27 19:17:32 HKT 2023
jack.server.max-jars-size=104857600
jack.server.max-service=1
jack.server.service.port=8076
jack.server.max-service.by-mem=1\=2147483648\:2\=3221225472\:3\=4294967296
jack.server.admin.port=8077
jack.server.config.version=2
jack.server.time-out=7200
```
