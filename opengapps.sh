FILE=device/jiayu/s3_h560/device.mk
echo 'GAPPS_VARIANT := pico' >> $FILE
echo '$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)' >> $FILE

# You can add packages from versions higher then your set version. E.g. if you want to include Chrome, but you use GAPPS_VARIANT := micro
# In your device/manufacturer/product/device.mk just add, for example:
# echo GAPPS_PRODUCT_PACKAGES += Chrome >> $FILE

# You can exclude certain packages from the list of packages associated with your selected OpenGapps variant. E.g. if you have GAPPS_VARIANT := stock and want all those apps installed except for Hangouts, then in your device/manufacturer/product/device.mk just add:
# echo GAPPS_EXCLUDED_PACKAGES := Hangouts  >> $FILE

# You can force GApps packages to override the stock packages. This can be defined in two ways inside device/manufacturer/product/device.mk.
# For all package:
# echo GAPPS_FORCE_PACKAGE_OVERRIDES := true  >> $FILE
# If you want to include WebViewGoogle on a non-stock build you need:
# echo GAPPS_FORCE_WEBVIEW_OVERRIDES := true >> $FILE
# If you want to include Messenger on a non-stock build you need:
# echo GAPPS_FORCE_MMS_OVERRIDES := true >> $FILE
# If you want to include Google Dialer on a non-stock build you need:
# echo GAPPS_FORCE_DIALER_OVERRIDES := true >> $FILE
# If you want to include Chrome on a non-full build you need:
# echo GAPPS_FORCE_BROWSER_OVERRIDES := true >> $FILE
# PixelLauncher is the default launcher in Oreo builds (and newer); in builds older than Oreo, the default launcher is GoogleNow. If desired, then you can force PixelLauncher to be used by setting the following variable:
# echo GAPPS_FORCE_PIXEL_LAUNCHER := true >> $FILE
# On a per-app basis, add the GApps package to GAPPS_PACKAGE_OVERRIDES. Example:
# echo GAPPS_PACKAGE_OVERRIDES := Chrome >> $FILE

# You can tell the GApps packages not to override the stock packages. This can be defined inside device/manufacturer/product/device.mk by adding the GApps package to GAPPS_BYPASS_PACKAGE_OVERRIDES. Example:
# echo GAPPS_BYPASS_PACKAGE_OVERRIDES := Chrome >> $FILE

# Force the system to get the correct DPI package for your device
# By default, the latest package version will be selected with the closest DPI. You can force the system to select either a matching DPI package or "nodpi" package even if it is not the latest version.
# This can be defined inside device/manufacturer/product/device.mk using:
# echo GAPPS_FORCE_MATCHING_DPI := true >> $FILE

FILE=device/jiayu/s3_h560/BoardConfig.mk
# It is possible to build Android with dex preoptimization. This results in a quicker boot time, at the cost of additional storage used on /system.
# This is normally done by setting the value:
# echo WITH_DEXPREOPT := true >> $FILE
# in BoardConfig.mk. This will, by default, if set to true, also enable DEX Preoptimization for Google Apps.
# You can disable this entirely by setting:
# echo DONT_DEXPREOPT_PREBUILTS := true >> $FILE

# More info: https://github.com/git-lfs/git-lfs/blob/master/INSTALLING.md
# Apt/deb
sudo apt install git-lfs
# Yum/rpm
sudo yum install git-lfs
# on macOS
# brew install git-lfs

git lfs install
repo forall -c git lfs pull
