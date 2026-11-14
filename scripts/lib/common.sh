#!/bin/bash
# Common library for TV-jailbreak scripts
# Shared functions, constants, and utilities

# Prevent multiple sourcing
[[ -n "${TV_JAILBREAK_COMMON_LOADED:-}" ]] && return 0
readonly TV_JAILBREAK_COMMON_LOADED=1

# ADB wrapper with retry logic
adb_cmd() {
    local max_retries=3
    local retry=0
    while [[ $retry -lt $max_retries ]]; do
        if adb "$@" 2>/dev/null; then
            return 0
        fi
        ((retry++))
        sleep 1
    done
    return 1
}

# Check if device is connected
adb_is_connected() {
    adb devices | grep -q "${TV_IP}:${TV_PORT}.*device"
}

# Connect to TV
adb_connect() {
    print_step "ADB" "Connecting to ${TV_IP}:${TV_PORT}..."
    adb disconnect "${TV_IP}:${TV_PORT}" 2>/dev/null || true
    sleep 1
    local output
    output=$(adb connect "${TV_IP}:${TV_PORT}" 2>&1)
    if echo "$output" | grep -q "connected\|already connected"; then
        print_success "ADB connected"
        return 0
    else
        print_error "ADB connection failed: $output"
        return 1
    fi
}

# Get root access
adb_root() {
    print_step "ROOT" "Requesting root..."
    adb root
    sleep 2
    adb connect "${TV_IP}:${TV_PORT}" >/dev/null 2>&1
    if adb shell id | grep -q "uid=0"; then
        print_success "Root access granted"
        return 0
    else
        print_warning "Root may not be available (some features limited)"
        return 0
    fi
}

# Execute shell command on TV
tv_sh() {
    adb shell "$@"
}

# Get setting value
tv_get_setting() {
    local namespace="$1"
    local key="$2"
    tv_sh "settings get $namespace $key" 2>/dev/null | tr -d '\r'
}

# Put setting value
tv_put_setting() {
    local namespace="$1"
    local key="$2"
    local value="$3"
    tv_sh "settings put $namespace $key $value" 2>/dev/null
}

# Check if package exists
tv_package_exists() {
    local pkg="$1"
    tv_sh "pm list packages | grep -q '^package:$pkg$'"
}

# Disable package
tv_disable_package() {
    local pkg="$1"
    tv_sh "pm disable-user --user 0 $pkg" 2>/dev/null
}

# Enable package
tv_enable_package() {
    local pkg="$1"
    tv_sh "pm enable --user 0 $pkg" 2>/dev/null
}

# Set default home launcher
tv_set_default_launcher() {
    local pkg="$1"
    tv_sh "cmd package set-home-activity $pkg" 2>/dev/null
}

# Start activity
tv_start_activity() {
    local component="$1"
    tv_sh "am start -n $component" 2>/dev/null
}

# Broadcast intent
tv_broadcast() {
    local action="$1"
    tv_sh "am broadcast -a $action" 2>/dev/null
}

# Grant permission
tv_grant_permission() {
    local pkg="$1"
    local perm="$2"
    tv_sh "pm grant $pkg $perm" 2>/dev/null
}

# Check accessibility service
tv_check_accessibility() {
    local service="$1"
    tv_sh "settings get secure enabled_accessibility_services" | grep -q "$service"
}

# Enable accessibility service
tv_enable_accessibility() {
    local service="$1"
    local current
    current=$(tv_sh "settings get secure enabled_accessibility_services" 2>/dev/null)
    if [[ -z "$current" || "$current" == "null" ]]; then
        tv_sh "settings put secure enabled_accessibility_services $service" 2>/dev/null
    elif ! echo "$current" | grep -q "$service"; then
        tv_sh "settings put secure enabled_accessibility_services ${current}:${service}" 2>/dev/null
    fi
    tv_sh "settings put secure accessibility_enabled 1" 2>/dev/null
}

# Write file to TV
tv_write_file() {
    local remote_path="$1"
    local content="$2"
    printf "%s" "$content" | adb shell "cat > $remote_path"
}

# Make file executable
tv_chmod_x() {
    local path="$1"
    tv_sh "chmod +x $path"
}

# Check if file exists on TV
tv_file_exists() {
    local path="$1"
    tv_sh "test -f $path && echo exists"
}

# Kill process by name
tv_kill_process() {
    local name="$1"
    tv_sh "pkill -f $name" 2>/dev/null || true
}

# Get TV properties
tv_get_prop() {
    local prop="$1"
    tv_sh "getprop $prop" 2>/dev/null | tr -d '\r'
}

# Set pointer speed
set_pointer_speed() {
    local speed="${POINTER_SPEED:--5}"
    tv_put_setting system pointer_speed "$speed"
    local actual
    actual=$(tv_get_setting system pointer_speed)
    [[ "$actual" == "$speed" ]] && print_success "Pointer speed set to $speed" || print_warning "Pointer speed may not have applied"
}

# Logging
log() {
    local level="$1"
    shift
    local msg="$*"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $msg" >> "${TV_JAILBREAK_LOG:-/dev/stdout}"
}

# Export all functions
export -f adb_cmd adb_is_connected adb_connect adb_root tv_sh
export -f tv_get_setting tv_put_setting tv_package_exists
export -f tv_disable_package tv_enable_package tv_set_default_launcher
export -f tv_start_activity tv_broadcast tv_grant_permission
export -f tv_check_accessibility tv_enable_accessibility
export -f tv_write_file tv_chmod_x tv_file_exists tv_kill_process
export -f tv_get_prop set_pointer_speed log