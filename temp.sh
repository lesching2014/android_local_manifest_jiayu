#!/bin/bash

SAUCE=~/android/lineage141
ROM=LineageOS
VENDOR=Google
DEVICE=mako
REPO=https://github.com/LineageOS/android.git
BRANCH=cm-14.1
CCACHESIZE=50G
CCACHEFOLDERNAME=lineage141

###############################################################################################################################################
#Num  Colour    #define         R G B

#0    black     COLOR_BLACK     0,0,0
#1    red       COLOR_RED       1,0,0
#2    green     COLOR_GREEN     0,1,0
#3    yellow    COLOR_YELLOW    1,1,0
#4    blue      COLOR_BLUE      0,0,1
#5    magenta   COLOR_MAGENTA   1,0,1
#6    cyan      COLOR_CYAN      0,1,1
#7    white     COLOR_WHITE     1,1,1

yellow=`tput setaf 3`
green=`tput setaf 2`
cyan=`tput setaf 6`
red=`tput setaf 1`
reset=`tput sgr0`

printf '\033]2;%s\007' "Building $ROM For $VENDOR $DEVICE"
echo "${cyan}Building $ROM For $VENDOR $DEVICE"
echo ""
echo "Writing by 19cam92@xda"
echo "Script version 5.4.3${reset}"

echo " "
echo "${red}!!!! THIS SCRIPT NEEDS ROOT TO INSTALL BUILD TOOLS !!!!${reset}"
echo "${red}!!!!    PLEASE ENTER YOUR PASSWORD WHEN PROMTED    !!!!${reset}"
echo " "
sudo whoami

# Install build packages
echo " "
echo "${yellow}Installing build tools${reset}"
sudo apt-get install bc bison build-essential ccache curl flex g++-multilib gcc-multilib git gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool libncurses5-dev libsdl1.2-dev libssl-dev libwxgtk3.0-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev

# Install repo
echo " "
echo "${yellow}Installing repo${reset}"
sudo apt-get install repo

# Install git
echo " "
echo "${yellow}Installing git${reset}"
sudo apt install git

# Check to see if platfrom tools are there
if [ -d "$HOME/android/platform-tools" ]; then
    echo " "
    echo "${green}Platform Tools are installed${reset}"
else
    echo " "
    echo "${red}Platfrom Tools arent installed.${reset}"
    echo "Downloading Platfrom Tools now"    
    wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip
    unzip platform-tools-latest-linux.zip -d ~/android/
    rm -f platform-tools-latest-linux.zip
fi

# Add Android SDK platform tools to path
if [ -d "$HOME/android/platform-tools" ] ; then
	export PATH="$HOME/android/platform-tools:$PATH"
fi

# Check to see if java 8 JDK is installed
echo " "
echo "${yellow}Installing Java 8 JDK${reset}"
sudo apt-get install openjdk-8-jdk

# Set java 8 as default JDK
echo " "
echo "${yellow}Setting Java 8 as default${reset}"
sudo update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

# Check to see if repo is installed
if [ -e ~/bin/repo ]; then
	echo " "
	echo "${green}Repo's already installed${reset}"
else
	echo " "
	echo "${yellow}Installing Repo${reset}"
	mkdir ~/bin
	curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
	echo "${yellow}Setting Repo Premissions${reset}"
	chmod a+x ~/bin/repo
fi

# Make Directory
if [ ! -d "$SAUCE" ]; then
	echo "${yellow}Making Directory${reset}"
	mkdir $SAUCE
fi

# Move's to build directory
cd $SAUCE

# Initializing repository
echo " "
echo "${yellow}Initializing $ROM repository${reset}"
repo init -u $REPO -b $BRANCH

# Clean's up old build files
echo " "
echo -n "${yellow}Cleanup old build (y/n)? ${reset}"
read answer
if echo "$answer" | grep -iq "^y" ;then
    echo "Clean old files..."
	make clean
	echo "Done!"
else
    echo "Skipping cleanup"
fi

# Sync lastest source's
echo " "
echo -n "${yellow}Sync repo (y/n)? ${reset}"
read answer
if echo "$answer" | grep -iq "^y" ;then
    echo "$Running repo sync..."
	repo sync
	echo "Done!"
else
    echo "Skipping repo sync"
fi

# Enable or disable in build superuser
echo " "
echo -n "${yellow}Enable build in superuser (y/n)? ${reset}"
read answer
if echo "$answer" | grep -iq "^y" ;then
	echo "Enabling SU..."
	export WITH_SU=true
	echo "Done!"
else
	echo "Disabling SU..."
   	export WITH_SU=false
	echo "Done!"
fi

# Enable or disable ccache
echo " "
echo -n "${yellow}Enable ccache (y/n)? ${reset}"
read answer
if echo "$answer" | grep -iq "^y" ;then
	echo "Enabling ccache..."
    mkdir ~/.ccache
	mkdir ~/.ccache/$CCACHEFOLDERNAME
	export USE_CCACHE=1
	export CCACHE_DIR=~/.ccache/$CCACHEFOLDERNAME
	prebuilts/misc/linux-x86/ccache/ccache -M $CCACHESIZE
	echo "Done!"
else
	echo "Disabling ccache..."
   	export USE_CCACHE=0
	echo "Done!"
fi

# Enable or disable ninja wapper
echo " "
echo -n "${yellow}Disable ninja wapper (y/n)? ${reset}"
read answer
if echo "$answer" | grep -iq "^y" ;then
	echo "Disabling ninja wapper..."
	export USE_NINJA=false
	echo "Done!"
else
	echo "Enabling ninja wapper..."
   	export USE_NINJA=true
	echo "Done!"
fi

export LC_ALL=C

# Configre's jack compiler
echo " "
echo -n "${yellow}Configre's jack compiler to 4G (y/n)? ${reset}"
read answer
if echo "$answer" | grep -iq "^y" ;then
	echo "Setting jack compiler to 4G..."
	export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4G"
	echo "Done!"
fi

# Build commands
echo " "
source build/envsetup.sh
breakfast $DEVICE
croot
brunch $DEVICE

# Notifys you if build was successful
if [ -e $SAUCE/out/target/product/$DEVICE/lineage-*.zip ]; then
	echo "${green}Build Successful...${reset}"
else
	echo "${red}Build Failed...${reset}"
fi

# Set java back to auto
echo " "
echo "${yellow}Setting Java back to auto${reset}"
sudo update-alternatives --auto java

# Kills java after build incase it's still runng
echo " "
echo "${yellow}Killing Java incase it's still running${reset}"
pkill -9 java

echo " "
echo "${green}Done!!!!${reset}"
read
