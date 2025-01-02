#!/bin/bash

# Attempt to download Chrome (Unlikely to Work)
echo "Attempting to Download Chrome - This may fail"
wget -q https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_120.0.6099.199-1_amd64.deb

# Attempt to extract the package to /tmp (Unlikely to work)
if [ -f "google-chrome-stable_120.0.6099.199-1_amd64.deb" ]; then
    echo "Deb package found"
    mkdir -p /tmp/chrome_extract
    dpkg-deb -x google-chrome-stable_120.0.6099.199-1_amd64.deb /tmp/chrome_extract
else
  echo "Deb package not found"
fi
# Attempt to download ChromeDriver (Unlikely to Work)
echo "Attempting to Download ChromeDriver - This may fail"
CHROMEDRIVER_VERSION=$(wget -qO- "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_120" | tr -d '\n')
wget -q "https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip"

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

echo "Build process finished.  Install may have failed."
