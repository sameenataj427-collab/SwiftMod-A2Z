#!/data/data/com.termux/files/usr/bin/bash

# Define the absolute path to the actual file
REAL_FILE=$(ls $HOME/SwiftFlash-A2Z/SwiftMod*.sh | head -n 1)
ALIAS_LINE="alias swiftmod='chmod +x $REAL_FILE && $REAL_FILE'"

# 1. Remove old aliases
sed -i '/alias swiftflash=/d' ~/.bashrc
sed -i '/alias swiftmod=/d' ~/.bashrc

# 2. Add the correct new alias
echo "$ALIAS_LINE" >> ~/.bashrc

# 3. Apply changes
source ~/.bashrc

echo -e "\033[1;32m✅ SwiftMod-A2Z Setup Fixed!\033[0m"
echo -e "\033[1;36mNow just type 'swiftmod' to launch the tool!\033[0m"
