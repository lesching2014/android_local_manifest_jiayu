#!/bin/bash

# Install essential packages
read -p "Do you want to install esseential packages? [Y,n]" -i Y input
if [[ $input == "Y" || $input == "y" || $input == "" ]]; then
    sudo apt install bc bison build-essential ccache curl \
    flex g++-multilib gcc-multilib git git-lfs gnupg gperf \
    imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev \
    libelf-dev liblz4-tool libncurses5 libncurses5-dev libsdl1.2-dev \
    libssl-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool \
    squashfs-tools xsltproc zip zlib1g-dev libwxgtk3.0-dev openjdk-8-jdk python2.7 python3
fi

# Create ccache
read -p "Do you want to create ccache? [Y,n]" -i Y input
if [[ $input == "Y" || $input == "y" || $input == "" ]]; then
    FILE=~/.bashrc
    echo export USE_CCACHE=1 >> $FILE
    echo export CCACHE_EXEC=/usr/bin/ccache >> $FILE
    source $FILE
    ccache -M 50G
    ccache -o compression=true
fi

# Create symlink of python from python2.7
read -p "Do you want to create symlink of python? [Y,n]" -i Y input
if [[ $input == "Y" || $input == "y" || $input == "" ]]; then
    sudo ln -s /usr/bin/python2.7 /usr/bin/python
fi

# Config git user's name and email
read -p "Do you want to config user's name and email? [Y,n]" -i Y input
if [[ $input == "Y" || $input == "y" || $input == "" ]]; then
    if [ -z "$(git config user.name)" ]; then
        git config --global user.name "Your Name"
    fi
    if [ -z "$(git config user.email)" ]; then
        git config --global user.email "you@example.com"
    fi
fi

JAVA_MAJOR_VERSION=$(java -version 2>&1 | grep -oP 'version "?(1\.)?\K\d+' || true)
if [[ $JAVA_MAJOR_VERSION -eq 8 ]]; then
    echo "Java 8 is required"
else
    echo "Java major version is $JAVA_MAJOR_VERSION."
fi

# Install Java 8 and change default
read -p "Do you want to install Java 8? [Y,n]" -i Y input
if [[ $input == "Y" || $input == "y" || $input == "" ]]; then
    FILE=/etc/environment
    STRING='java-1.8.0-openjdk-amd64'
    if [[ $(update-java-alternatives --list | grep -L $STRING) ]]; then
        sudo apt-get install openjdk-8-jdk
#        sudo apt-get install openjdk-8-jre
        sudo update-alternatives --config java
    fi
    STRING='JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64'
    if [[ $(grep -L $STRING $FILE) ]]; then
        sudo echo $STRING >> $FILE
    fi
    STRING='PATH=$JAVA_HOME/bin:$PATH'
    if [[ $(grep -L $STRING $FILE) ]]; then
        sudo echo $STRING >> $FILE
    fi
    source $FILE
fi

# Install gcc-9
read -p "Do you want to install gcc-9? [Y,n]" -i Y input
if [[ $input == "Y" || $input == "y" || $input == "" ]]; then
    if [[ $(update-java-alternatives --list | grep -L $STRING) ]]; then
        sudo apt install gcc-9
        sudo update-alternatives --config gcc
    fi
fi

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
read -p "Do you want to remove TLSv1 and TLSv1.1? [Y,n]" -i Y input
if [[ $input == "Y" || $input == "y" || $input == "" ]]; then
    FILE=/etc/java-8-openjdk/security/java.security 
    if [ -f $FILE ]; then
        cat $FILE | grep -i "TLSv1, TLSv1.1, "
        sudo sed -i -e 's/TLSv1, TLSv1.1, \(.*\)/\1/' $FILE
        cat $FILE | grep -i "TLSv1, TLSv1.1, "
    fi
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