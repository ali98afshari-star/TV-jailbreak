#!/bin/bash
# Accessibility Auto-Grant Module
# Enables accessibility services for custom launchers (Projectivy, etc.)

source "${LIB_DIR}/common.sh"

# Common accessibility service patterns
declare -A LAUNCHER_A11Y_SERVICES=(
    ["com.spocky.projengmenu"]="com.spocky.projengmenu/com.spocky.projengmenu.accessibility.ProjectivyAccessibilityService"
    ["com.flauncher"]="com.flauncher/com.flauncher.accessibility.FLauncherAccessibilityService"
    ["com.kmlauncher"]="com.kmlauncher/com.kmlauncher.accessibility.KMLAccessibilityService"
    ["tv.haolauncher"]="tv.haolauncher/tv.haolauncher.accessibility.HaoAccessibilityService"
)

enable_accessibility() {
    print_step "A11Y" "Enabling accessibility for ${LAUNCHER_PKG}..."

    # 1. Get service name for this launcher
    local service="${LAUNCHER_A11Y_SERVICES[$LAUNCHER_PKG]:-}"
    if [[ -z "$service" ]]; then
        # Try to detect from package
        service=$(tv_sh "dumpsys package $LAUNCHER_PKG | grep -i 'accessibility.*Service' | head -1 | awk '{print \$1}'" 2>/dev/null)
    fi

    if [[ -z "$service" ]]; then
        print_warning "Could not detect accessibility service for $LAUNCHER_PKG"
        print_info "Please enable manually: Settings → Accessibility → Services"
        return 0
    fi

    print_step "A11Y" "Found service: $service"

    # 2. Enable accessibility globally
    tv_put_setting secure accessibility_enabled 1

    # 3. Add service to enabled list
    tv_enable_accessibility "$service"

    # 4. Grant required permissions
    tv_grant_permission "$LAUNCHER_PKG" "android.permission.BIND_ACCESSIBILITY_SERVICE"

    # 5. Verify
    local enabled
    enabled=$(tv_sh "settings get secure enabled_accessibility_services" 2>/dev/null)
    if echo "$enabled" | grep -q "$service"; then
        print_success "Accessibility service enabled: $service"
    else
        print_warning "Service may need manual enable in Settings"
    fi

    return 0
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    enable_accessibility "$@"
fi