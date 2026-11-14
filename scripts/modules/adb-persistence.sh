#!/bin/bash
# ADB Persistence Module
# Ensures ADB debugging stays enabled and port 5555 stays open

source "${LIB_DIR}/common.sh"

ensure_adb_persistence() {
    print_step "ADB" "Ensuring ADB persistence..."

    # 1. Enable ADB over network (port 5555)
    print_step "ADB" "Setting TCP port 5555..."
    tv_sh "setprop service.adb.tcp.port 5555" 2>/dev/null
    tv_sh "stop adbd && start adbd" 2>/dev/null || true
    sleep 2

    # 2. Verify ADB is listening
    local listening
    listening=$(tv_sh "netstat -tlnp 2>/dev/null | grep :5555" || tv_sh "ss -tlnp 2>/dev/null | grep :5555")
    if [[ -n "$listening" ]]; then
        print_success "ADB listening on port 5555"
    else
        print_warning "ADB port 5555 not confirmed listening"
    fi

    # 3. Disable USB debugging auth timeout (keep authorized)
    tv_put_setting global adb_enabled 1
    tv_put_setting secure usb_debugging_enabled 1

    # 4. Prevent ADB from turning off (some OEMs)
    tv_sh "settings put global always_on_display_constants 0" 2>/dev/null || true

    # 5. Create reconnect watchdog (runs every 30s via init.d equivalent)
    local watchdog_script="
#!/system/bin/sh
# ADB Reconnect Watchdog
while true; do
    if ! netstat -tlnp 2>/dev/null | grep -q :5555; then
        setprop service.adb.tcp.port 5555
        stop adbd && start adbd
        log -t TV-JAILBREAK \"ADB restarted\"
    fi
    sleep 30
done
"
    tv_write_file "/data/local/tmp/adb_watchdog.sh" "$watchdog_script"
    tv_chmod_x "/data/local/tmp/adb_watchdog.sh"

    # 6. Add to startup
    local startup_addition="
# ADB Watchdog
nohup /data/local/tmp/adb_watchdog.sh > /data/local/tmp/adb_watchdog.log 2>&1 &
"
    local current_startup
    current_startup=$(tv_sh "cat /data/local/tmp/startup.sh 2>/dev/null" || echo "")
    if ! echo "$current_startup" | grep -q "adb_watchdog"; then
        tv_write_file "/data/local/tmp/startup.sh" "${current_startup}${startup_addition}"
        tv_chmod_x "/data/local/tmp/startup.sh"
    fi

    print_success "ADB persistence configured"
    return 0
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ensure_adb_persistence "$@"
fi