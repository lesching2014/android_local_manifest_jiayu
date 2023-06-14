#!/bin/bash

# Install essential packages
# read -p "Do you want to install esseential packages? [Y,n]" -i Y input
# if [[ $input == "Y" || $input == "y" || $input == "" ]]; then
    sudo apt install bc bison build-essential ccache curl \
    flex g++-multilib gcc-multilib git git-lfs gnupg gperf \
    imagemagick lib32ncurses-dev lib32readline-dev lib32z1-dev \
    libelf-dev liblz4-tool libncurses5 libncurses5-dev libsdl1.2-dev \
    libssl-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool \
    squashfs-tools xsltproc zip zlib1g-dev openjdk-8-jdk python2.7
    # sudo apt install libwxgtk3.0-dev python3
# fi

#Install repo
FILE=~/bin/repo
if [ ! -e "$FILE" ]; then
    mkdir -p ~/bin
    curl https://storage.googleapis.com/git-repo-downloads/repo > $FILE
    chmod a+x $FILE
    FILE=~/.profile
    # set PATH so it includes user's private bin if it exists
    if [ -d "$HOME/bin" ] ; then
        echo PATH="$HOME/bin:$PATH" >> $FILE
    fi
    source $FILE
fi

# Create symlink of python from python2.7
version=$(python -V 2>&1 | grep -Po '(?<=Python )(.+)')
version2=$(python2 -V 2>&1 | grep -Po '(?<=Python )(.+)')
version3=$(python3 -V 2>&1 | grep -Po '(?<=Python )(.+)')
if [ -z "$version2" ] ; then
    sudo apt install python2.7
    sudo ln -s /usr/bin/python2.7 /usr/bin/python2
fi
version2=$(python2 -V 2>&1 | grep -Po '(?<=Python )(.+)')
if [ "$version" = "$version3" ] ; then
    sudo rm -f /usr/bin/python
fi
version=$(python -V 2>&1 | grep -Po '(?<=Python )(.+)')
if [ -z "$version" ] ; then
    sudo ln -s /usr/bin/python2 /usr/bin/python
fi

# Create ccache
# read -p "Do you want to create ccache? [Y,n]" -i Y input
# if [[ $input == "Y" || $input == "y" || $input == "" ]]; then
    if [[ "$(ccache --show-stats | grep 'max cache size' | cut -d' ' -f25)" != "50.0" ]]; then
        FILE=~/.bashrc
        echo export USE_CCACHE=1 >> $FILE
        echo export CCACHE_EXEC=/usr/bin/ccache >> $FILE
        source $FILE
        ccache -M 50G
        ccache -o compression=true
    else
        echo "Set cache size limit to 50.0 GB"    
    fi
# fi

JAVA_MAJOR_VERSION=$(java -version 2>&1 | grep -oP 'version "?(1\.)?\K\d+' || true)
if [[ $JAVA_MAJOR_VERSION -eq 8 ]]; then
    echo "Java 8 is installed "
else
    STRING='java-1.8.0-openjdk-amd64'
    if [[ $(update-java-alternatives --list | grep -L $STRING) ]]; then
        sudo apt-get install openjdk-8-jdk
        # sudo apt-get install openjdk-8-jre
        sudo update-alternatives --config java
    fi
    FILE=/etc/environment
    sudo chmod 777  $FILE
    STRING='JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64'
    if [[ $(grep -L $STRING $FILE) ]]; then
        sudo echo $STRING >> $FILE
    fi
    STRING='PATH=$JAVA_HOME/bin:$PATH'
    if [[ $(grep -L $STRING $FILE) ]]; then
        sudo echo $STRING >> $FILE
    fi
    sudo chmod 644  $FILE
    source $FILE
fi

# Install gcc-9
# read -p "Do you want to install gcc-9? [Y,n]" -i Y input
# if [[ $input == "Y" || $input == "y" || $input == "" ]]; then
    GCC_MAJOR_VERSION=$(gcc --version | grep ^gcc | sed 's/^.* //g' | cut -f1 -d.)
    if [[ $GCC_MAJOR_VERSION -eq 9 ]]; then
        echo "gcc-9 is installed "
    else
        sudo apt install gcc-9
        sudo update-alternatives --config gcc
    fi
# fi

# Remove TLSv1 and TLSv1.1 from /etc/java-8-openjdk/security/java.security file
# read -p "Do you want to remove TLSv1 and TLSv1.1? [Y,n]" -i Y input
# if [[ $input == "Y" || $input == "y" || $input == "" ]]; then
    FILE=/etc/java-8-openjdk/security/java.security 
    if [ -f $FILE ]; then
        cat $FILE | grep -i "TLSv1, TLSv1.1, "
        sudo sed -i -e 's/TLSv1, TLSv1.1, \(.*\)/\1/' $FILE
        echo "AFTER sed......." | cat $FILE | grep -i "TLSv1, TLSv1.1, "
    fi
# fi

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
