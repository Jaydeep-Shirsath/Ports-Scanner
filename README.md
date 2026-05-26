# Ports-Scanner v2.0

> An intelligent, two-stage interactive shell-script utility powered by Nmap to rapidly map active ports and run deep service footprinting on CTF target systems.

## 📝 Description

Ports-Scanner is an automated reconnaissance utility designed specifically for penetration testing platforms like **TryHackMe** and **HackTheBox**. 

Instead of running slow scans that waste valuable lab time, this script splits host reconnaissance into two optimized stages. It first executes an ultra-fast raw SYN scan across all 65,535 TCP ports without any version overhead. Once active entry points are discovered, it displays a highlighted visual summary box and prompts you with an interactive menu to deploy targeted deep analysis flags (`-sV`, `-O`, `-sC`) strictly on those open ports.

## ✨ Key Features

- **🎯 Built for CTFs** — Pre-configured to audit target environments across HackTheBox and TryHackMe labs via active VPN profiles.
- **⚡ Two-Stage Architecture** — Eliminates Nmap speed bottlenecks by separating initial port discovery from heavy script execution.
- **🎨 Live Port Highlights** — Instantly prints an easy-to-read, highlighted visual summary box of open ports right after discovery.
- **⚙️ Interactive Deep Scanning Menu** — Choose exactly what you need on the fly:
  1. Service Version Detection (`-sV`)
  2. Operating System Detection (`-O`)
  3. Default Script Scan (`-sC`)
  4. Complete Aggressive Scan (All three combined)
- **📁 Smart File Saving System** — Lets you dynamically choose to save logs after the scan completes, automatically handling both raw directory entries and full file paths (e.g., `/tmp/custom.txt`).

## 📁 Project Structure

.
├── scan.sh # Core interactive script managing fast scanning, port summaries, and targeted Nmap modes
└── setup.sh # Installation engine handling dependency verifications and global /usr/bin/ linkage

## ⚡ Quick Start

### 1. Clone the repository
```bash
git clone https://github.com
cd Ports-Scanner
```

### 2. Run the Environment Setup
The automated setup script detects your OS (`apt` for Linux/Debian, `pacman` for Arch, `dnf` for Fedora, or `brew` for macOS), installs `nmap` if missing, sets permissions, and creates a global terminal link:
```bash
chmod +x setup.sh
./setup.sh
```

### 3. Execute a Target Scan
Because `setup.sh` installs the tool globally to your system binaries, you can run the scanner from **any** working directory in your terminal:
```bash
scan.sh
```
*Simply enter your target CTF instance IP address when prompted.*

## ⚙️ How It Works Under the Hood

The script wraps native `nmap` binaries into a highly efficient multi-tier workflow:
1. **Target Evaluation:** Verifies basic connection reachability over your active VPN profile using quick ping checks.
2. **Exhaustive Discovery:** Sweeps all `1-65535` ports using a raw packet transmission rate (`--min-rate 5000`) and skips DNS lookup (`-n`) to extract open slots in seconds.
3. **Targeted Interrogation:** Isolates only discovered ports to save time, executing version fingerprinters or NSE scripts based on your interactive menu selection.





