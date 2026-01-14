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

# --- Matrix Loading Animation (Flex Feature) ---
loading_flex() {
    clear
    echo -e "${G}Initializing Mubarak Pasha's Private Engine...${N}"
    sleep 0.2
    for i in {1..15}; do
        echo -e "${G}$((RANDOM%2)) $((RANDOM%2)) $((RANDOM%2)) $((RANDOM%2)) $((RANDOM%2)) $((RANDOM%2)) $((RANDOM%2)) $((RANDOM%2)) $((RANDOM%2)) $((RANDOM%2))${N}"
        sleep 0.05
    done
    echo -e "${C}✅ SECURITY CLEARANCE GRANTED.${N}"
    sleep 0.5
}

# --- Auto-Update Engine ---
cd "$(dirname "$0")"
if [ -d .git ]; then
    git fetch origin main &>/dev/null
    LOCAL=$(git rev-parse HEAD)
    REMOTE=$(git rev-parse @{u})
    if [ "$LOCAL" != "$REMOTE" ]; then
        echo -e "${Y}🚀 Mubarak, an update is ready! Downloading...${N}"
        git reset --hard origin/main &>/dev/null
        sleep 1
        exec bash "$0" "$@"
    fi
fi

log_action() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] - $1" >> "$LOG_FILE"
}

draw_ui() {
    clear
    # --- Professional Header ---
    echo -e "${C}┌──────────────────────────────────────────────────────────┐${N}"
    echo -e "${C}│${W}  ⚡  ${BOLD}SWIFTMOD-A2Z : PRIVATE MASTER STATION${N}${C}           │${N}"
    echo -e "${C}│${P}  Lead Developer: Mubarak Pasha                         ${C}│${N}"
    echo -e "${C}└──────────────────────────────────────────────────────────┘${N}"
    
    # --- Hardware Flex Bar (Shows off your phone specs) ---
    MODEL=$(getprop ro.product.model)
    CPU=$(getprop ro.product.board)
    OS=$(getprop ro.build.version.release)
    echo -e "${W} 📱 MODEL: ${G}$MODEL ${W}| ⚙️ CPU: ${G}$CPU ${W}| 🤖 ANDROID: ${G}$OS${N}"
    echo -e "${P}────────────────────────────────────────────────────────────${N}"
    
    # --- Single Column Options ---
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
    echo -e "  ${P}19. 🕵️  Deep Hardware Scan (FLEX)${N}"
    echo -e "  ${R}0.  ❌ Exit Tool${N}"
    
    # --- Mubarak's Choice Box ---
    echo -e "\n${C}╔══════════════════════════════════════════════════════════╗${N}"
    echo -e "${C}║${W} Enter choice [0-19] below, Mubarak:                      ${C}║${N}"
    echo -e "${C}╚══════════════════════════════════════════════════════════╝${N}"
}

check_return() {
    echo -n -e "\n${Y}Return to menu, Mubarak? (y/n): ${N}"
    read return_choice
    [[ "$return_choice" != "y" ]] && exit 0
}

# Run the intro once per launch
loading_flex

while true; do
    draw_ui
    echo -n -e "${Y}Selection: ${N}"
    read choice
    case $choice in
        1) adb reboot bootloader ; check_return ;;
        2) fastboot reboot ; check_return ;;
        3) echo -e "${P}VBMETA path:${N}"; read -e v; fastboot --disable-verity --disable-verification flash vbmeta "$v"; check_return ;;
        4) fastboot reboot fastboot ; check_return ;;
        5) echo -e "${P}GSI path:${N}"; read -e gs; fastboot flash system "$gs"; check_return ;;
        6) echo -e "${P}Super path:${N}"; read -e sp; fastboot flash super "$sp"; check_return ;;
        7) echo -e "${P}Boot path:${N}"; read -e b; fastboot flash boot "$b"; check_return ;;
        8) echo -e "${P}Recovery path:${N}"; read -e r; fastboot flash recovery "$r"; check_return ;;
        9) echo -e "${P}Init_Boot path:${N}"; read -e ib; fastboot flash init_boot "$ib"; check_return ;;
        10) echo -e "${P}Zip path:${N}"; read -e z; adb sideload "$z"; check_return ;;
        11) fastboot devices; check_return ;;
        12) adb devices; check_return ;;
        13) echo -e "${Y}Ensure flash-all.sh is in directory.${N}"; check_return ;;
        14) while true; do echo -n -e "${C}Mubarak-Pasha > ${N}"; read -e m; [[ "$m" == "exit" ]] && break; eval "$m"; done ;;
        15) fastboot erase userdata && fastboot erase metadata; check_return ;;
        16) [[ -f "$LOG_FILE" ]] && tail -n 10 "$LOG_FILE" || echo "No logs."; check_return ;;
        17) fastboot flashing unlock || fastboot oem unlock; check_return ;;
        18) fastboot set_active other; check_return ;;
        19) 
            echo -e "${C}--- DEEP SCAN (MUBARAK'S PRIVATE DATA) ---${N}"
            getprop | grep -E "model|brand|board|serial|cpu|platform"
            check_return ;;
        0) exit 0 ;;
        *) echo -e "${R}Invalid!${N}" ; sleep 1 ;;
    esac
done
