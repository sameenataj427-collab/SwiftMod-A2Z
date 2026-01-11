#!/data/data/com.termux/files/usr/bin/bash

# Define the alias command
ALIAS_LINE="alias swiftflash='cd ~/SwiftFlash-A2Z && chmod +x SwiftFlash.sh && ./SwiftFlash.sh'"

# Check if the alias already exists in .bashrc
if grep -q "alias swiftflash=" ~/.bashrc; then
    echo -e "\033[1;33m⚠️ Alias 'swiftflash' already exists.\033[0m"
else
    # Add the alias to .bashrc
    echo "$ALIAS_LINE" >> ~/.bashrc
    echo -e "\033[1;32m✅ Alias 'swiftflash' added successfully!\033[0m"
fi

echo -e "\033[1;36m🔄 Restarting bash... You can now just type 'swiftflash' to start!\033[0m"
source ~/.bashrc
