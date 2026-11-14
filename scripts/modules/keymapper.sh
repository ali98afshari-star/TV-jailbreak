#!/bin/bash
# Keymapper Daemon Module
# Maps remote scancodes to Android actions (HDMI, Recent, Voice, Live TV)

source "${LIB_DIR}/common.sh"

# Scancode mappings (decimal)
declare -A KEY_ACTIONS=(
    [178]="am start -a android.intent.action.INPUT_SOURCE_ACTIVITY"  # HDMI/Source
    [187]="input keyevent 187"                                        # Recent Apps
    [582]="am start -n ir.huma.voiceassistant/.MainActivity"          # Voice Assistant
    [361]="am start -n com.kgzn.tvplayer/.activity.RootActivity"      # Live TV
)

install_keymapper() {
    print_step "KEYMAP" "Installing keymapper daemon..."

    # 1. Find input event for Bluetooth remote
    local event_dev
    event_dev=$(tv_sh "ls -1 /dev/input/event* 2>/dev/null | while read dev; do
        name=\$(getevent -i \"\$dev\" 2>/dev/null | grep -i 'name.*RSS\|name.*Bluetooth' | head -1)
        [[ -n \"\$name\" ]] && echo \"\$dev\" && break
    done" 2>/dev/null | head -1)

    if [[ -z "$event_dev" ]]; then
        # Fallback to event4 (common for Bluetooth on MTK)
        event_dev="/dev/input/event4"
        print_warning "Remote event not auto-detected, using $event_dev"
    else
        print_success "Remote detected at $event_dev"
    fi

    # 2. Create keymapper daemon script
    local daemon_script="
#!/system/bin/sh
# TV-jailbreak Keymapper Daemon
# Auto-generated - do not edit manually

EVENT_DEV=\"$event_dev\"
LOG_FILE=\"/data/local/tmp/keymapper.log\"
PID_FILE=\"/data/local/tmp/keymapper.pid\"

# Kill existing
[[ -f \"\$PID_FILE\" ]] && kill \$(cat \"\$PID_FILE\" 2>/dev/null) 2>/dev/null || true

# Scancode -> Action mapping
declare -A ACTIONS=(
    [178]=\"am start -a android.intent.action.INPUT_SOURCE_ACTIVITY\"
    [187]=\"input keyevent 187\"
    [582]=\"am start -n ir.huma.voiceassistant/.MainActivity\"
    [361]=\"am start -n com.kgzn.tvplayer/.activity.RootActivity\"
)

echo \"[\$(date)] Keymapper starting on \$EVENT_DEV\" >> \"\$LOG_FILE\"

nohup sh -c '
getevent -l \"\$EVENT_DEV\" 2>/dev/null | while read line; do
    case \"\$line\" in
        *KEY_*DOWN*)
            # Extract hex scancode (e.g., 0x0178)
            scancode=\$(echo \"\$line\" | grep -o \"0x[0-9a-fA-F]*\" | head -1)
            [[ -z \"\$scancode\" ]] && continue
            # Convert hex to decimal
            dec=\$((scancode))
            action=\"\${ACTIONS[\$dec]:-}\"
            [[ -n \"\$action\" ]] && {
                echo \"[\$(date)] Scancode \$dec -> \$action\" >> \"\$LOG_FILE\"
                eval \"\$action\"
            }
            ;;
    esac
done
' >> \"\$LOG_FILE\" 2>&1 &

echo \$! > \"\$PID_FILE\"
echo \"[\$(date)] Keymapper started with PID \$!\" >> \"\$LOG_FILE\"
"

    # 3. Push to TV
    tv_write_file "/data/local/tmp/keymapper_daemon.sh" "$daemon_script"
    tv_chmod_x "/data/local/tmp/keymapper_daemon.sh"

    # 4. Create startup script
    local startup_script="
#!/system/bin/sh
# TV-jailbreak Boot Startup
LOG_FILE=\"/data/local/tmp/startup.log\"
echo \"[\$(date)] TV-jailbreak startup...\" >> \"\$LOG_FILE\"
/data/local/tmp/keymapper_daemon.sh >> \"\$LOG_FILE\" 2>&1
echo \"[\$(date)] Startup complete\" >> \"\$LOG_FILE\"
"
    tv_write_file "/data/local/tmp/startup.sh" "$startup_script"
    tv_chmod_x "/data/local/tmp/startup.sh"

    # 5. Execute now
    tv_sh "/data/local/tmp/keymapper_daemon.sh"

    # 6. Verify
    sleep 2
    if tv_sh "ps | grep -q getevent"; then
        print_success "Keymapper daemon running"
    else
        print_warning "Keymapper may not have started (check logs)"
    fi

    return 0
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_keymapper "$@"
fi