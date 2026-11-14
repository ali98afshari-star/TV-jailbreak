#!/bin/bash
# TV-jailbreak Universal Android TV Customizer
# Main entry script - cross-platform (Linux/macOS/Windows via WSL/Git Bash/Termux)
# RTL Persian/English support

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${SCRIPT_DIR}/lib"
MODULES_DIR="${SCRIPT_DIR}/modules"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# RTL support detection
is_rtl() {
    [[ "${LANG:-}" =~ ^(fa|ar|he) ]] || [[ "${LC_ALL:-}" =~ ^(fa|ar|he) ]]
}

# Print functions with RTL support
print_header() {
    local text="$1"
    local width=60
    printf "\n${CYAN}╔%*s╗${NC}\n" $((width-2)) | sed "s/ /═/g"
    if is_rtl; then
        printf "${CYAN}║${NC} %-*s ${CYAN}║${NC}\n" $((width-4)) "$text"
    else
        printf "${CYAN}║${NC} %-*s ${CYAN}║${NC}\n" $((width-4)) "$text"
    fi
    printf "${CYAN}╚%*s╝${NC}\n\n" $((width-2)) | sed "s/ /═/g"
}

print_step() {
    local icon="$1"
    local text="$2"
    printf "${BLUE}[%s]${NC} %s\n" "$icon" "$text"
}

print_success() {
    printf "${GREEN}[✔]${NC} %s\n" "$1"
}

print_warning() {
    printf "${YELLOW}[⚠]${NC} %s\n" "$1"
}

print_error() {
    printf "${RED}[✘]${NC} %s\n" "$1"
}

print_info() {
    printf "${CYAN}[ℹ]${NC} %s\n" "$1"
}

# Load common library
source "${LIB_DIR}/common.sh"

# Load modules
source "${MODULES_DIR}/launcher.sh"
source "${MODULES_DIR}/bluetooth.sh"
source "${MODULES_DIR}/keymapper.sh"
source "${MODULES_DIR}/accessibility.sh"
source "${MODULES_DIR}/adb-persistence.sh"
source "${MODULES_DIR}/pointer.sh"

# Default config
TV_IP="${TV_IP:-192.168.1.100}"
TV_PORT="${TV_PORT:-5555}"
LAUNCHER_PKG="${LAUNCHER_PKG:-com.spocky.projengmenu}"
LAUNCHER_ACTIVITY="${LAUNCHER_ACTIVITY:-com.spocky.projengmenu/.MainActivity}"
STOCK_LAUNCHER="${STOCK_LAUNCHER:-ir.huma.android.launcher}"
KEYMAPPER_ENABLED="${KEYMAPPER_ENABLED:-true}"
BLUETOOTH_FIX_ENABLED="${BLUETOOTH_FIX_ENABLED:-true}"
ACCESSIBILITY_ENABLED="${ACCESSIBILITY_ENABLED:-true}"
ADB_PERSISTENCE_ENABLED="${ADB_PERSISTENCE_ENABLED:-true}"
POINTER_SPEED="${POINTER_SPEED:--5}"

# Help text
show_help() {
    cat << EOF
TV-jailbreak - Universal Android TV Customizer

استفاده:
  ./tv-customizer.sh [گزینه‌ها]

گزینه‌ها:
  -i, --ip IP           آدرس IP تی‌وی (پیش‌فرض: 192.168.1.100)
  -p, --port PORT       پورت ADB (پیش‌فرض: 5555)
  -l, --launcher PKG    پکیج لانچر دلخواه (پیش‌فرض: com.spocky.projengmenu)
  --no-keymapper        غیرفعال کردن کی‌مپر
  --no-bluetooth        غیرفعال کردن فیکس بلوتوث
  --no-accessibility    غیرفعال کردن اکسسبلیتی
  --no-adb-persist      غیرفعال کردن پایداری ADB
  --pointer-speed N     سرعت پوینتر -7 تا +7 (پیش‌فرض: -5)
  -h, --help            نمایش این راهنما

متغیرهای محیطی:
  TV_IP, TV_PORT, LAUNCHER_PKG, LAUNCHER_ACTIVITY, STOCK_LAUNCHER
  KEYMAPPER_ENABLED, BLUETOOTH_FIX_ENABLED, ACCESSIBILITY_ENABLED
  ADB_PERSISTENCE_ENABLED, POINTER_SPEED

مثال:
  ./tv-customizer.sh -i 192.168.1.50 -l com.spocky.projengmenu
  TV_IP=192.168.1.100 ./tv-customizer.sh --pointer-speed -3
EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -i|--ip) TV_IP="$2"; shift 2 ;;
        -p|--port) TV_PORT="$2"; shift 2 ;;
        -l|--launcher) LAUNCHER_PKG="$2"; shift 2 ;;
        --no-keymapper) KEYMAPPER_ENABLED="false"; shift ;;
        --no-bluetooth) BLUETOOTH_FIX_ENABLED="false"; shift ;;
        --no-accessibility) ACCESSIBILITY_ENABLED="false"; shift ;;
        --no-adb-persist) ADB_PERSISTENCE_ENABLED="false"; shift ;;
        --pointer-speed) POINTER_SPEED="$2"; shift 2 ;;
        -h|--help) show_help; exit 0 ;;
        *) print_error "گزینه ناشناخته: $1"; show_help; exit 1 ;;
    esac
done

# Main execution
main() {
    print_header "TV-jailbreak Universal Android TV Customizer"
    print_info "هدف: ${TV_IP}:${TV_PORT}"
    print_info "لانچر: ${LAUNCHER_PKG}"
    print_info "سرعت پوینتر: ${POINTER_SPEED}"

    # 1. Connect ADB
    print_step "1/6" "اتصال ADB..."
    adb_connect

    # 2. Root access
    print_step "2/6" "درخواست دسترسی روت..."
    adb_root

    # 3. Pointer speed
    print_step "3/6" "تنظیم سرعت پوینتر..."
    set_pointer_speed

    # 4. Bluetooth fix
    if [[ "$BLUETOOTH_FIX_ENABLED" == "true" ]]; then
        print_step "4/6" "فیکس بلوتوث و اتصال خودکار..."
        bluetooth_fix
    else
        print_step "4/6" "بلوتوث: 건너 뛴"
    fi

    # 5. Accessibility
    if [[ "$ACCESSIBILITY_ENABLED" == "true" ]]; then
        print_step "5/6" "فعال‌سازی اکسسبلیتی لانچر..."
        enable_accessibility
    else
        print_step "5/6" "اکسسبلیتی: 건너 뛴"
    fi

    # 6. Launcher switch
    print_step "6/6" "تعویض لانچر به پیش‌فرض..."
    launcher_switch

    # 7. Keymapper (bonus)
    if [[ "$KEYMAPPER_ENABLED" == "true" ]]; then
        print_step "+1" "نصب کی‌مپر دِمن..."
        install_keymapper
    fi

    # 8. ADB Persistence
    if [[ "$ADB_PERSISTENCE_ENABLED" == "true" ]]; then
        print_step "+2" "اطمینان از پایداری ADB..."
        ensure_adb_persistence
    fi

    print_header "✅  تکمیل شد! تی‌وی شما آماده است"
    print_info "لانچر پیش‌فرض: ${LAUNCHER_PKG}"
    print_info "بلوتوث: خودکار فعال"
    print_info "اکسسبلیتی: مجاز"
    print_info "کی‌مپر: در حال اجرا"
}

# Run main
main "$@"