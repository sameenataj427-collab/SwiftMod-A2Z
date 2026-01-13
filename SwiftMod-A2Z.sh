#!/data/data/com.termux/files/usr/bin/bash

# --- Color Definitions ---
G='\033[1;32m' # Green
R='\033[1;31m' # Red
Y='\033[1;33m' # Yellow
B='\033[1;34m' # Blue
P='\033[1;35m' # Purple
C='\033[1;36m' # Cyan
W='\033[1;37m' # White
BOLD='\033[1m'
N='\033[0m'    # Reset

LOG_FILE="$HOME/.swiftmod_logs.txt"

# --- Auto-Update Engine ---
cd "$(dirname "$0")"
echo -e "${C}Checking for updates...${N}"
if [ -d .git ]; then
    git fetch origin main &>/dev/null
    LOCAL=$(git rev-parse HEAD)
    REMOTE=$(git rev-parse @{u})
    if [ "$LOCAL" != "$REMOTE" ]; then
        echo -e "${Y}🚀 New update found! Updating SwiftMod-A2Z...${N}"
        git reset --hard origin/main &>/dev/null
        echo -e "${G}✅ Updated successfully. Restarting tool...${N}"
        sleep 1
        exec bash "$0" "$@"
    fi
fi

log_action() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] - $1" >> "$LOG_FILE"
}

validate_size() {
    local file_path=$1
    local partition=$2
    local file_bytes=$(stat -c%s "$file_path")
    local part_hex=$(fastboot getvar partition-size:$partition 2>&1 | grep "$partition" | awk '{print $2}')
    if [[ -z "$part_hex" || "$part_hex" == "0x" ]]; then
        echo -e "${Y}⚠️  Warning: Could not verify partition size. Proceeding...${N}"
        return 0
    fi
    local part_bytes=$((part_hex))
    if [ "$file_bytes" -gt "$part_bytes" ]; then
        echo -e "${BOLD}${R}❌ ERROR: THE IMAGE WILL NOT FIT IN THIS PARTITION!${N}"
        return 1
    else
        echo -e "${G}✅ Size Validation Passed.${N}"
        return 0
    fi
}

flash_wipe_request() {
    echo -e "\n${C}💡 INFO: Data Wipe is recommended for new ROMs.${N}"
    echo -n -e "${Y}Include Data Wipe? (y/n): ${N}"
    read w_choice
    [[ "$w_choice" == "y" ]] && return 0 || return 1
}

draw_ui() {
    clear
    echo -e "${C}┌──────────────────────────────────────────────────────────┐${N}"
    echo -e "${C}│${W}  ⚡  SWIFTMOD-A2Z : ANDROID MODDING TOOLKIT  ⚡        ${C}│${N}"
    echo -e "${C}└──────────────────────────────────────────────────────────┘${N}"
    echo -e "   ${G}Dev: SwiftMod-A2Z | Build: Stable-V1.0${N}"
    echo -e "${P}────────────────────────────────────────────────────────────${N}"
    echo -e "  ${G}1.  ⚡ Reboot to Bootloader (ADB)"
    echo -e "  ${G}2.  🔄 Reboot System (Fastboot)"
    echo -e "  ${G}3.  🛡️  Flash VBMETA (AVB Disable)"
    echo -e "  ${G}4.  🌀 Reboot to FastbootD (fastboot)"
    echo -e "  ${G}5.  📱 Flash GSI / System Image"
    echo -e "  ${G}6.  📦 Flash Super.img"
    echo -e "  ${G}7.  👞 Flash Boot.img"
    echo -e "  ${G}8.  🛠️  Flash Recovery.img"
    echo -e "  ${B}9.  🚀 Flash Init_Boot.img${N}"
    echo -e "  ${G}10. 🚀 Flash ROM via ADB Sideload (.zip)"
    echo -e "  ${C}11. 🔍 Check Fastboot Devices"
    echo -e "  ${C}12. 🔍 Check ADB Devices"
    echo -e "  ${G}13. 📂 Flash Fastboot ROM (script needed)"
    echo -e "  ${B}14. ⌨️  Manual Command Execution"
    echo -e "  ${R}15. 🧹 Format Data (Wipe All Data)"
    echo -e "  ${Y}16. 📜 View / Clear Flash Logs"
    echo -e "  ${R}17. 🔓 Unlock Bootloader (No Xiaomi)"
    echo -e "  ${C}18. 🔄 Switch Active Slot (A/B)${N}"
    echo -e "  ${R}0.  ❌ Exit Tool${N}"
    
    # --- CLEAN DOUBLE-LINE BOX WITHOUT MAGENTA ---
    echo -e "${C}╔══════════════════════════════════════════════════════════╗${N}"
    echo -e "${C}║${W} Enter your choice [0-18] below:                          ${C}║${N}"
    echo -e "${C}╚══════════════════════════════════════════════════════════╝${N}"
}

check_return() {
    echo -e "\n${Y}Return to main menu? (y/n): ${N}"
    read return_choice
    [[ "$return_choice" != "y" ]] && exit 0
}

while true; do
    draw_ui
    echo -n -e "${Y}Choice: ${N}"
    read choice
    case $choice in
        1) adb reboot bootloader ; check_return ;;
        2) fastboot reboot ; check_return ;;
        3) echo -e "${P}VBMETA path:${N}"; read -e v; fastboot --disable-verity --disable-verification flash vbmeta "$v"; check_return ;;
        4) fastboot reboot fastboot ; check_return ;;
        5)
            echo -e "${P}📁 Provide GSI path:${N}"; read -e gsipath
            if ! validate_size "$gsipath" "super"; then check_return; continue; fi
            echo -n -e "${Y}🔢 Chunk Size MB (Default 100): ${N}"; read csize
            [[ -z "$csize" ]] && csize="100"
            echo -e "${P}🛡️  Provide VBMETA path:${N}"; read -e vbpath
            flash_wipe_request && do_wipe="y" || do_wipe="n"
            fastboot flash -S "${csize}M" super "$gsipath"
            fastboot --disable-verity --disable-verification flash vbmeta "$vbpath"
            [[ "$do_wipe" == "y" ]] && fastboot erase userdata
            log_action "GSI Flash: $gsipath"
            check_return ;;
        6)
            echo -e "${P}📁 Provide Super path:${N}"; read -e spath
            if ! validate_size "$spath" "super"; then check_return; continue; fi
