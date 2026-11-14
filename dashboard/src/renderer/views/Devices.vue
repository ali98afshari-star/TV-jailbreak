<script setup>
import DeviceCard from '@/components/DeviceCard.vue';
import { ref, onMounted } from 'vue';

const devices = ref([]);
const scanning = ref(false);
const scanProgress = ref(0);

async function scanDevices() {
    scanning.value = true;
    scanProgress.value = 0;
    try {
        const result = await window.electronAPI.invoke('scan-devices');
        if (result.success) {
            devices.value = result.data;
        }
    } catch (e) {
        console.error('Scan failed:', e);
    } finally {
        scanning.value = false;
    }
}

async function connectDevice(device) {
    try {
        const result = await window.electronAPI.invoke('connect-device', device.ip);
        if (result.success) {
            device.status = 'connected';
        }
    } catch (e) {
        console.error('Connect failed:', e);
    }
}

async function disconnectDevice(device) {
    try {
        const result = await window.electronAPI.invoke('disconnect-device', device.id);
        if (result.success) {
            device.status = 'disconnected';
        }
    } catch (e) {
        console.error('Disconnect failed:', e);
    }
}

onMounted(() => {
    scanDevices();
});
</script>

<template>
    <div class="devices-view">
        <div class="header">
            <h1>مدیریت دستگاه‌ها</h1>
            <button class="btn btn-primary" @click="scanDevices" :disabled="scanning">
                <span v-if="scanning" class="spinner"></span>
                {{ scanning ? 'در حال اسکن...' : 'اسکن شبکه' }}
            </button>
        </div>

        <div class="progress-bar" v-if="scanning">
            <div class="progress-fill" :style="{ width: scanProgress + '%' }"></div>
        </div>

        <div class="device-grid" v-if="devices.length > 0">
            <DeviceCard
                v-for="device in devices"
                :key="device.id"
                :device="device"
                :show-actions="true"
                @connect="connectDevice"
                @disconnect="disconnectDevice"
            />
        </div>

        <div class="empty-state" v-else>
            <div class="empty-icon">📡</div>
            <p v-if="!scanning">هیچ دستگاهی یافت نشد. دکمه "اسکن شبکه" را بزنید.</p>
            <p v-else>در حال جستجوی دستگاه‌های اندروید TV در شبکه...</p>
        </div>
    </div>
</template>

<style scoped>
.devices-view {
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

.progress-bar {
    height: 4px;
    background: var(--border-color);
    border-radius: 2px;
    margin-bottom: 24px;
    overflow: hidden;
}

.progress-fill {
    height: 100%;
    background: linear-gradient(90deg, var(--accent-color), var(--accent-hover));
    border-radius: 2px;
    transition: width 0.3s ease;
}

.device-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
    gap: 16px;
}

.empty-state {
    text-align: center;
    padding: 60px 20px;
    color: var(--text-muted);
}

.empty-icon {
    font-size: 4rem;
    margin-bottom: 16px;
    opacity: 0.5;
}
</style>