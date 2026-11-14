<script setup>
import { ref, reactive } from 'vue';

const settings = reactive({
    tvIp: '192.168.1.100',
    tvPort: 5555,
    launcherPkg: 'com.spocky.projengmenu',
    launcherActivity: 'com.spocky.projengmenu/.MainActivity',
    stockLauncher: 'ir.huma.android.launcher',
    pointerSpeed: -5,
    keymapperEnabled: true,
    bluetoothFixEnabled: true,
    accessibilityEnabled: true,
    adbPersistenceEnabled: true,
    autoReconnect: true,
    reconnectInterval: 30,
    logLevel: 'info'
});

const launcherOptions = [
    { value: 'com.spocky.projengmenu', label: 'Projectivy Launcher' },
    { value: 'com.flauncher', label: 'FLauncher' },
    { value: 'com.kmlauncher', label: 'KML Launcher' },
    { value: 'tv.haolauncher', label: 'Hao Launcher' }
];

function saveSettings() {
    localStorage.setItem('tv-jailbreak-settings', JSON.stringify(settings));
    alert('تنظیمات ذخیره شد ✅');
}

function loadSettings() {
    const saved = localStorage.getItem('tv-jailbreak-settings');
    if (saved) {
        Object.assign(settings, JSON.parse(saved));
    }
}

function resetSettings() {
    if (confirm('آیا مطمئن هستید؟ تمام تنظیمات به پیش‌فرض برمی‌گردند.')) {
        localStorage.removeItem('tv-jailbreak-settings');
        location.reload();
    }
}

// Load on mount
loadSettings();
</script>

