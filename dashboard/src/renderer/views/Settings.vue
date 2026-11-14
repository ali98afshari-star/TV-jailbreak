<script setup>
import SettingsPanel from '@/components/SettingsPanel.vue';
import { ref } from 'vue';

const activeTab = ref('general');

const tabs = [
    { id: 'general', label: 'عمومی', icon: '⚙️' },
    { id: 'adb', label: 'ADB', icon: '🔌' },
    { id: 'appearance', label: 'ظاهری', icon: '🎨' },
    { id: 'advanced', label: 'پیشرفته', icon: '🔧' }
];
</script>

<template>
    <div class="settings-view">
        <div class="header">
            <h1>تنظیمات</h1>
        </div>

        <div class="settings-layout">
            <nav class="settings-nav">
                <button
                    v-for="tab in tabs"
                    :key="tab.id"
                    :class="['nav-item', { active: activeTab === tab.id }]"
                    @click="activeTab = tab.id"
                >
                    <span class="nav-icon">{{ tab.icon }}</span>
                    <span>{{ tab.label }}</span>
                </button>
            </nav>

            <div class="settings-content">
                <SettingsPanel :active-tab="activeTab" />
            </div>
        </div>
    </div>
</template>

<style scoped>
.settings-view {
    padding: 24px;
    max-width: 1200px;
    margin: 0 auto;
}

.header {
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

.settings-layout {
    display: flex;
    gap: 24px;
}

.settings-nav {
    width: 200px;
    flex-shrink: 0;
}

.nav-item {
    display: flex;
    align-items: center;
    gap: 12px;
    width: 100%;
    padding: 12px 16px;
    border: 1px solid var(--border-color);
    background: var(--card-bg);
    border-radius: 8px;
    margin-bottom: 8px;
    cursor: pointer;
    text-align: right;
    font-size: 0.9375rem;
    color: var(--text-secondary);
    transition: all 0.2s;
}

.nav-item:hover {
    border-color: var(--accent-color);
    color: var(--accent-color);
}

.nav-item.active {
    background: var(--accent-color);
    border-color: var(--accent-color);
    color: white;
}

.nav-icon {
    font-size: 1.125rem;
}

.settings-content {
    flex: 1;
    min-width: 0;
}
</style>