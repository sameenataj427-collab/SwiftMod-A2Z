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
if [ -d .git ]; then
    echo -e "${C}Checking for updates...${N}"
    git fetch origin main &>/dev/null
    LOCAL=$(git rev-parse HEAD)
    REMOTE=$(git rev-parse @{u})
    if [ "$LOCAL" != "$REMOTE" ]; then
        echo -e "${Y}🚀 Syncing Private Updates...${N}"
        git reset --hard origin/main &>/dev/null
        echo -e "${G}✅ Updated. Restarting...${N}"
        sleep 1
        exec bash "$0" "$@"
    fi
fi

draw_ui() {
    clear
    echo -e "${C}┌──────────────────────────────────────────────────────────┐${N}"
    echo -e "${C}│${W}  ⚡  SWIFTMOD-A2Z : PRIVATE MASTER STATION  ⚡        ${C}│${N}"
    echo -e "${C}└──────────────────────────────────────────────────────────┘${N}"
    echo -e "   ${G}Redmi Note 10S | Galaxy A04 | Hot 30 5G | Mi 10i${N}"
    echo -e "${P}────────────────────────────────────────────────────────────${N}"
    echo -e "  ${G}1.  ⚡ Reboot Bootloader      10. 🚀 ADB Sideload (.zip)"
    echo -e "  ${G}2.  🔄 Reboot System          11. 🔍 Fastboot Check"
    echo -e "  ${G}3.  🛡️  Flash VBMETA           12. 🔍 ADB Check"
    echo -e "  ${G}4.  🌀 Reboot FastbootD       13. 📂 Flash FB ROM"
    echo -e "  ${G}5.  📱 Flash GSI Image        14. ⌨️  Manual Command"
    echo -e "  ${G}6.  📦 Flash Super.img        15. 🧹 Format / Wipe"
    echo -e "  ${G}7.  👞 Flash Boot.img         16. 📜 View/Clear Logs"
    echo -e "  ${G}8.  🛠️  Flash Recovery.img     17. 🔓 Unlock Bootloader"
    echo -e "  ${B}9.  🚀 Flash Init_Boot.img    18. 🔄 Switch Slot (A/B)${N}"
    echo -e "  ${R}0.  ❌ Exit Tool${N}"
    
    echo -e "\n${C}╔══════════════════════════════════════════════════════════╗${N}"
    echo -e "${C}║${W} Enter choice [0-18] below:                               ${C}║${N}"
    echo -e "${C}╚══════════════════════════════════════════════════════════╝${N}"
}

check_return() {
    echo -n -e "\n${Y}Return to menu? (y/n): ${N}"
    read return_choice
    [[ "$return_choice" != "y" ]] && exit 0
}

while true; do
    draw_ui
    echo -n -e "${Y}Selection: ${N}"
    read choice
    case $choice in
        1) adb reboot bootloader ; check_return ;;
        2) fastboot reboot ; check_return ;;
        3) echo -e "${P}VBMETA path:${N}"; read -e v; fastboot --disable-verity --disable-verification flash vbmeta "$v"; check_return ;;
        4) fastboot reboot fastboot ; check_return ;;
        5) echo -e "${P}GSI path:${N}"; read -e gs; fastboot flash -S 100M system "$gs"; check_return ;;
        6) echo -e "${P}Super path:${N}"; read -e sp; fastboot flash -S 100M super "$sp"; check_return ;;
        7) echo -e "${P}Boot path:${N}"; read -e b; fastboot flash boot "$b"; check_return ;;
        8) echo -e "${P}Recovery path:${N}"; read -e r; fastboot flash recovery "$r"; check_return ;;
        9) echo -e "${P}Init_Boot path:${N}"; read -e ib; fastboot flash init_boot "$ib"; check_return ;;
        10) echo -e "${P}Zip path:${N}"; read -e z; adb sideload "$z"; check_return ;;
        11) fastboot devices; check_return ;;
        12) adb devices; check_return ;;
        13) echo -e "${Y}Run local flash-all.sh...${N}"; check_return ;;
        14) while true; do echo -n -e "${C}Private-A2Z > ${N}"; read -e m; [[ "$m" == "exit" ]] && break; eval "$m"; done ;;
        15) fastboot erase userdata && fastboot erase metadata; check_return ;;
        16) [[ -f "$LOG_FILE" ]] && tail -n 10 "$LOG_FILE" || echo "No logs."; check_return ;;
        17) fastboot flashing unlock || fastboot oem unlock; check_return ;;
        18) fastboot set_active other; check_return ;;
        0) exit 0 ;;
        *) echo -e "${R}Invalid!${N}" ; sleep 1 ;;
    esac
done
