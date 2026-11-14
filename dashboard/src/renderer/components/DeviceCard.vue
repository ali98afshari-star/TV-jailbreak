<script setup>
import { ref } from 'vue';

const props = defineProps({
    devices: { type: Array, default: () => [] }
});

defineEmits(['add-device', 'remove-device', 'connect']);

const newDevice = ref({ ip: '', port: 5555, name: '' });
const showForm = ref(false);

function submitDevice() {
    if (!newDevice.value.ip) return;
    emit('add-device', { ...newDevice.value, status: 'pending' });
    newDevice.value = { ip: '', port: 5555, name: '' };
    showForm.value = false;
}

function connect(device) {
    emit('connect', device);
}

function remove(device) {
    emit('remove-device', device.ip);
}
</script>

<template>
    <div>
        <div class="card-header" style="justify-content: space-between; align-items: center;">
            <div class="card-title">
                <span class="card-icon primary">📺</span>
                مدیریت دستگاه‌ها
            </div>
            <button class="btn btn-primary btn-sm" @click="showForm = !showForm">
                {{ showForm ? '✕ انصراف' : '➕ اضافه کردن دستگاه' }}
            </button>
        </div>

        <!-- Add Device Form -->
        <div v-if="showForm" class="card" style="margin-bottom: 16px; background: var(--bg-tertiary);">
            <div class="grid grid-3" style="align-items: end;">
                <div class="form-group">
                    <label class="form-label">آدرس IP</label>
                    <input class="form-input" v-model="newDevice.ip" placeholder="192.168.1.100" @keyup.enter="submitDevice" />
                </div>
                <div class="form-group">
                    <label class="form-label">پورت</label>
                    <input class="form-input" type="number" v-model.number="newDevice.port" placeholder="5555" @keyup.enter="submitDevice" />
                </div>
                <div class="form-group">
                    <label class="form-label">نام دستگاه</label>
                    <input class="form-input" v-model="newDevice.name" placeholder="Snowa TV" @keyup.enter="submitDevice" />
                </div>
            </div>
            <div style="display: flex; gap: 8px; justify-content: flex-end; margin-top: 12px;">
                <button class="btn btn-secondary" @click="showForm = false">انصراف</button>
                <button class="btn btn-primary" @click="submitDevice">➕ اضافه کردن</button>
            </div>
        </div>

        <!-- Devices List -->
        <div v-if="devices.length === 0" class="card" style="text-align: center; padding: 40px; color: var(--fg-muted);">
            <div style="font-size: 48px; margin-bottom: 16px;">📺</div>
            <p>هیچ دستگاهی اضافه نشده</p>
            <p style="font-size: 12px; margin-top: 8px;">دستگاه جدید اضافه کنید تا در لیست نمایش داده شود</p>
        </div>

        <div v-else class="grid grid-2">
            <div class="device-card" v-for="device in devices" :key="device.ip" :class="{ connected: device.status === 'connected' }">
                <div class="device-header">
                    <div class="device-info">
                        <h3>{{ device.name || 'نامشخص' }}</h3>
                        <p>{{ device.ip }}:{{ device.port }} • {{ device.model || 'Android TV' }}</p>
                    </div>
                    <span class="badge" :class="device.status === 'connected' ? 'badge-success' : device.status === 'pending' ? 'badge-warning' : 'badge-danger'">
                        {{ device.status === 'connected' ? 'متصل' : device.status === 'pending' ? 'در حال اتصال...' : 'قطع' }}
                    </span>
                </div>

                <div class="device-actions">
                    <button class="btn btn-secondary btn-sm" @click="connect(device)" :disabled="device.status === 'connected'">
                        {{ device.status === 'connected' ? '✅ متصل است' : '🔗 اتصال' }}
                    </button>
                    <button class="btn btn-ghost btn-sm" @click="remove(device)">🗑 حذف</button>
                </div>

                <div v-if="device.status === 'connected'" style="margin-top: 12px; padding-top: 12px; border-top: 1px solid var(--border); display: grid; grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); gap: 8px; font-size: 12px; color: var(--fg-secondary);">
                    <div>✅ ADB فعال</div>
                    <div v-if="device.root">🔐 روت فعال</div>
                    <div v-else>⚠️ روت غیرفعال</div>
                </div>
            </div>
        </div>
    </div>
</template>