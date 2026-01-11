#!/data/data/com.termux/files/usr/bin/bash

# Define the absolute path using your EXACT filename
SCRIPT_PATH="$HOME/SwiftFlash-A2Z/SwiftFlash-A2Z.sh"
ALIAS_LINE="alias swiftflash='chmod +x $SCRIPT_PATH && $SCRIPT_PATH'"

# Remove old broken aliases to keep .bashrc clean
sed -i '/alias swiftflash=/d' ~/.bashrc

# Add the corrected alias
echo "$ALIAS_LINE" >> ~/.bashrc

# Apply changes immediately
source ~/.bashrc

echo -e "\033[1;32m✅ Setup Complete!\033[0m"
echo -e "\033[1;36mNow whenever you use swiftflash, the tool will launch!\033[0m"
