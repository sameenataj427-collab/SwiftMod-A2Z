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

# --- Stealth Auto-Update Engine ---
cd "$(dirname "$0")"
if [ -d .git ]; then
    git fetch origin main &>/dev/null
    LOCAL=$(git rev-parse HEAD)
    REMOTE=$(git rev-parse @{u})
    if [ "$LOCAL" != "$REMOTE" ]; then
        echo -e "${Y}🚀 System update detected. Synchronizing...${N}"
        git reset --hard origin/main &>/dev/null
        sleep 1
        exec bash "$0" "$@"
    fi
fi

# --- Matrix Loading Animation ---
loading_flex() {
    clear
    echo -e "${G}Initializing Private Engine...${N}"
    sleep 0.2
    for i in {1..15}; do
        echo -e "${G}$((RANDOM%2)) $((RANDOM%2)) $((RANDOM%2)) $((RANDOM%2)) $((RANDOM%2)) $((RANDOM%2)) $((RANDOM%2)) $((RANDOM%2)) $((RANDOM%2)) $((RANDOM%2))${N}"
        sleep 0.05
    done
    echo -e "${C}✅ SECURITY CLEARANCE GRANTED.${N}"
    sleep 0.5
}

draw_ui() {
    clear
    echo -e "${C}┌──────────────────────────────────────────────────────────┐${N}"
    echo -e "${C}│${W}  ⚡  ${BOLD}SWIFTMOD-A2Z : PRIVATE MASTER STATION${N}${C}           │${N}"
    echo -e "${C}│${P}  Lead Developer: Mubarak Pasha                         ${C}│${N}"
    echo -e "${C}└──────────────────────────────────────────────────────────┘${N}"
    
    MODEL=$(getprop ro.product.model)
    CPU=$(getprop ro.product.board)
    OS=$(getprop ro.build.version.release)
    echo -e "${W} 📱 MODEL: ${G}$MODEL ${W}| ⚙️ CPU: ${G}$CPU ${W}| 🤖 ANDROID: ${G}$OS${N}"
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
    echo -e "  ${G}11. 🖼️  Flash Logo.bin (Boot Logo)"
    echo -e "  ${C}12. 🔍 Check Fastboot Devices"
    echo -e "  ${C}13. 🔍 Check ADB Devices"
    echo -e "  ${G}14. 📂 Flash Fastboot ROM (script)"
    echo -e "  ${B}15. ⌨️  Manual Command Execution"
    echo -e "  ${R}16. 🧹 Format Data (Wipe All Data)"
    echo -e "  ${Y}17. 📜 View / Clear Flash Logs"
    echo -e "  ${R}18. 🔓 Unlock Bootloader (No Xiaomi)"
    echo -e "  ${C}19. 🔄 Switch Active Slot (A/B)${N}"
    echo -e "  ${P}20. 🔥 Device Hardware Scan${N}"
    echo -e "  ${R}0.  ❌ Exit Tool${N}"
    
    echo -e "\n${C}╔══════════════════════════════════════════════════════════╗${N}"
    echo -e "${C}║${W} Enter choice [0-20] below:                               ${C}║${N}"
    echo -e "${C}╚══════════════════════════════════════════════════════════╝${N}"
}

check_return() {
    echo -n -e "\n${Y}Return to menu? (y/n): ${N}"
    read return_choice
    [[ "$return_choice" != "y" ]] && exit 0
}

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
        11) echo -e "${P}Logo.bin path:${N}"; read -e l; fastboot flash logo "$l"; check_return ;;
        12) fastboot devices; check_return ;;
        13) adb devices; check_return ;;
        14) echo -e "${Y}Ensure flash-all.sh is in directory.${N}"; check_return ;;
        15) while true; do echo -n -e "${C}SwiftMod > ${N}"; read -e m; [[ "$m" == "exit" ]] && break; eval "$m"; done ;;
        16) fastboot erase userdata && fastboot erase metadata; check_return ;;
        17) [[ -f "$LOG_FILE" ]] && tail -n 10 "$LOG_FILE" || echo "No logs."; check_return ;;
        18) fastboot flashing unlock || fastboot oem unlock; check_return ;;
        19) fastboot set_active other; check_return ;;
        20) 
            clear
            echo -e "${C}╔══════════════════════════════════════════════════════╗${N}"
            echo -e "${C}║${W}        🔥 ULTIMATE SYSTEM DIAGNOSTIC 🔥              ${C}║${N}"
            echo -e "${C}╚══════════════════════════════════════════════════════╝${N}"
            
            echo -e "${Y}--- [ HARDWARE & ENGINE ] ---${N}"
            echo -e "${W}Processor  :${G} $(getprop ro.soc.model)${N}"
            echo -e "${W}Architecture:${G} $(getprop ro.product.cpu.abi)${N}"
            [ -x "$(command -v su)" ] && echo -e "${W}Root Status:${G} YES (Rooted)${N}" || echo -e "${W}Root Status:${R} NO (Unrooted)${N}"
            
            echo -e "\n${Y}--- [ POWER & MEMORY ] ---${N}"
            if command -v termux-battery-status &> /dev/null; then
                BATT=$(termux-battery-status)
                echo -e "${W}Battery    :${G} $(echo $BATT | grep -oP '(?<="percentage": )[0-9]+')%${N}"
                echo -e "${W}Health     :${G} $(echo $BATT | grep -oP '(?<="health": ")[^"]+') (Temp: $(echo $BATT | grep -oP '(?<="temperature": )[0-9.]+')°C)${N}"
            else
                echo -e "${W}Battery    :${R} Termux:API not found${N}"
            fi
            free -h | awk 'NR==2 {print "RAM Usage  : Used: "$3" / Total: "$2}'
            
            echo -e "\n${Y}--- [ NETWORK STATUS ] ---${N}"
            IP_ADDR=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7}')
            [ -z "$IP_ADDR" ] && echo -e "${W}Local IP   :${R} Offline${N}" || echo -e "${W}Local IP   :${G} $IP_ADDR${N}"
            
            echo -e "\n${Y}--- [ STORAGE STATUS ] ---${N}"
            df -h /data | awk 'NR==2 {print "Internal   : Free "$4" of "$2" total"}'
            
            echo -e "\n${P}>> Built by Mubarak Pasha for Repair A2Z <<${N}"
            check_return ;;
        0) exit 0 ;;
        *) echo -e "${R}Invalid!${N}" ; sleep 1 ;;
    esac
done
