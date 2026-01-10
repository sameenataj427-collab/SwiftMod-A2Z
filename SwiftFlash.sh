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

LOG_FILE="$HOME/.swiftflash_logs.txt"

log_action() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] - $1" >> "$LOG_FILE"
}

# --- Partition Size Validation Engine ---
validate_size() {
    local file_path=$1
    local partition=$2
    
    # Get file size in bytes
    local file_bytes=$(stat -c%s "$file_path")
    
    # Get partition size from fastboot
    local part_hex=$(fastboot getvar partition-size:$partition 2>&1 | grep "$partition" | awk '{print $2}')
    
    if [[ -z "$part_hex" || "$part_hex" == "0x" ]]; then
        echo -e "${Y}⚠️  Warning: Could not verify partition size. Proceeding...${N}"
        return 0
    fi

    local part_bytes=$((part_hex))

    if [ "$file_bytes" -gt "$part_bytes" ]; then
        echo -e "${BOLD}${R}❌ ERROR: THE IMAGE WILL NOT FIT IN THIS PARTITION!${N}"
        echo -e "${W}File Size: $((file_bytes/1024/1024)) MB${N}"
        echo -e "${W}Partition Limit: $((part_bytes/1024/1024)) MB${N}"
        return 1
    else
        echo -e "${G}✅ Size Validation Passed: Image fits.${N}"
        return 0
    fi
}

# --- Flash Wipe Logic ---
flash_wipe_request() {
    echo -e "\n${C}💡 INFO: If you are changing ROMs, a Data Wipe is MANDATORY.${N}"
    echo -n -e "${Y}Include Data Wipe? (y/n): ${N}"
    read w_choice
    if [[ "$w_choice" == "y" ]]; then
        echo -e "${BOLD}${R}❗ SECOND CHECK: ARE YOU REALLY SURE? (y/n): ${N}"
        read w_sure
        [[ "$w_sure" == "y" ]] && return 0
    fi
    return 1
}

draw_ui() {
    clear
    echo -e "${C}┌──────────────────────────────────────────────────────────┐${N}"
    echo -e "${C}│${W}  ⚡  SWIFTFLASH-A2Z : ANDROID MODDING TOOLKIT  ⚡       ${C}│${N}"
    echo -e "${C}└──────────────────────────────────────────────────────────┘${N}"
    echo -e "   ${G}Developer: Repair-A2Z | Build: Stable-V1.1${N}"
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
    echo -e "  ${G}11. 🔍 Check Fastboot/ADB Devices"
    echo -e "  ${C}12. 📂 Flash Fastboot ROM (flash script needed)"
    echo -e "  ${B}13. ⌨️  Manual Command Execution"
    echo -e "  ${R}14. 🧹 Format Data (Wipe All Data)"
    echo -e "  ${Y}15. 📜 View / Clear Flash Logs"
    echo -e "  ${R}16. 🔓 Unlock Bootloader (Xiaomi NOT Supported)"
    echo -e "  ${C}17. 🔄 Switch Active Slot (A/B)${N}"
    echo -e "  ${R}0.  ❌ Exit Tool${N}"
    
    echo -e "\n${C}┌──────────────────────────────────────────────────────────┐${N}"
    echo -e "${C}│${N} ${W}Enter your choice [0-17] below:${N}"
    echo -e "${C}└──────────────────────────────────────────────────────────┘${N}"
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
        5)
            echo -e "${P}📁 Provide GSI path (.img):${N}"; read -e gsipath
            if ! validate_size "$gsipath" "super"; then check_return; continue; fi
            echo -n -e "${Y}🔢 Enter Preferred Chunk Size in MB (e.g., 100): ${N}"; read csize
            [[ -z "$csize" ]] && csize="100"
            echo -e "${P}🛡️  Provide VBMETA path:${N}"; read -e vbpath
            if flash_wipe_request; then do_wipe="y"; else do_wipe="n"; fi
            fastboot flash -S "${csize}M" super "$gsipath"
            fastboot --disable-verity --disable-verification flash vbmeta "$vbpath"
            [[ "$do_wipe" == "y" ]] && fastboot erase userdata
            log_action "GSI Flash: $gsipath (Chunk: ${csize}M)"
            check_return ;;
        6)
            echo -e "${P}📁 Provide Super path:${N}"; read -e spath
            if ! validate_size "$spath" "super"; then check_return; continue; fi
            echo -n -e "${Y}🔢 Enter Preferred Chunk Size in MB (e.g., 512): ${N}"; read csize
            [[ -z "$csize" ]] && csize="100"
            echo -e "${P}🛡️  Provide VBMETA path:${N}"; read -e vb
            if flash_wipe_request; then do_wipe="y"; else do_wipe="n"; fi
            fastboot -v -S "${csize}M" flash super "$spath"
            fastboot --disable-verity --disable-verification flash vbmeta "$vb"
            [[ "$do_wipe" == "y" ]] && fastboot erase userdata
            log_action "Super Flash: $spath (Chunk: ${csize}M)"
            check_return ;;
        17)
            echo -e "${C}Current Active Slot Info:${N}"
            fastboot getvar current-slot
            echo -n -e "${P}Switch to the other slot? (y/n): ${N}"
            read slot_choice
            if [[ "$slot_choice" == "y" ]]; then
                fastboot set_active other
                log_action "Switched Active Slot"
            fi
            check_return ;;
        16) 
            echo -e "${BOLD}${R}🚨 WARNING: XIAOMI NOT SUPPORTED!${N}"
            echo -n -e "${Y}Is your device NOT a Xiaomi? (y/n): ${N}"; read lock1
            if [[ "$lock1" == "y" ]]; then
                echo -n -e "${Y}Start Unlock? (y/n): ${N}"; read lock3
                if [[ "$lock3" == "y" ]]; then
                    fastboot flashing unlock || fastboot oem unlock
                    log_action "Bootloader Unlock Attempted"
                fi
            fi
            check_return ;;
        1) adb reboot bootloader ; check_return ;;
        2) fastboot reboot ; check_return ;;
        3) echo -e "${P}VBMETA path:${N}"; read -e v; fastboot --disable-verity --disable-verification flash vbmeta "$v"; check_return ;;
        4) fastboot reboot fastboot ; check_return ;;
        7) echo -e "${P}Boot path:${N}"; read -e b; fastboot flash boot "$b"; check_return ;;
        8) echo -e "${P}Recovery path:${N}"; read -e r; fastboot flash recovery "$r"; check_return ;;
        11) fastboot devices; adb devices; check_return ;;
        13) while true; do echo -n -e "${C}SwiftFlash > ${N}"; read -e m; [[ "$m" == "exit" ]] && break; eval "$m"; done ;;
        14) fastboot erase userdata && fastboot erase metadata; check_return ;;
        15) tail -n 15 "$LOG_FILE"; check_return ;;
        0) exit 0 ;;
        *) echo -e "${R}Invalid!${N}" ; sleep 1 ;;
    esac
done
 0) exit 0 ;;
        *) echo -e "${R}Invalid!${N}" ; sleep 1 ;;
    esac
done
 echo -e "${R}Invalid!${N}" ; sleep 1 ;;
    esac
done
  esac
done
c
done
