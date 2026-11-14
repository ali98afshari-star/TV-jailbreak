#!/bin/bash
# Launcher Switcher Module
# Switches default launcher to custom one (Projectivy, FLauncher, etc.)

source "${LIB_DIR}/common.sh"

launcher_switch() {
    print_step "LAUNCHER" "Switching to ${LAUNCHER_PKG}..."

    # 1. Check if custom launcher is installed
    if ! tv_package_exists "$LAUNCHER_PKG"; then
        print_error "لانچر ${LAUNCHER_PKG} نصب نیست"
        print_info "اول فایل APK لانچر را نصب کنید:"
        print_info "  adb install path/to/launcher.apk"
        return 1
    fi
    print_success "لانچر ${LAUNCHER_PKG} یافت شد"

    # 2. Disable stock launcher (Huma/KGZN/Snowa common packages)
    local stock_launchers=(
        "ir.huma.android.launcher"
        "com.kgzn.launcher"
        "com.mstar.tv.launcher"
        "com.android.launcher3"
        "com.google.android.tvlauncher"
    )

    for stock in "${stock_launchers[@]}"; do
        if tv_package_exists "$stock"; then
            print_step "LAUNCHER" "غیرفعال کردن لانچر استوک: $stock"
            tv_disable_package "$stock"
        fi
    done

    # 3. Enable custom launcher
    tv_enable_package "$LAUNCHER_PKG"

    # 4. Set as default home
    print_step "LAUNCHER" "تنظیم به عنوان پیش‌فرض..."
    tv_set_default_launcher "$LAUNCHER_PKG"

    # 5. Start launcher activity
    tv_start_activity "$LAUNCHER_ACTIVITY"

    print_success "لانچر با موفقیت تغییر کرد"
    return 0
}

# If run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    launcher_switch "$@"
fi