#!/data/data/com.termux/files/usr/bin/bash

# --- SwiftMod-A2Z Setup ---
# 1. Find the real script file
REAL_FILE=$(ls $HOME/SwiftMod-A2Z/SwiftMod*.sh | head -n 1)

# 2. Clean up old/broken aliases to prevent the ">" error
sed -i '/alias swiftflash=/d' ~/.bashrc
sed -i '/alias swiftmod=/d' ~/.bashrc

# 3. Write the new alias carefully using double quotes
# This prevents the "unclosed quote" issue causing the > prompt
echo "alias swiftmod='bash $REAL_FILE'" >> ~/.bashrc

# 4. Make the file executable
chmod +x "$REAL_FILE"

echo -e "\033[1;32m✅ SwiftMod-A2Z Setup Fixed!\033[0m"
echo -e "\033[1;33mPlease restart Termux or type: source ~/.bashrc\033[0m"
