#!/data/data/com.termux/files/usr/bin/bash

# --- SwiftMod-A2Z Installer ---
echo -e "\033[1;36m⚡ Installing SwiftMod-A2Z dependencies...\033[0m"

pkg update -y
pkg install android-tools curl git ncurses-utils -y

echo -e "\033[1;36m📥 Downloading SwiftMod-A2Z...\033[0m"

# Ensure your filename on GitHub is renamed to SwiftMod.sh
curl -sS https://raw.githubusercontent.com/sameenataj427-collab/SwiftFlash-A2Z/main/SwiftMod.sh -o $PREFIX/bin/swiftmod

chmod +x $PREFIX/bin/swiftmod

echo -e "\033[1;32m✅ Installation Complete!\033[0m"
echo -e "\033[1;33mUsage: Just type \033[1;37mswiftmod\033[1;33m to start the tool.\033[0m"
