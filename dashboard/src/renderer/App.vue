<script setup>
import { onMounted, ref } from 'vue';
import { useRouter } from 'vue-router';
import DeviceCard from './components/DeviceCard.vue';
import ModuleToggle from './components/ModuleToggle.vue';
import LogViewer from './components/LogViewer.vue';
import SettingsPanel from './components/SettingsPanel.vue';

const router = useRouter();
const activeTab = ref('dashboard');
const devices = ref([]);
const logs = ref([]);
const isRunning = ref(false);
const progress = ref(0);

const tabs = [
    { id: 'dashboard', label: 'داشبورد', icon: '📊' },
    { id: 'devices', label: 'دستگاه‌ها', icon: '📺' },
    { id: 'modules', label: 'ماژول‌ها', icon: '⚙️' },
    { id: 'logs', label: 'لاگ‌ها', icon: '📋' },
    { id: 'settings', label: 'تنظیمات', icon: '🔧' }
];

async function runCustomizer() {
    if (isRunning.value) return;
    isRunning.value = true;
    progress.value = 0;
    logs.value = [];

    try {
        const scriptPath = '/home/karim/TV-jailbreak/scripts/tv-customizer.sh';
        const args = [
            '-i', '192.168.1.100',
            '-p', '5555',
            '-l', 'com.spocky.projengmenu'
        ];

        const result = await window.api.script.run(scriptPath, args, {
            TV_IP: '192.168.1.100',
            TV_PORT: '5555',
            LAUNCHER_PKG: 'com.spocky.projengmenu'
        });

        logs.value.push({ type: result.code === 0 ? 'success' : 'error', message: result.output });
        progress.value = 100;
    } catch (err) {
        logs.value.push({ type: 'error', message: err.message });
    } finally {
        isRunning.value = false;
    }
}

async function testAdb() {
    const result = await window.api.adb.run(['devices']);
    logs.value.unshift({ type: 'info', message: `ADB: ${result.output}` });
}

onMounted(() => {
    // Simulate device detection
    devices.value = [
        { ip: '192.168.1.100', port: 5555, name: 'Snowa TV', status: 'connected', model: 'KGZN MTK' }
    ];
});
</script>