<template>
    <div class="grid grid-2">
        <!-- Connection Settings -->
        <div class="card">
            <div class="card-header">
                <div class="card-title">
                    <span class="card-icon primary">🔌</span>
                    تنظیمات اتصال
                </div>
            </div>
            <div class="form-group">
                <label class="form-label">آدرس IP تی‌وی</label>
                <input class="form-input" v-model="settings.tvIp" placeholder="192.168.1.100" />
            </div>
            <div class="form-group">
                <label class="form-label">پورت ADB</label>
                <input class="form-input" type="number" v-model.number="settings.tvPort" placeholder="5555" />
            </div>
            <div class="form-group">
                <label class="form-label">باز اتصال خودکار</label>
                <label class="toggle">
                    <input type="checkbox" v-model="settings.autoReconnect" />
                    <span class="toggle-slider"></span>
                </label>
            </div>
            <div class="form-group">
                <label class="form-label">فاصله باز اتصال (ثانیه)</label>
                <input class="form-input" type="number" v-model.number="settings.reconnectInterval" />
            </div>
        </div>

        <!-- Launcher Settings -->
        <div class="card">
            <div class="card-header">
                <div class="card-title">
                    <span class="card-icon success">🏠</span>
                    تنظیمات لانچر
                </div>
            </div>
            <div class="form-group">
                <label class="form-label">پکیج لانچر دلخواه</label>
                <select class="form-input form-select" v-model="settings.launcherPkg">
                    <option v-for="opt in launcherOptions" :key="opt.value" :value="opt.value">{{ opt.label }}</option>
                </select>
            </div>
            <div class="form-group">
                <label class="form-label">اکتیویتی لانچر</label>
                <input class="form-input" v-model="settings.launcherActivity" />
            </div>
            <div class="form-group">
                <label class="form-label">پکیج لانچر استوک (برای غیرفعال کردن)</label>
                <input class="form-input" v-model="settings.stockLauncher" />
            </div>
        </div>

        <!-- Pointer Settings -->
        <div class="card">
            <div class="card-header">
                <div class="card-title">
                    <span class="card-icon warning">🖱️</span>
                    سرعت پوینتر
                </div>
            </div>
            <div class="form-group">
                <label class="form-label">سرعت (از -7 تا +7)</label>
                <input class="form-input" type="range" min="-7" max="7" v-model.number="settings.pointerSpeed" style="padding: 0;" />
                <div style="display: flex; justify-content: space-between; margin-top: 8px; font-size: 12px; color: var(--fg-muted);">
                    <span>کند (-7)</span>
                    <span style="color: var(--accent); font-weight: 600;">{{ settings.pointerSpeed }}</span>
                    <span>سریع (+7)</span>
                </div>
            </div>
        </div>

        <!-- Module Toggles -->
        <div class="card">
            <div class="card-header">
                <div class="card-title">
                    <span class="card-icon info">⚙️</span>
                    ماژول‌های فعال
                </div>
            </div>
            <div style="display: flex; flex-direction: column; gap: 12px;">
                <label v-for="mod in modules" :key="mod.id" style="display: flex; align-items: center; justify-content: space-between; cursor: pointer;">
                    <div>
                        <div style="font-weight: 500;">{{ mod.icon }} {{ mod.name }}</div>
                        <div style="font-size: 12px; color: var(--fg-muted);">{{ mod.desc }}</div>
                    </div>
                    <label class="toggle">
                        <input type="checkbox" :value="settings[mod.key]" @change="settings[mod.key] = $event.target.checked" />
                        <span class="toggle-slider"></span>
                    </label>
                </label>
            </div>
        </div>

        <!-- Advanced Settings -->
        <div class="card">
            <div class="card-header">
                <div class="card-title">
                    <span class="card-icon danger">🔧</span>
                    تنظیمات پیشرفته
                </div>
            </div>
            <div class="form-group">
                <label class="form-label">سطح لاگ</label>
                <select class="form-input form-select" v-model="settings.logLevel">
                    <option value="debug">Debug</option>
                    <option value="info">Info</option>
                    <option value="warn">Warning</option>
                    <option value="error">Error</option>
                </select>
            </div>
            <div class="form-group">
                <label class="form-label">پوشه اسکریپت‌ها</label>
                <input class="form-input" value="/home/karim/TV-jailbreak/scripts" readonly />
            </div>
        </div>

        <!-- Actions -->
        <div class="card">
            <div class="card-header">
                <div class="card-title">
                    <span class="card-icon primary">💾</span>
                    عملیات
                </div>
            </div>
            <div style="display: flex; flex-direction: column; gap: 12px;">
                <button class="btn btn-primary" @click="saveSettings">💾 ذخیره تنظیمات</button>
                <button class="btn btn-secondary" @click="loadSettings">🔄 بارگذاری از حافظه</button>
                <button class="btn btn-danger" @click="resetSettings">🗑 بازنشانی به پیش‌فرض</button>
            </div>
            <div style="margin-top: 16px; padding-top: 16px; border-top: 1px solid var(--border); font-size: 12px; color: var(--fg-muted);">
                <p>تنظیمات در localStorage مرورگر ذخیره می‌شوند.</p>
                <p>برای استفاده در اسکریپت شل، متغیرهای محیطی ست کنید.</p>
            </div>
        </div>
    </div>
</template>

<script>
const modules = [
    { id: 'launcher', key: 'keymapperEnabled', name: 'تعویض لانچر', desc: 'نصب و تنظیم لانچر به عنوان پیش‌فرض', icon: '🏠' },
    { id: 'bluetooth', key: 'bluetoothFixEnabled', name: 'استحکام بلوتوث', desc: 'اتصال خودکار کنترل بلوتوث', icon: '📡' },
    { id: 'keymapper', key: 'keymapperEnabled', name: 'کی‌مپر دِمن', desc: 'مپ دکمه‌های ریموت به اکشن‌ها', icon: '🎮' },
    { id: 'accessibility', key: 'accessibilityEnabled', name: 'اکسسبلیتی', desc: 'فعال‌سازی سرویس دسترسی', icon: '♿' },
    { id: 'adb', key: 'adbPersistenceEnabled', name: 'پایداری ADB', desc: 'حفظ پورت ۵۵۵۵ باز', icon: '🔌' },
    { id: 'pointer', key: 'pointerSpeed', name: 'سرعت پوینتر', desc: 'تنظیم سرعت موس/کنترل', icon: '🖱️' }
];
</script>