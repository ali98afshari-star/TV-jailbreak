<script setup>
import { ref, computed } from 'vue';

const props = defineProps({
    logs: { type: Array, default: () => [] }
});

defineEmits(['clear']);

const filter = ref('all');
const searchQuery = ref('');
const autoScroll = ref(true);

const filteredLogs = computed(() => {
    let result = props.logs;
    if (filter.value !== 'all') {
        result = result.filter(l => l.type === filter.value);
    }
    if (searchQuery.value) {
        const q = searchQuery.value.toLowerCase();
        result = result.filter(l => l.message.toLowerCase().includes(q));
    }
    return result;
});

function getTypeIcon(type) {
    const icons = { success: '✅', error: '❌', warning: '⚠️', info: 'ℹ️' };
    return icons[type] || '📝';
}

function getTypeClass(type) {
    return `log-${type}`;
}
</script>

<template>
    <div class="card">
        <div class="card-header">
            <div class="card-title">
                <span class="card-icon info">📋</span>
                لاگ‌های اجرایی
            </div>
            <div style="display: flex; gap: 8px; align-items: center;">
                <select class="form-input form-select" v-model="filter" style="width: auto; min-width: 120px;">
                    <option value="all">همه</option>
                    <option value="success">موفق ✅</option>
                    <option value="error">خطا ❌</option>
                    <option value="warning">هشدار ⚠️</option>
                    <option value="info">اطلاعات ℹ️</option>
                </select>
                <input class="form-input" v-model="searchQuery" placeholder="جستجو..." style="width: 200px;" />
                <label class="toggle" style="margin-right: 8px;">
                    <input type="checkbox" v-model="autoScroll" />
                    <span class="toggle-slider"></span>
                </label>
                <span style="font-size: 12px; color: var(--fg-muted);">اسکرول خودکار</span>
                <button class="btn btn-ghost btn-sm" @click="$emit('clear')">🗑 پاک کردن</button>
            </div>
        </div>

        <div class="log-viewer" ref="logContainer">
            <div v-if="filteredLogs.length === 0" class="log-line" style="text-align: center; color: var(--fg-muted); padding: 20px;">
                لاگی برای نمایش وجود ندارد
            </div>
            <div v-for="(log, i) in filteredLogs" :key="i" class="log-line animate-fade-in">
                <span class="log-time">[{{ new Date().toLocaleTimeString('fa-IR') }}]</span>
                <span :class="getTypeClass(log.type)">
                    {{ getTypeIcon(log.type) }} {{ log.message }}
                </span>
            </div>
        </div>
    </div>
</template>