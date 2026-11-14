#!/usr/bin/env bash
# Module: pointer — Set pointer speed on Android TV
# Usage: source this file, then call tv_set_pointer_speed <speed>

tv_set_pointer_speed() {
    local speed="${1:--5}"
    log "تنظیم سرعت پوینتر روی: $speed"

    # Method 1: Settings put system pointer_speed
    tv_sh settings put system pointer_speed "$speed" 2>/dev/null && {
        log "✅ pointer_speed ست شد: $speed"
        return 0
    }

    # Method 2: Settings put secure pointer_speed
    tv_sh settings put secure pointer_speed "$speed" 2>/dev/null && {
        log "✅ secure pointer_speed ست شد: $speed"
        return 0
    }

    # Method 3: Via content provider (newer Android)
    tv_sh content insert --uri content://settings/system --bind name:s:pointer_speed --bind value:i:$speed 2>/dev/null && {
        log "✅ pointer_speed عبر content provider ست شد: $speed"
        return 0
    }

    log "⚠️ تنظیم pointer_speed با خطا مواجه شد" "WARN"
    return 1
}

# Persist pointer speed across reboots
tv_persist_pointer_speed() {
    local speed="${1:--5}"
    local script_path="/data/local/tmp/set_pointer_speed.sh"

    tv_write_file "$script_path" "#!/system/bin/sh
settings put system pointer_speed $speed
settings put secure pointer_speed $speed
" || return 1

    tv_chmod_x "$script_path"

    # Add to init.d or boot script
    local boot_script="/data/local/tmp/boot_pointer.sh"
    tv_write_file "$boot_script" "#!/system/bin/sh
sleep 10
sh $script_path
" || return 1

    tv_chmod_x "$boot_script"

    log "✅ اسکریپت 지속ی پوینتر ایجاد شد"
}

export -f tv_set_pointer_speed tv_persist_pointer_speed