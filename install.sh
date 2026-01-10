#!/data/data/com.termux/files/usr/bin/bash

# --- SwiftFlash-A2Z Installer ---
echo -e "\033[1;36m⚡ Installing SwiftFlash-A2Z dependencies...\033[0m"

# 1. Install necessary packages
pkg update -y
pkg install android-tools curl git ncurses-utils -y

# 2. Download the main script into the system's "bin" folder
echo -e "\033[1;36m📥 Downloading SwiftFlash-A2Z...\033[0m"

# FIXED LINK: Ensure this matches your file name 'SwiftFlash.sh' exactly
curl -sS https://raw.githubusercontent.com/sameenataj427-collab/SwiftFlash-A2Z/main/SwiftFlash.sh -o $PREFIX/bin/swiftflash

# 3. Make it executable
chmod +x $PREFIX/bin/swiftflash

echo -e "\033[1;32m✅ Installation Complete!\033[0m"
echo -e "\033[1;33mUsage: Just type \033[1;37mswiftflash\033[1;33m to start the tool.\033[0m"
