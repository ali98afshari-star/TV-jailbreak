<script setup>
import { ref } from 'vue';

const props = defineProps({
    module: { type: Object, required: true }
});

defineEmits(['toggle']);

const isEnabled = ref(props.module.enabled);
const isToggling = ref(false);

async function toggle() {
    isToggling.value = true;
    isEnabled.value = !isEnabled.value;
    emit('toggle', props.module.id, isEnabled.value);
    // Simulate API call
    await new Promise(r => setTimeout(r, 500));
    isToggling.value = false;
}
</script>

<template>
    <div class="module-card animate-fade-in">
        <div class="module-info">
            <div class="module-name">{{ module.icon }} {{ module.name }}</div>
            <div class="module-desc">{{ module.desc }}</div>
        </div>
        <div class="module-toggle">
            <label class="toggle">
                <input type="checkbox" :checked="isEnabled" @change="toggle" :disabled="isToggling" />
                <span class="toggle-slider"></span>
            </label>
            <span class="badge" :class="isEnabled ? 'badge-success' : 'badge-neutral'" style="margin-right: 12px; font-size: 11px;">
                {{ isEnabled ? 'فعال' : 'غیرفعال' }}
            </span>
        </div>
    </div>
</template>