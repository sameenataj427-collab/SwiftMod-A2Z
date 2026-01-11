#!/data/data/com.termux/files/usr/bin/bash

# Define the alias command
ALIAS_LINE="alias swiftflash='cd ~/SwiftFlash-A2Z && chmod +x SwiftFlash.sh && ./SwiftFlash.sh'"

# Check if the alias already exists in .bashrc to avoid duplicates
if grep -q "alias swiftflash=" ~/.bashrc; then
    echo -e "\033[1;33m⚠️ Alias 'swiftflash' already exists.\033[0m"
else
    # Add the alias to .bashrc (the Termux startup file)
    echo "$ALIAS_LINE" >> ~/.bashrc
    echo -e "\033[1;32m✅ Alias 'swiftflash' added successfully!\033[0m"
fi

# Apply the changes immediately
source ~/.bashrc

echo -e "\033[1;36mNow whenever you use swiftflash, the tool will launch!\033[0m"
