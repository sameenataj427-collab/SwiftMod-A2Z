#!/data/data/com.termux/files/usr/bin/bash

# Define the absolute path to the main script
# This ensures we find the file regardless of its exact version name
REAL_FILE=$(ls $HOME/SwiftMod-A2Z/SwiftMod*.sh | head -n 1)

# 1. Remove any old or broken aliases to prevent conflicts
sed -i '/alias swiftflash=/d' ~/.bashrc
sed -i '/alias swiftmod=/d' ~/.bashrc

# 2. Add the clean alias with proper quoting
# We use double quotes on the outside and single quotes for the command
echo "alias swiftmod='bash $REAL_FILE'" >> ~/.bashrc

# 3. Make the main script executable just in case
chmod +x "$REAL_FILE"

# 4. Refresh the current session
source ~/.bashrc

echo -e "\033[1;32m✅ SwiftMod-A2Z Setup Fixed!\033[0m"
echo -e "\033[1;36mYou can now type 'swiftmod' to launch the tool.\033[0m"
