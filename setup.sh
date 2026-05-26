#!/bin/bash

# Ports-Scanner Setup Script
# This script automates the installation and setup of Ports-Scanner

echo "================================"
echo "  Ports-Scanner Setup Script"
echo "================================"
echo ""

# Check if nmap is installed
echo "Checking if nmap is installed..."
if command -v nmap &> /dev/null; then
    echo "✓ nmap is already installed"
else
    echo "✗ nmap is not installed"
    echo "Installing nmap..."
    
    # Detect OS and install nmap
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get update
        sudo apt-get install -y nmap
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install nmap
    else
        echo "Unsupported OS. Please install nmap manually from https://nmap.org/download.html"
        exit 1
    fi
fi

echo ""
echo "Making scan.sh executable..."
chmod +x scan.sh

echo ""
echo "Copying scan.sh to /usr/bin/..."
sudo cp scan.sh /usr/bin/scan.sh
sudo chmod +x /usr/bin/scan.sh

echo ""
echo "================================"
echo "  Setup Complete!"
echo "================================"
echo ""
echo "You can now run 'scan.sh' from any terminal location"
echo "Enter your target IP address when prompted."
