<script setup>
import { onMounted, ref } from 'vue';
import { useRouter } from 'vue-router';
import { Capacitor } from '@capacitor/core';

const router = useRouter();
const activeTab = ref('dashboard');
const devices = ref([]);
const logs = ref([]);
const isRunning = ref(false);
const isNative = Capacitor.isNativePlatform();

const tabs = [
    { id: 'dashboard', label: 'داشبورد', icon: '📊' },
    { id: 'devices', label: 'دستگاه‌ها', icon: '📺' },
    { id: 'modules', label: 'ماژول‌ها', icon: '⚙️' },
    { id: 'logs', label: 'لاگ‌ها', icon: '📋' },
    { id: 'settings', label: 'تنظیمات', icon: '🔧' }
];

const modules = [
    { id: 'launcher', name: 'تعویض لانچر', desc: 'نصب و تنظیم لانچر به عنوان پیش‌فرض', icon: '🏠', enabled: true },
    { id: 'bluetooth', name: 'استحکام بلوتوث', desc: 'اتصال خودکار کنترل بلوتوث', icon: '📡', enabled: true },
    { id: 'keymapper', name: 'کی‌مپر دِمن', desc: 'مپ دکمه‌های ریموت به اکشن‌ها', icon: '🎮', enabled: true },
    { id: 'accessibility', name: 'اکسسبلیتی', desc: 'فعال‌سازی سرویس دسترسی', icon: '♿', enabled: true },
    { id: 'adb', name: 'پایداری ADB', desc: 'حفظ پورت ۵۵۵۵ باز', icon: '🔌', enabled: true },
    { id: 'pointer', name: 'سرعت پوینتر', desc: 'تنظیم سرعت موس/کنترل روی -5', icon: '🖱️', enabled: true }
];

async function runQuickAction(action) {
    if (isRunning.value) return;
    isRunning.value = true;
    logs.value.unshift({ type: 'info', message: `شروع: ${action}...` });

    // Simulate action
    await new Promise(r => setTimeout(r, 1500));
    
    logs.value.unshift({ type: 'success', message: `انجام شد: ${action} ✅` });
    isRunning.value = false;
}

onMounted(() => {
    devices.value = [
        { ip: '192.168.1.100', port: 5555, name: 'Snowa TV', status: 'connected', model: 'KGZN MTK', root: true }
    ];
});
</script>

