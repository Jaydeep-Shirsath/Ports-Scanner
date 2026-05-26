#!/bin/bash

# Advanced Ports-Scanner Setup Script
# Automatically configures environments across multiple OS distributions

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=======================================${NC}"
echo -e "${BLUE}      Ports-Scanner Environment Setup  ${NC}"
echo -e "${BLUE}=======================================${NC}"
echo ""

# Dependency tracking status flag
NEED_INSTALL=true

# Check if Nmap is already accessible natively
echo -e "${BLUE}[*] Auditing local system dependencies...${NC}"
if command -v nmap &> /dev/null; then
    echo -e "${GREEN}[✓] Nmap binary found on your system.${NC}"
    NEED_INSTALL=false
else
    echo -e "${YELLOW}[!] Nmap binary not found. Running deployment...${NC}"
fi

# Perform dynamic operating system detection and deployment
if [ "$NEED_INSTALL" = true ]; then
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Detect the underlying Linux architecture/package manager
        if command -v apt-get &> /dev/null; then
            echo -e "${YELLOW}[*] Debian/Ubuntu-based system detected using APT...${NC}"
            sudo apt-get update
            sudo apt-get install -y nmap
        elif command -v pacman &> /dev/null; then
            echo -e "${YELLOW}[*] Arch Linux system detected using Pacman...${NC}"
            sudo pacman -Sy --noconfirm nmap
        elif command -v dnf &> /dev/null; then
            echo -e "${YELLOW}[*] RHEL/Fedora system detected using DNF...${NC}"
            sudo dnf install -y nmap
        else
            echo -e "${RED}[!] Unrecognized Linux package manager. Please install Nmap manually.${NC}"
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Check for macOS environments running Homebrew
        if command -v brew &> /dev/null; then
            echo -e "${YELLOW}[*] macOS environment detected using Homebrew...${NC}"
            brew install nmap
        else
            echo -e "${RED}[!] Homebrew is missing. Install Homebrew or download Nmap from https://nmap.org{NC}"
            exit 1
        fi
    else
        echo -e "${RED}[!] Unsupported operating system environment architecture.${NC}"
        exit 1
    fi
fi

# Ensure correct file permissions are applied locally
echo -e "\n${BLUE}[*] Setting execution permissions for local workspace files...${NC}"
chmod +x scan.sh
echo -e "${GREEN}[✓] Local execution rights updated.${NC}"

# Establish a global copy of the execution file inside /usr/bin/
echo -e "\n${BLUE}[*] Moving binary payload to global user bin path (/usr/bin/)...${NC}"
sudo cp scan.sh /usr/bin/scan.sh
sudo chmod +x /usr/bin/scan.sh
echo -e "${GREEN}[✓] Global environment linkage completed.${NC}"

echo -e "\n${BLUE}=======================================${NC}"
echo -e "${GREEN}          Setup Complete!              ${NC}"
echo -e "${BLUE}=======================================${NC}"
echo -e "You can now execute ${YELLOW}scan.sh${NC} globally from any shell path."
echo -e "Example: ${GREEN}scan.sh 10.10.10.10${NC}\n"
