#!/data/data/com.termux/files/usr/bin/bash

# Define the absolute path to the script
SCRIPT_PATH="$HOME/SwiftFlash-A2Z/SwiftFlash.sh"
ALIAS_LINE="alias swiftflash='chmod +x $SCRIPT_PATH && $SCRIPT_PATH'"

# Remove any old broken aliases first
sed -i '/alias swiftflash=/d' ~/.bashrc

# Add the new, corrected alias to .bashrc
echo "$ALIAS_LINE" >> ~/.bashrc

# Apply changes to the current session
source ~/.bashrc

echo -e "\033[1;32m✅ Setup Complete!\033[0m"
echo -e "\033[1;36mNow whenever you use swiftflash, the tool will launch!\033[0m"
