#!/bin/bash

# Two-Stage Interactive Ports-Scanner
# Stage 1: Ultra-fast raw port discovery over all 65,535 TCP ports with visual summary
# Stage 2: Targeted script, service, and OS analysis menu on active ports
# Created by Jaydeep Shirsath

# Color formatting for terminal output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=======================================${NC}"
echo -e "${BLUE}        Ports-Scanner v2.0            ${NC}"
echo -e "${GREEN}    Created by Jaydeep Shirsath       ${NC}"
echo -e "${BLUE}=======================================${NC}"

# Prompt for IP address if not passed as an argument
if [ -z "$1" ]; then
    read -p "Enter Target IP Address: " TARGET_IP
else
    TARGET_IP=$1
fi

# Validate that the user actually provided an input
if [ -z "$TARGET_IP" ]; then
    echo -e "${RED}[!] Error: No target IP provided. Exiting.${NC}"
    exit 1
fi

echo -e "\n${YELLOW}[*] Initializing scan against target: ${TARGET_IP}${NC}\n"

# Verify basic network reachability over the VPN tunnel
echo -e "${BLUE}[1/3] Verifying host availability via ping...${NC}"
if ping -c 1 -W 2 "$TARGET_IP" &> /dev/null; then
    echo -e "${GREEN}[✓] Host is up and responding.${NC}\n"
else
    echo -e "${YELLOW}[!] Warning: Host is not responding to pings (it might block ICMP). Proceeding anyway...${NC}\n"
fi

# Stage 1: Ultra-Fast Port Discovery
echo -e "${BLUE}[2/3] Performing ultra-fast discovery of all 65,535 ports...${NC}"
echo -e "${YELLOW}[i] Running raw SYN scan to map active entry points quickly...${NC}\n"

TEMP_SCAN_RAW=$(mktemp)
# --open filters down to open ports instantly
# -n skips DNS resolution to shave off execution time
# --min-rate 5000 sends packets rapidly, safe for CTF boxes
nmap -p- --open -n --min-rate 5000 "$TARGET_IP" | tee "$TEMP_SCAN_RAW"

# Extract discovered open ports dynamically for Stage 2
OPEN_PORTS=$(grep -E '^[0-9]+/tcp' "$TEMP_SCAN_RAW" | cut -d'/' -f1 | tr '\n' ',' | sed 's/,$//')

echo -e "\n${BLUE}=======================================${NC}"
echo -e "${GREEN}[✓] Raw port discovery completed!${NC}"
echo -e "${BLUE}=======================================${NC}\n"

# Check if any ports were actually found open
if [ -z "$OPEN_PORTS" ]; then
    echo -e "${RED}[!] No open TCP ports were found on the target host.${NC}\n"
    rm -f "$TEMP_SCAN_RAW"
    exit 0
fi

# Highlight discovered ports visibly on screen
echo -e "${GREEN}┌────────────────────────────────────────────────────────┐${NC}"
echo -e "${GREEN}│              LIVE PORT STATUS SUMMARY                  │${NC}"
echo -e "${GREEN}└────────────────────────────────────────────────────────┘${NC}"
echo -e "${YELLOW}  Target Host: ${NC}$TARGET_IP"
echo -e "${YELLOW}  Open Ports Identified: ${GREEN}${OPEN_PORTS//,/ , }${NC}"
echo -e "${GREEN}──────────────────────────────────────────────────────────${NC}\n"

# Interactive Scan Customization Menu
echo -e "${YELLOW}[*] Select Deep Analysis Mode for these open ports:${NC}"
echo "1) Service Version Detection only (-sV)"
echo "2) OS Detection only (-O)"
echo "3) Default Script Scan only (-sC)"
echo "4) Complete Aggressive Scan (All: -sV -O -sC)"
echo "5) Skip deep analysis (Directly save/exit)"
read -p "Enter choice (1-5): " MENU_CHOICE

# Initialize deep scan parameters
DEEP_FLAGS=""
case $MENU_CHOICE in
    1) DEEP_FLAGS="-sV" ;;
    2) DEEP_FLAGS="-O" ;;
    3) DEEP_FLAGS="-sC" ;;
    4) DEEP_FLAGS="-sV -O -sC" ;;
    5) DEEP_FLAGS="" ;;
    *) echo -e "${RED}Invalid choice. Skipping deep analysis.${NC}"; DEEP_FLAGS="" ;;
esac

# Stage 2: Targeted Analysis Execution
if [ -n "$DEEP_FLAGS" ]; then
    echo -e "\n${BLUE}[3/3] Executing targeted deep analysis (${DEEP_FLAGS}) on ports: ${OPEN_PORTS}...${NC}\n"
    
    TEMP_DEEP_RAW=$(mktemp)
    # Target only the specific discovered ports to keep it running at maximum speed
    sudo nmap -p "$OPEN_PORTS" $DEEP_FLAGS "$TARGET_IP" | tee "$TEMP_DEEP_RAW"
    
    echo -e "\n${BLUE}=======================================${NC}"
    echo -e "${GREEN}[✓] Targeted deep scan completed!${NC}"
    echo -e "${BLUE}=======================================${NC}\n"
    
    # Merge results smoothly into our core memory cache buffer
    echo -e "\n\n=== DEEP ANALYSIS RESULTS ($DEEP_FLAGS) ===" >> "$TEMP_SCAN_RAW"
    cat "$TEMP_DEEP_RAW" >> "$TEMP_SCAN_RAW"
    rm -f "$TEMP_DEEP_RAW"
fi

# Stage 3: Dynamic File Saving Architecture
read -p "Do you want to save the final scan results to a file? (y/N): " SAVE_CHOICE

if [[ "$SAVE_CHOICE" =~ ^[Yy]$ ]]; then
    DEFAULT_DIR="$HOME/ctf_scans"
    DEFAULT_FILE="scan_${TARGET_IP//./_}.txt"
    
    echo -e "\n${YELLOW}[*] Default saving location: ${NC}${DEFAULT_DIR}/${DEFAULT_FILE}"
    echo -e "${YELLOW}[*] You can enter a directory path OR a full file path (e.g., /tmp/custom.txt)${NC}"
    read -p "Press [Enter] to keep default, or type custom path: " USER_INPUT
    
    if [ -z "$USER_INPUT" ]; then
        FINAL_DIR="$DEFAULT_DIR"
        OUTPUT_FILE="$FINAL_DIR/$DEFAULT_FILE"
    else
        eval EXPANDED_INPUT="$USER_INPUT"
        if [[ "$EXPANDED_INPUT" =~ \.[a-zA-Z0-9]+$ ]]; then
            FINAL_DIR=$(dirname "$EXPANDED_INPUT")
            OUTPUT_FILE="$EXPANDED_INPUT"
        else
            FINAL_DIR="${EXPANDED_INPUT%/}"
            OUTPUT_FILE="$FINAL_DIR/$DEFAULT_FILE"
        fi
    fi
    
    mkdir -p "$FINAL_DIR"
    cat "$TEMP_SCAN_RAW" > "$OUTPUT_FILE"
    
    echo -e "\n${GREEN}[✓] Success! Final logs compiled and saved to:${NC}"
    echo -e "    ${BLUE}${OUTPUT_FILE}${NC}\n"
else
    echo -e "\n${YELLOW}[*] Operation completed. Results were only displayed on standard terminal screen output.${NC}\n"
fi

# Clean up memory buffers safely
rm -f "$TEMP_SCAN_RAW"
