#!/bin/bash

# Set Chrome version and download links
CHROME_VERSION="120.0.6099.217" # Specific Chrome version. Ensure this is still compatible with your driver
CHROME_DEB_URL="https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_VERSION}-1_amd64.deb"
CHROMEDRIVER_VERSION="120.0.6099.109" # Specific Chromedriver version that is compatible with version above
CHROMEDRIVER_ZIP_URL="https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip"

echo "Attempting to Download Chrome - Version: ${CHROME_VERSION}. This may still fail."
wget -q "$CHROME_DEB_URL"

# Attempt to extract the package to /tmp
if [ -f "google-chrome-stable_${CHROME_VERSION}-1_amd64.deb" ]; then
    echo "Deb package found"
    mkdir -p /tmp/chrome_extract
    dpkg-deb -x "google-chrome-stable_${CHROME_VERSION}-1_amd64.deb" /tmp/chrome_extract
else
  echo "Deb package not found"
fi

# Attempt to download ChromeDriver
echo "Attempting to Download ChromeDriver - Version: ${CHROMEDRIVER_VERSION}. This may still fail."
wget -q "$CHROMEDRIVER_ZIP_URL"

# Attempt to unzip and put in /tmp
if [ -f "chromedriver_linux64.zip" ]; then
    echo "Chromedriver zip found"
    mkdir -p /tmp/chromedriver
    unzip chromedriver_linux64.zip -d /tmp/chromedriver
    chmod +x /tmp/chromedriver/chromedriver
else
  echo "chromedriver zip not found"
fi

# Install python requirements.
pip install -r requirements.txt

echo "Build process finished. Install may have failed."
