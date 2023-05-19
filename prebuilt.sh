#!/bin/bash

# Install Java 8 and change default
sudo apt-get install openjdk-8-jdk
sudo update-alternatives --config java

# Turn on OMS Support
read -p "Do you want to turn on OMS support? [Y,n]" -i Y input
if [[ $input == "Y" || $input == "y" || $input == "" ]]; then
    cd device/jiayu/s3_h560/patches_mtk/oms
    bash apply-oms.sh
    cd ../../../../..
fi

# Apply Mediatek patches
read -p "Do you want to apply Mediatek patches? [Y,n]" -i Y input
if [[ $input == "Y" || $input == "y" || $input == "" ]]; then
    bash device/jiayu/s3_h560/patches_mtk/revert-patches.sh
    bash device/jiayu/s3_h560/patches_mtk/apply-patches.sh
fi

# Remove TLSv1 and TLSv1.1 from /etc/java-8-openjdk/security/java.security file
FILE=/etc/java-8-openjdk/security/java.security 
if [ -f $FILE ]; then
   echo "File $FILE exists."
   cat $FILE |grep -i "TLSv1, TLSv1.1, "
   sudo chmod 777  $FILE
   sudo sed -i -e 's/TLSv1, TLSv1.1, \(.*\)/\1/' $FILE
   sudo chmod 755  $FILE
   cat $FILE |grep -i "TLSv1, TLSv1.1, "
fi

# Change setting from ~/.jack-settings
FILE=~/.jack-settings 
if [ -f $FILE ]; then
   echo "File $FILE exists."
   sed -i -e 's/^SERVER_PORT_SERVICE=.*/SERVER_PORT_SERVICE=8386/g' $FILE
   sed -i -e 's/^SERVER_PORT_ADMIN=.*/SERVER_PORT_ADMIN=8387/g' $FILE
   sed -i -e '/^SERVER_PORT_ADMIN=.*/a SERVER_NB_COMPILE=1' $FILE
   sed -i -e '/^SERVER_NB_COMPILE=1/a JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx8192m"' $FILE
else
   echo "File $FILE does not exist."
   echo "# Server settings" > $FILE
   echo "SERVER_HOST=127.0.0.1" >> $FILE
   echo "SERVER_PORT_SERVICE=8386" >> $FILE
   echo "SERVER_PORT_ADMIN=8387" >> $FILE
   echo "SERVER_NB_COMPILE=1" >> $FILE
   echo "JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx8192m"" >> $FILE
   echo "" >> $FILE
   echo "# Internal, do not touch" >> $FILE
   echo "SETTING_VERSION=4" >> $FILE
fi

# Change setting from ~/.jack-server/config.properties
FILEPATH=~/.jack-server/
FILE=$FILEPATH/config.properties
if [ -f $FILE ]; then
   echo "File $FILE exists."
   sed -i -e 's/^jack.server.max-service=.*/jack.server.max-service=1/g' $FILE
   sed -i -e 's/^jack.server.service.port=.*/jack.server.service.port=8386/g' $FILE
   sed -i -e 's/^jack.server.admin.port=.*/jack.server.admin.port=8387/g' $FILE
else
   echo "File $FILE does not exist."
   mkdir -p $FILEPATH
   echo "#" > $FILE
   echo "# $(date +'%a %b %d %T %Z %Y')" >> $FILE
   echo "jack.server.max-jars-size=104857600" >> $FILE
   echo "jack.server.max-service=1" >> $FILE
   echo "jack.server.service.port=8386" >> $FILE
   echo "jack.server.max-service.by-mem=1\=2147483648\:2\=3221225472\:3\=4294967296" >> $FILE
   echo "jack.server.admin.port=8387" >> $FILE
   echo "" >> $FILE
   echo "jack.server.config.version=2" >> $FILE
   echo "jack.server.time-out=7200" >> $FILE
fi