<template>
    <div class="app-layout">
        <!-- Header -->
        <header class="app-header">
            <div class="header-brand">
                <div class="header-logo">TV</div>
                <div class="header-title">TV-jailbreak</div>
            </div>
            <span v-if="isNative" class="badge badge-success" style="font-size: 10px;">📱 Native</span>
        </header>

        <!-- Main -->
        <main class="app-main">
            <!-- Tab Navigation -->
            <nav class="tab-nav" role="tablist">
                <button
                    v-for="tab in tabs"
                    :key="tab.id"
                    class="tab-btn"
                    :class="{ active: activeTab === tab.id }"
                    @click="activeTab = tab.id"
                    role="tab"
                    :aria-selected="activeTab === tab.id"
                >
                    <span>{{ tab.icon }}</span>
                    <span>{{ tab.label }}</span>
                </button>
            </nav>

            <!-- Dashboard Tab -->
            <section v-if="activeTab === 'dashboard'" class="animate-fade-in">
                <div class="grid grid-2" style="margin-bottom: 16px;">
                    <div class="card">
                        <div class="card-header">
                            <div class="card-title">
                                <span class="card-icon primary">📺</span>
                                دستگاه‌ها
                            </div>
                            <span class="badge badge-success">{{ devices.filter(d => d.status === 'connected').length }}</span>
                        </div>
                        <div v-for="device in devices" :key="device.ip" class="device-card" :class="{ connected: device.status === 'connected' }">
                            <div class="device-header">
                                <div class="device-info">
                                    <h3>{{ device.name }}</h3>
                                    <p>{{ device.ip }}:{{ device.port }}</p>
                                </div>
                                <span class="badge badge-success">متصل</span>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <div class="card-title">
                                <span class="card-icon info">⚡</span>
                                عملیات سریع
                            </div>
                        </div>
                        <div style="display: flex; flex-direction: column; gap: 8px;">
                            <button class="btn btn-primary btn-block" @click="runQuickAction('اتصال ADB')" :disabled="isRunning">🔌 اتصال ADB</button>
                            <button class="btn btn-secondary btn-block" @click="runQuickAction('نصب لانچر')" :disabled="isRunning">🏠 نصب لانچر</button>
                            <button class="btn btn-secondary btn-block" @click="runQuickAction('تنظیم بلوتوث')" :disabled="isRunning">📡 تنظیم بلوتوث</button>
                            <button class="btn btn-secondary btn-block" @click="runQuickAction('فعال‌سازی دسترسی')" :disabled="isRunning">♿ فعال‌سازی دسترسی</button>
                            <button class="btn btn-primary btn-block" @click="runQuickAction('اجرای کامل')" :disabled="isRunning">🚀 اجرای کامل</button>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <div class="card-title">
                            <span class="card-icon warning">📋</span>
                            لاگ‌های اخیر
                        </div>
                    </div>
                    <div style="background: var(--input-bg); border-radius: var(--radius-sm); padding: 12px; max-height: 200px; overflow-y: auto; font-family: monospace; font-size: 11px; line-height: 1.6;">
                        <div v-if="logs.length === 0" style="color: var(--fg-muted); text-align: center; padding: 20px;">هیچ لاگی وجود ندارد</div>
                        <div v-for="(log, i) in logs.slice(0, 10)" :key="i" style="margin: 4px 0; display: flex; gap: 8px;">
                            <span :class="{ 'log-success': log.type === 'success', 'log-error': log.type === 'error', 'log-warning': log.type === 'warning', 'log-info': log.type === 'info' }">
                                {{ log.message }}
                            </span>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Devices Tab -->
            <section v-else-if="activeTab === 'devices'" class="animate-fade-in">
                <div class="card">
                    <div class="card-header">
                        <div class="card-title">
                            <span class="card-icon primary">📺</span>
                            دستگاه‌های مدیریت شده
                        </div>
                    </div>
                    <div v-if="devices.length === 0" style="text-align: center; padding: 40px; color: var(--fg-muted);">
                        <div style="font-size: 48px; margin-bottom: 16px;">📺</div>
                        <p>هیچ دستگاهی اضافه نشده</p>
                    </div>
                    <div v-else class="grid grid-2">
                        <div class="device-card" v-for="device in devices" :key="device.ip" :class="{ connected: device.status === 'connected' }">
                            <div class="device-header">
                                <div class="device-info">
                                    <h3>{{ device.name }}</h3>
                                    <p>{{ device.ip }}:{{ device.port }} • {{ device.model }}</p>
                                </div>
                                <span class="badge badge-success">متصل</span>
                            </div>
                            <div class="device-actions">
                                <button class="btn btn-primary btn-sm" @click="runQuickAction('اتصال مجدد')">🔄 اتصال مجدد</button>
                                <button class="btn btn-secondary btn-sm" @click="runQuickAction('تست روت')">🔐 تست روت</button>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Modules Tab -->
            <section v-else-if="activeTab === 'modules'" class="animate-fade-in">
                <div class="grid grid-2">
                    <div class="module-card" v-for="mod in modules" :key="mod.id">
                        <div class="module-info">
                            <div class="module-name">{{ mod.icon }} {{ mod.name }}</div>
                            <div class="module-desc">{{ mod.desc }}</div>
                        </div>
                        <label class="toggle">
                            <input type="checkbox" :checked="mod.enabled" @change="mod.enabled = $event.target.checked" />
                            <span class="toggle-slider"></span>
                        </label>
                    </div>
                </div>
            </section>

            <!-- Logs Tab -->
            <section v-else-if="activeTab === 'logs'" class="animate-fade-in">
                <div class="card">
                    <div class="card-header">
                        <div class="card-title">
                            <span class="card-icon info">📋</span>
                            لاگ‌های کامل
                        </div>
                        <button class="btn btn-ghost btn-sm" @click="logs = []">🗑 پاک کردن</button>
                    </div>
                    <div style="background: var(--input-bg); border-radius: var(--radius-sm); padding: 12px; max-height: 400px; overflow-y: auto; font-family: monospace; font-size: 12px; line-height: 1.6;">
                        <div v-if="logs.length === 0" style="color: var(--fg-muted); text-align: center; padding: 20px;">هیچ لاگی وجود ندارد</div>
                        <div v-for="(log, i) in logs" :key="i" style="margin: 4px 0; display: flex; gap: 8px; padding: 4px 0; border-bottom: 1px solid var(--border);">
                            <span :class="{ 'log-success': log.type === 'success', 'log-error': log.type === 'error', 'log-warning': log.type === 'warning', 'log-info': log.type === 'info' }">
                                {{ log.message }}
                            </span>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Settings Tab -->
            <section v-else-if="activeTab === 'settings'" class="animate-fade-in">
                <div class="card">
                    <div class="card-header">
                        <div class="card-title">
                            <span class="card-icon primary">🔌</span>
                            تنظیمات اتصال
                        </div>
                    </div>
                    <div class="grid grid-2">
                        <div class="form-group">
                            <label class="form-label">آدرس IP</label>
                            <input class="form-input" v-model="deviceIp" placeholder="192.168.1.100" />
                        </div>
                        <div class="form-group">
                            <label class="form-label">پورت</label>
                            <input class="form-input" type="number" v-model.number="devicePort" placeholder="5555" />
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <div class="card-title">
                            <span class="card-icon success">🏠</span>
                            لانچر و ماژول‌ها
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">پکیج لانچر</label>
                        <select class="form-input form-select" v-model="launcherPkg">
                            <option value="com.spocky.projengmenu">Projectivy Launcher</option>
                            <option value="com.flauncher">FLauncher</option>
                            <option value="com.kmlauncher">KML Launcher</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">پکیج لانچر استوک</label>
                        <input class="form-input" v-model="stockLauncher" placeholder="ir.huma.android.launcher" />
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <div class="card-title">
                            <span class="card-icon warning">🖱️</span>
                            سرعت پوینتر
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">سرعت ({{ pointerSpeed }})</label>
                        <input class="form-input" type="range" min="-7" max="7" v-model.number="pointerSpeed" />
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <div class="card-title">
                            <span class="card-icon danger">ℹ️</span>
                            درباره برنامه
                        </div>
                    </div>
                    <div style="font-size: 12px; color: var(--fg-secondary); line-height: 1.8;">
                        <p><strong>TV-jailbreak v1.0.0</strong></p>
                        <p>Universal Android TV Customizer</p>
                        <p style="margin-top: 12px;">این برنامه برای کاستومایز کردن تلویزیون‌های اندرویدی (Snowa و برندهای مشابه) طراحی شده است.</p>
                        <p>ماژول‌ها:</p>
                        <ul style="padding-right: 16px; margin-top: 8px;">
                            <li>تعویض لانچر استوک با Projectivy/FLauncher</li>
                            <li>اتصال خودکار کنترل بلوتوث</li>
                            <li>مپ دکمه‌های ریموت</li>
                            <li>فعال‌سازی دسترسی (Accessibility)</li>
                            <li>پایداری ADB روی پورت ۵۵۵۵</li>
                            <li>تنظیم سرعت پوینتر</li>
                        </ul>
                    </div>
                </div>
            </section>
        </main>

        <!-- Footer -->
        <footer class="app-footer">
            <div>TV-jailbreak v1.0.0</div>
            <div class="footer-links">
                <a href="https://github.com/ali98afshari-star/TV-jailbreak" target="_blank">GitHub</a>
                <a href="https://github.com/ali98afshari-star/TV-jailbreak/releases" target="_blank">Releases</a>
            </div>
        </footer>
    </div>
</template>

<script>
import { ref } from 'vue';

const deviceIp = ref('192.168.1.100');
const devicePort = ref(5555);
const launcherPkg = ref('com.spocky.projengmenu');
const stockLauncher = ref('ir.huma.android.launcher');
const pointerSpeed = ref(-5);
</script>