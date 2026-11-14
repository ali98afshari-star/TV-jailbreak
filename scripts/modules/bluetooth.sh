#!/bin/bash
# Bluetooth Stabilizer Module
# Fixes auto-connect for Bluetooth remotes (RSS-18KB, generic HID)

source "${LIB_DIR}/common.sh"

bluetooth_fix() {
    print_step "BT" "Applying Bluetooth fixes..."

    # 1. Enable BLE scan always (key for auto-reconnect)
    print_step "BT" "Enabling ble_scan_always_enabled..."
    tv_put_setting global ble_scan_always_enabled 1
    local val
    val=$(tv_get_setting global ble_scan_always_enabled)
    [[ "$val" == "1" ]] && print_success "ble_scan_always_enabled = 1" || print_warning "Could not verify"

    # 2. Enable Bluetooth if off
    local bt_state
    bt_state=$(tv_get_setting global bluetooth_on)
    if [[ "$bt_state" != "1" ]]; then
        print_step "BT" "Turning Bluetooth ON..."
        tv_put_setting global bluetooth_on 1
        tv_broadcast "android.bluetooth.adapter.action.REQUEST_ENABLE"
    fi

    # 3. Check bonded devices (RSS-18KB = BC:6D:05:5F:FC:B0 pattern)
    print_step "BT" "Checking bonded devices..."
    tv_sh "dumpsys bluetooth_manager | grep -i 'bonded\|RSS\|BC:6D'" | head -10

    # 4. Set HID priority for known remotes
    print_step "BT" "Setting HID priority..."
    tv_sh "settings put secure bluetooth_hid_priority 1" 2>/dev/null

    # 5. Disable battery optimization for Bluetooth
    tv_sh "cmd appops set com.android.bluetooth RUN_IN_BACKGROUND allow" 2>/dev/null
    tv_sh "cmd appops set com.android.bluetooth RUN_ANY_IN_BACKGROUND allow" 2>/dev/null

    print_success "Bluetooth fixes applied"
    return 0
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    bluetooth_fix "$@"
fi