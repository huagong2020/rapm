<script setup>
const props = defineProps({
  modelValue: String,
})
const emit = defineEmits(['update:modelValue'])

const tabs = [
  { key: 'rapm', label: 'Total RAPM' },
  { key: 'orapm', label: 'Offensive' },
  { key: 'drapm', label: 'Defensive' },
]
</script>

<template>
  <div class="tabs">
    <button
      v-for="t in tabs"
      :key="t.key"
      :class="['tab', { active: modelValue === t.key }]"
      @click="emit('update:modelValue', t.key)"
    >
      {{ t.label }}
    </button>
  </div>
</template>

<style scoped>
.tabs {
  display: inline-flex;
  gap: 3px;
  background: var(--surface);
  border-radius: var(--radius);
  padding: 3px;
}

.tab {
  padding: 8px 18px;
  border: none;
  border-radius: 9px;
  font-family: var(--font-display);
  font-size: 13px;
  font-weight: 600;
  color: var(--text-secondary);
  cursor: pointer;
  background: transparent;
  transition: all 0.2s var(--ease);
  white-space: nowrap;
}

.tab.active {
  background: var(--accent);
  color: #fff;
  box-shadow: 0 2px 8px rgba(59, 130, 246, 0.3);
}

.tab:hover:not(.active) {
  color: var(--text);
  background: var(--surface-hover);
}

@media (max-width: 640px) {
  .tab {
    padding: 7px 12px;
    font-size: 12px;
  }
}
</style>
