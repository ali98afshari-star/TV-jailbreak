<script setup>
import ModuleToggle from '@/components/ModuleToggle.vue';
import { ref } from 'vue';

const modules = ref([
    {
        id: 'launcher',
        name: 'Launcher Switcher',
        description: 'تعویض لانچر استوک با Projectivy Launcher / FLauncher',
        icon: '🏠',
        enabled: false,
        category: 'UI'
    },
    {
        id: 'bluetooth',
        name: 'Bluetooth Auto-Connect',
        description: 'اتصال خودکار کنترل‌های بلوتوث (RSS-18KB و مشابه)',
        icon: '📡',
        enabled: false,
        category: 'Input'
    },
    {
        id: 'keymapper',
        name: 'Remote Key Mapper',
        description: 'مپ دکمه‌های ریموت (HDMI، Recent، Voice، Live TV)',
        icon: '🎮',
        enabled: false,
        category: 'Input'
    },
    {
        id: 'accessibility',
        name: 'Accessibility Service',
        description: 'فعال‌سازی خودکار سرویس دسترسی برای اتوماسیون',
        icon: '♿',
        enabled: false,
        category: 'System'
    },
    {
        id: 'adb',
        name: 'ADB Persistence',
        description: 'پایداری ADB روی پورت ۵۵۵۵ بعد از ریبوت',
        icon: '🔌',
        enabled: false,
        category: 'System'
    },
    {
        id: 'pointer',
        name: 'Pointer Speed',
        description: 'تنظیم سرعت موس/پوینتر (پیش‌فرض: -5)',
        icon: '🖱️',
        enabled: false,
        category: 'UI'
    }
]);

const selectedCategory = ref('All');

const categories = ['All', 'UI', 'Input', 'System'];

const filteredModules = computed(() => {
    if (selectedCategory.value === 'All') return modules.value;
    return modules.value.filter(m => m.category === selectedCategory.value);
});
</script>

<template>
    <div class="modules-view">
        <div class="header">
            <h1>ماژول‌های سفارشی‌سازی</h1>
        </div>

        <div class="category-tabs">
            <button
                v-for="cat in categories"
                :key="cat"
                :class="['tab', { active: selectedCategory === cat }]"
                @click="selectedCategory = cat"
            >
                {{ cat }}
            </button>
        </div>

        <div class="modules-grid">
            <ModuleToggle
                v-for="module in filteredModules"
                :key="module.id"
                :module="module"
            />
        </div>

        <div class="info-panel">
            <h3>راهنما</h3>
            <ul>
                <li>هر ماژول یک اسکریپت شل مستقل است که روی TV اجرا می‌شود</li>
                <li>ماژول‌ها به ترتیب پیشنهادی اجرا می‌شوند (Launcher → Bluetooth → Keymapper → Accessibility → ADB → Pointer)</li>
                <li>نیاز به روت (Magisk/KernelSU) و ADB فعال دارد</li>
                <li>پیش از اجرا، از تب "دستگاه‌ها" مطمئن شوید TV متصل است</li>
            </ul>
        </div>
    </div>
</template>

<style scoped>
.modules-view {
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

.category-tabs {
    display: flex;
    gap: 8px;
    margin-bottom: 24px;
    flex-wrap: wrap;
}

.tab {
    padding: 8px 16px;
    border: 1px solid var(--border-color);
    background: var(--card-bg);
    border-radius: 20px;
    cursor: pointer;
    font-size: 0.875rem;
    color: var(--text-secondary);
    transition: all 0.2s;
}

.tab:hover {
    border-color: var(--accent-color);
    color: var(--accent-color);
}

.tab.active {
    background: var(--accent-color);
    border-color: var(--accent-color);
    color: white;
}

.modules-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
    gap: 16px;
    margin-bottom: 32px;
}

.info-panel {
    padding: 20px;
    background: var(--card-bg);
    border: 1px solid var(--border-color);
    border-radius: 12px;
}

.info-panel h3 {
    margin: 0 0 12px;
    font-size: 1rem;
    color: var(--text-primary);
}

.info-panel ul {
    margin: 0;
    padding-right: 20px;
}

.info-panel li {
    margin-bottom: 8px;
    font-size: 0.875rem;
    color: var(--text-secondary);
    line-height: 1.5;
}
</style>