<template>
    <div class="app-layout">
        <!-- Header -->
        <header class="app-header">
            <div class="header-brand">
                <div class="header-logo">TV</div>
                <div>
                    <div class="header-title">TV-jailbreak</div>
                    <div class="header-subtitle">Universal Android TV Customizer</div>
                </div>
            </div>
            <div class="header-actions">
                <button class="btn btn-secondary btn-sm" @click="testAdb">
                    🔍 تست ADB
                </button>
                <button class="btn btn-primary" @click="runCustomizer" :disabled="isRunning">
                    <span v-if="isRunning">⏳ در حال اجرا...</span>
                    <span v-else>🚀 اجرای کامل</span>
                </button>
            </div>
        </header>

        <!-- Progress Bar -->
        <div v-if="isRunning || progress > 0" style="position: fixed; top: 0; left: 0; right: 0; z-index: 100;">
            <div class="progress" style="height: 3px;">
                <div class="progress-bar" :style="{ width: progress + '%' }"></div>
            </div>
        </div>

        <!-- Main -->
        <main class="app-main">
            <!-- Tab Navigation -->
            <nav class="grid grid-5" style="margin-bottom: 24px; grid-auto-flow: column; grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));">
                <button
                    v-for="tab in tabs"
                    :key="tab.id"
                    class="btn btn-secondary"
                    :class="{ 'btn-primary': activeTab === tab.id }"
                    @click="activeTab = tab.id"
                    style="padding: 12px; justify-content: center;"
                >
                    <span style="font-size: 18px;">{{ tab.icon }}</span>
                    <span style="margin-right: 8px;">{{ tab.label }}</span>
                </button>
            </nav>

            <!-- Dashboard Tab -->
            <section v-if="activeTab === 'dashboard'" class="animate-fade-in">
                <div class="grid grid-3" style="margin-bottom: 24px;">
                    <div class="card">
                        <div class="card-header">
                            <div class="card-title">
                                <span class="card-icon primary">📺</span>
                                دستگاه‌های متصل
                            </div>
                            <span class="badge badge-success">{{ devices.filter(d => d.status === 'connected').length }}</span>
                        </div>
                        <div v-for="device in devices" :key="device.ip" class="device-card" :class="{ connected: device.status === 'connected' }">
                            <div class="device-header">
                                <div class="device-info">
                                    <h3>{{ device.name }}</h3>
                                    <p>{{ device.ip }}:{{ device.port }} • {{ device.model }}</p>
                                </div>
                                <span class="badge" :class="device.status === 'connected' ? 'badge-success' : 'badge-danger'">
                                    {{ device.status === 'connected' ? 'متصل' : 'قطع' }}
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <div class="card-title">
                                <span class="card-icon info">⚙️</span>
                                ماژول‌های فعال
                            </div>
                        </div>
                        <div style="display: flex; flex-direction: column; gap: 8px;">
                            <div v-for="mod in modules" :key="mod.id" style="display: flex; justify-content: space-between; align-items: center; padding: 8px 0; border-bottom: 1px solid var(--border);">
                                <span>{{ mod.icon }} {{ mod.name }}</span>
                                <span class="badge badge-success">فعال</span>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <div class="card-title">
                                <span class="card-icon warning">📋</span>
                                آخرین لاگ‌ها
                            </div>
                        </div>
                        <div class="log-viewer" style="max-height: 200px;">
                            <div v-if="logs.length === 0" class="log-line">
                                <span class="log-time">[--:--:--]</span> هیچ لاگی وجود ندارد
                            </div>
                            <div v-for="(log, i) in logs.slice(-5).reverse()" :key="i" class="log-line">
                                <span class="log-time">[{{ new Date().toLocaleTimeString('fa-IR') }}]</span>
                                <span :class="'log-' + log.type">{{ log.message }}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="grid grid-2">
                    <div class="card">
                        <div class="card-header">
                            <div class="card-title">
                                <span class="card-icon success">✅</span>
                                عملیات سریع
                            </div>
                        </div>
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 12px;">
                            <button class="btn btn-secondary" @click="activeTab = 'modules'">🔧 مدیریت ماژول‌ها</button>
                            <button class="btn btn-secondary" @click="activeTab = 'devices'">📺 مدیریت دستگاه‌ها</button>
                            <button class="btn btn-secondary" @click="activeTab = 'settings'">⚙️ تنظیمات پیشرفته</button>
                            <button class="btn btn-primary" @click="runCustomizer" :disabled="isRunning">🚀 اجرای کامل</button>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <div class="card-title">
                                <span class="card-icon danger">⚠️</span>
                                هشدارها و نکات
                            </div>
                        </div>
                        <ul style="display: flex; flex-direction: column; gap: 8px; color: var(--fg-secondary); font-size: 13px; padding-right: 16px;">
                            <li>• برای اجرای اسکریپت، دستگاه باید روت باشد</li>
                            <li>• پورت ۵۵۵۵ باید در تنظیمات Developer Options باز باشد</li>
                            <li>• لانچر Projectivy باید از قبل نصب شده باشد</li>
                            <li>• کنترل بلوتوث باید یک بار دستی پیربندی شده باشد</li>
                            <li>• تغییرات پس از ریبوت باقی می‌مانند</li>
                        </ul>
                    </div>
                </div>
            </section>

            <!-- Devices Tab -->
            <section v-else-if="activeTab === 'devices'" class="animate-fade-in">
                <DeviceCard :devices="devices" @add-device="addDevice" @remove-device="removeDevice" @connect="connectDevice" />
            </section>

            <!-- Modules Tab -->
            <section v-else-if="activeTab === 'modules'" class="animate-fade-in">
                <div class="grid grid-2">
                    <ModuleToggle
                        v-for="mod in modules"
                        :key="mod.id"
                        :module="mod"
                    />
                </div>
            </section>

            <!-- Logs Tab -->
            <section v-else-if="activeTab === 'logs'" class="animate-fade-in">
                <LogViewer :logs="logs" @clear="logs = []" />
            </section>

            <!-- Settings Tab -->
            <section v-else-if="activeTab === 'settings'" class="animate-fade-in">
                <SettingsPanel />
            </section>
        </main>

        <!-- Footer -->
        <footer class="app-footer">
            <div>TV-jailbreak v1.0.0 • Universal Android TV Customizer</div>
            <div class="footer-links">
                <a href="https://github.com/ali98afshari-star/TV-jailbreak" target="_blank">GitHub</a>
                <a href="https://github.com/ali98afshari-star/TV-jailbreak/issues" target="_blank">Issues</a>
                <a href="https://github.com/ali98afshari-star/TV-jailbreak/releases" target="_blank">Releases</a>
            </div>
        </footer>
    </div>
</template>

<script>
const modules = [
    { id: 'launcher', name: 'تعویض لانچر', desc: 'نصب و تنظیم لانچر Projectivy به عنوان پیش‌فرض', icon: '🏠', enabled: true },
    { id: 'bluetooth', name: 'استحکام بلوتوث', desc: 'اتصال خودکار کنترل RSS-18KB پس از ریبوت', icon: '📡', enabled: true },
    { id: 'keymapper', name: 'کی‌مپر دِمن', desc: 'مپ دکمه‌های ریموت به اکشن‌ها (HDMI، Recent، Voice، Live TV)', icon: '🎮', enabled: true },
    { id: 'accessibility', name: 'اکسسبلیتی', desc: 'فعال‌سازی خودکار سرویس دسترسی برای لانچر', icon: '♿', enabled: true },
    { id: 'adb', name: 'پایداری ADB', desc: 'حفظ پورت ۵۵۵۵ باز و ریستارت خودکار adbd', icon: '🔌', enabled: true },
    { id: 'pointer', name: 'سرعت پوینتر', desc: 'تنظیم سرعت موس/کنترل روی -5', icon: '🖱️', enabled: true }
];
</script>

<style scoped>
/* Scoped styles if needed */
</style>