#!/bin/bash

# Config git user's name and email
# read -p "Do you want to config user's name and email? [Y,n]" -i Y input
# if [[ $input == "Y" || $input == "y" || $input == "" ]]; then
    if [ -z "$(git config user.name)" ]; then
        git config --global user.name "Your Name"
    fi
    if [ -z "$(git config user.email)" ]; then
        git config --global user.email "you@example.com"
    fi
# fi

# Turn on OMS Support
read -p "Do you want to turn on OMS support? [Y,n]" -i Y input
if [[ $input == "Y" || $input == "y" || $input == "" ]]; then
    cd device/jiayu/s3_h560/patches_mtk/oms
    bash apply-oms.sh <<<y
    cd ../../../../..
fi

# Apply Mediatek patches
read -p "Do you want to apply Mediatek patches? [Y,n]" -i Y input
if [[ $input == "Y" || $input == "y" || $input == "" ]]; then
    bash device/jiayu/s3_h560/patches_mtk/revert-patches.sh
    bash device/jiayu/s3_h560/patches_mtk/apply-patches.sh
fi

# Apply Lineage-14.1 patches
read -p "Do you want to apply Lineage-14.1 patches? [Y,n]" -i Y input
if [[ $input == "Y" || $input == "y" || $input == "" ]]; then
    patch -p1 < android_local_manifest_jiayu/lineage-14.1.patch
fi

# Modify port number from ~/.jack-settings
read -p "Do you want to modify port number? [Y,n]" -i Y input
if [[ $input == "Y" || $input == "y" || $input == "" ]]; then
    # Change port number from ~/.jack-settings
    FILE=~/.jack-settings 
    if [ -f $FILE ]; then
        sed -i -e 's/^SERVER_PORT_SERVICE=.*/SERVER_PORT_SERVICE=8386/g' $FILE
        sed -i -e 's/^SERVER_PORT_ADMIN=.*/SERVER_PORT_ADMIN=8387/g' $FILE
        
        # Modify server compile number
        read -p "Do you want to modify SERVER_NB_COMPILE? [Y,n]" -i Y input
        if [[ $input == "Y" || $input == "y" || $input == "" ]]; then
            STRING='SERVER_NB_COMPILE='
            if [[ $(grep -L $STRING $FILE) ]]; then
                sed -i -e '/^SERVER_PORT_ADMIN=.*/a SERVER_NB_COMPILE=4' $FILE
            fi
        fi
        
        # Modify JACK_SERVER_VM_ARGUMENTS
        read -p "Do you want to modify JACK_SERVER_VM_ARGUMENTS? [Y,n]" -i Y input
        if [[ $input == "Y" || $input == "y" || $input == "" ]]; then
            STRING='JACK_SERVER_VM_ARGUMENTS='
            if [[ $(grep -L $STRING $FILE) ]]; then
                sed -i -e '/^SERVER_NB_COMPILE=4/a JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx8192m"' $FILE
            fi
        fi
        cat $FILE
    else
        # Create new $FILE file
        read -p "$FILE file doesn't exist. Do you want to create new one? [Y,n]" -i Y input
        if [[ $input == "Y" || $input == "y" || $input == "" ]]; then
            echo "File $FILE does not exist."
            echo "# Server settings" > $FILE
            echo "SERVER_HOST=127.0.0.1" >> $FILE
            echo "SERVER_PORT_SERVICE=8386" >> $FILE
            echo "SERVER_PORT_ADMIN=8387" >> $FILE
            echo "SERVER_NB_COMPILE=4" >> $FILE
            echo "JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx8192m"" >> $FILE
            echo "" >> $FILE
            echo "# Internal, do not touch" >> $FILE
            echo "SETTING_VERSION=4" >> $FILE
        fi
    fi
    
    # Change port number from ~/.jack-server/config.properties
    mkdir -p ~/.jack-server/logs
    FILEPATH=~/.jack-server/
    FILE=~/.jack-server/config.properties
    if [ -f $FILE ]; then
        sed -i -e 's/^jack.server.max-service=.*/jack.server.max-service=4/g' $FILE
        sed -i -e 's/^jack.server.service.port=.*/jack.server.service.port=8386/g' $FILE
        sed -i -e 's/^jack.server.admin.port=.*/jack.server.admin.port=8387/g' $FILE
        cat $FILE
    else
        # Create new $FILE file
        read -p "$FILE file doesn't exist. Do you want to create new one? [Y,n]" -i Y input
        if [[ $input == "Y" || $input == "y" || $input == "" ]]; then
            echo "File $FILE does not exist."
            mkdir -p $FILEPATH
            echo "#" > $FILE
            echo "# $(date +'%a %b %d %T %Z %Y')" >> $FILE
            echo "jack.server.max-jars-size=104857600" >> $FILE
            echo "jack.server.max-service=4" >> $FILE
            echo "jack.server.service.port=8386" >> $FILE
            echo "jack.server.max-service.by-mem=1\=2147483648\:2\=3221225472\:3\=4294967296" >> $FILE
            echo "jack.server.admin.port=8387" >> $FILE
            echo "" >> $FILE
            echo "jack.server.config.version=2" >> $FILE
            echo "jack.server.time-out=7200" >> $FILE
        fi
    fi  
fi
