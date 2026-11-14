<script setup>
import LogViewer from '@/components/LogViewer.vue';
import { ref, onMounted } from 'vue';

const logs = ref([]);
const filter = ref('all');
const autoScroll = ref(true);

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

async function clearLogs() {
    try {
        await window.electronAPI.invoke('clear-logs');
        logs.value = [];
    } catch (e) {
        console.error('Failed to clear logs:', e);
    }
}

async function exportLogs() {
    try {
        const result = await window.electronAPI.invoke('export-logs');
        if (result.success) {
            alert('لاگ‌ها ذخیره شدند: ' + result.path);
        }
    } catch (e) {
        console.error('Failed to export logs:', e);
    }
}

onMounted(() => {
    loadLogs();
});
</script>

<template>
    <div class="logs-view">
        <div class="header">
            <h1>لاگ‌های سیستمی</h1>
            <div class="header-actions">
                <select v-model="filter" class="filter-select">
                    <option value="all">همه</option>
                    <option value="info">اطلاعات</option>
                    <option value="success">موفقیت</option>
                    <option value="warning">هشدار</option>
                    <option value="error">خطا</option>
                </select>
                <label class="checkbox-label">
                    <input type="checkbox" v-model="autoScroll" />
                    اسکرول خودکار
                </label>
                <button class="btn btn-secondary" @click="clearLogs">پاک کردن</button>
                <button class="btn btn-primary" @click="exportLogs">خروجی</button>
            </div>
        </div>

        <LogViewer :logs="filteredLogs" :auto-scroll="autoScroll" />

        <div class="log-stats">
            <span>مجموع: {{ logs.length }}</span>
            <span>نمایش: {{ filteredLogs.length }}</span>
        </div>
    </div>
</template>

<script>
import { computed } from 'vue';

export default {
    computed: {
        filteredLogs() {
            if (this.filter === 'all') return this.logs;
            return this.logs.filter(log => log.level === this.filter);
        }
    }
}
</script>

<style scoped>
.logs-view {
    padding: 24px;
    max-width: 1200px;
    margin: 0 auto;
}

.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16px;
    padding-bottom: 16px;
    border-bottom: 1px solid var(--border-color);
    flex-wrap: wrap;
    gap: 16px;
}

.header h1 {
    margin: 0;
    font-size: 1.75rem;
    font-weight: 600;
    color: var(--text-primary);
}

.header-actions {
    display: flex;
    align-items: center;
    gap: 12px;
    flex-wrap: wrap;
}

.filter-select {
    padding: 8px 12px;
    border: 1px solid var(--border-color);
    background: var(--card-bg);
    border-radius: 8px;
    color: var(--text-primary);
    font-size: 0.875rem;
}

.checkbox-label {
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 0.875rem;
    color: var(--text-secondary);
    cursor: pointer;
}

.log-stats {
    display: flex;
    gap: 24px;
    margin-top: 16px;
    padding: 12px;
    background: var(--card-bg);
    border: 1px solid var(--border-color);
    border-radius: 8px;
    font-size: 0.875rem;
    color: var(--text-secondary);
}
</style>