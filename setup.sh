#!/data/data/com.termux/files/usr/bin/bash

# Define the absolute path to the actual file in your folder
# This looks for any .sh file starting with SwiftFlash
REAL_FILE=$(ls $HOME/SwiftFlash-A2Z/SwiftFlash*.sh | head -n 1)
ALIAS_LINE="alias swiftflash='chmod +x $REAL_FILE && $REAL_FILE'"

# 1. Remove all old/broken swiftflash aliases from .bashrc
sed -i '/alias swiftflash=/d' ~/.bashrc

# 2. Add the correct alias using the real filename
echo "$ALIAS_LINE" >> ~/.bashrc

# 3. Fix the current session immediately
source ~/.bashrc

echo -e "\033[1;32m✅ Setup Fixed!\033[0m"
echo -e "\033[1;36mNow whenever you use swiftflash, the tool will launch!\033[0m"
