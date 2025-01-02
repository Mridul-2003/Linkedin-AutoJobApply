#!/bin/bash

# Update and install wget, gnupg2, and ca-certificates
apt-get update
apt-get install -y wget gnupg2 ca-certificates

# Add the Google Chrome repository
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list

# Update again
apt-get update

# Install Google Chrome stable
apt-get install -y google-chrome-stable

# Get Chrome version
CHROME_VERSION=$(google-chrome --version | awk '{print $3}')
echo "Chrome Version: $CHROME_VERSION"

# Get ChromeDriver version
CHROMEDRIVER_VERSION=$(wget -qO- "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROME_VERSION%%.*}" | tr -d '\n')
echo "ChromeDriver Version: $CHROMEDRIVER_VERSION"

# Download, unzip, and move ChromeDriver
wget "https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip"
unzip chromedriver_linux64.zip -d /usr/local/bin
rm chromedriver_linux64.zip
chmod +x /usr/local/bin/chromedriver

echo "Chrome and ChromeDriver installed."

# Install Python dependencies
pip install -r requirements.txt

echo "Python dependencies installed."
