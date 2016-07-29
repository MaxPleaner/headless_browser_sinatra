#!/bin/bash

# Download
wget https://ftp.mozilla.org/pub/firefox/releases/46.0/firefox-46.0.linux-x86_64.sdk.tar.bz2

# Uncompress
tar -xvf firefox-46.0.linux-x86_64.sdk.tar.bz2

# Remove compressed
rm firefox-46.0.linux-x86_64.sdk.tar.bz2

# Rename
mv firefox-46-0.linux-x86_64 lib/firefox-sdk

# Symlink
cd lib
ln -s firefox-sdk/bin/firefox .

# Done
echo "Firefox 46 binary generated"