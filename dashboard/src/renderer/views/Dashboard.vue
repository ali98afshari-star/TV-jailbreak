<script setup>
import DeviceCard from '@/components/DeviceCard.vue';
import ModuleToggle from '@/components/ModuleToggle.vue';
import LogViewer from '@/components/LogViewer.vue';
import { ref, onMounted } from 'vue';

const devices = ref([]);
const modules = ref([
    { id: 'launcher', name: 'Launcher', description: 'تعویض لانچر استوک', icon: '🏠' },
    { id: 'bluetooth', name: 'Bluetooth', description: 'اتصال کنترل بلوتوث', icon: '📡' },
    { id: 'keymapper', name: 'Keymapper', description: 'مپ دکمه‌های ریموت', icon: '🎮' },
    { id: 'accessibility', name: 'Accessibility', description: 'سرویس دسترسی', icon: '♿' },
    { id: 'adb', name: 'ADB Persistence', description: 'پایداری ADB', icon: '🔌' },
    { id: 'pointer', name: 'Pointer Speed', description: 'تنظیم سرعت پوینتر', icon: '🖱️' }
]);
const logs = ref([]);
const isConnected = ref(false);
const connectionStatus = ref('Disconnected');

async function loadDevices() {
    try {
        const result = await window.electronAPI.invoke('get-devices');
        if (result.success) {
            devices.value = result.data;
        }
    } catch (e) {
        console.error('Failed to load devices:', e);
    }
}

async function loadLogs() {
    try {
        const result = await window.electronAPI.invoke('get-logs');
        if (result.success) {
            logs.value = result.data;
        }
    } catch (e) {
        console.error('Failed to load logs:', e);
    }
}

onMounted(() => {
    loadDevices();
    loadLogs();
});
</script>

<template>
    <div class="dashboard-view">
        <div class="header">
            <h1>داشبورد TV-jailbreak</h1>
            <div class="connection-status" :class="{ connected: isConnected }">
                <span class="dot"></span>
                <span>{{ connectionStatus }}</span>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <span class="stat-icon">📺</span>
                <div>
                    <span class="stat-value">{{ devices.length }}</span>
                    <span class="stat-label">دستگاه متصل</span>
                </div>
            </div>
            <div class="stat-card">
                <span class="stat-icon">⚙️</span>
                <div>
                    <span class="stat-value">{{ modules.filter(m => m.enabled).length }}</span>
                    <span class="stat-label">ماژول فعال</span>
                </div>
            </div>
            <div class="stat-card">
                <span class="stat-icon">📋</span>
                <div>
                    <span class="stat-value">{{ logs.length }}</span>
                    <span class="stat-label">ورود لاگ</span>
                </div>
            </div>
        </div>

        <div class="section">
            <h2>دستگاه‌ها</h2>
            <div class="device-grid" v-if="devices.length > 0">
                <DeviceCard v-for="device in devices" :key="device.id" :device="device" />
            </div>
            <div class="empty-state" v-else>
                <p>هیچ دستگاهی یافت نشد. از تب "دستگاه‌ها" برای اسکن استفاده کنید.</p>
            </div>
        </div>

        <div class="section">
            <h2>ماژول‌های فعال</h2>
            <div class="module-grid">
                <ModuleToggle v-for="module in modules" :key="module.id" :module="module" />
            </div>
        </div>

        <div class="section">
            <h2>لاگ‌های اخیر</h2>
            <LogViewer :logs="logs.slice(-20)" />
        </div>
    </div>
</template>

<style scoped>
.dashboard-view {
    padding: 24px;
    max-width: 1200px;
    margin: 0 auto;
}

.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
    padding-bottom: 16px;
    border-bottom: 1px solid var(--border-color);
}

.header h1 {
    margin: 0;
    font-size: 1.75rem;
    font-weight: 600;
    color: var(--text-primary);
}

.connection-status {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 8px 16px;
    border-radius: 20px;
    background: var(--card-bg);
    font-size: 0.875rem;
}

.connection-status .dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: var(--text-muted);
}

.connection-status.connected .dot {
    background: var(--success-color);
    box-shadow: 0 0 8px var(--success-color);
}

.stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 16px;
    margin-bottom: 24px;
}

.stat-card {
    display: flex;
    align-items: center;
    gap: 16px;
    padding: 20px;
    background: var(--card-bg);
    border: 1px solid var(--border-color);
    border-radius: 12px;
    transition: transform 0.2s, box-shadow 0.2s;
}

.stat-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 24px rgba(0,0,0,0.15);
}

.stat-icon {
    font-size: 2rem;
}

.stat-value {
    display: block;
    font-size: 1.5rem;
    font-weight: 700;
    color: var(--text-primary);
}

.stat-label {
    display: block;
    font-size: 0.875rem;
    color: var(--text-muted);
}

.section {
    margin-bottom: 32px;
}

.section h2 {
    margin: 0 0 16px;
    font-size: 1.25rem;
    font-weight: 600;
    color: var(--text-primary);
}

.device-grid, .module-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 16px;
}

.empty-state {
    text-align: center;
    padding: 40px;
    color: var(--text-muted);
    background: var(--card-bg);
    border: 1px dashed var(--border-color);
    border-radius: 12px;
}
</style>