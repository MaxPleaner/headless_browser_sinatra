#!/bin/bash

# Tell the user what this script does. Sleep 5 seconds while they decide to proceed or not
echo "installing dependencies for x86_64 Ubuntu."
echo "will continue in 5 seconds. Exit now if you have a different system"
sleep 5

# Install dependencies
# - xfvb: headless x gui
# - imagemagick: image manipulation
# - x11-apps: installs xwd for screenshots
sudo apt-get install xvfb imagemagick x11-apps

# Download
wget https://ftp.mozilla.org/pub/firefox/releases/46.0/firefox-46.0.linux-x86_64.sdk.tar.bz2

# Uncompress
tar -xvf firefox-46.0.linux-x86_64.sdk.tar.bz2

# Remove compressed
rm firefox-46.0.linux-x86_64.sdk.tar.bz2

# Rename
mv firefox-sdk lib/

# Done
echo "Firefox 46 binary generated"
