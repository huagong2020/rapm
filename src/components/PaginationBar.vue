<script setup>
const props = defineProps({
  page: Number,
  totalPages: Number,
})
const emit = defineEmits(['update:page'])
</script>

<template>
  <div class="pagination">
    <button :disabled="page <= 1" @click="emit('update:page', page - 1)">
      ← Prev
    </button>
    <span class="page-info">{{ page }} / {{ totalPages }}</span>
    <button :disabled="page >= totalPages" @click="emit('update:page', page + 1)">
      Next →
    </button>
  </div>
</template>

<style scoped>
.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 10px;
  padding: 24px 0;
}

button {
  padding: 8px 16px;
  border: 1px solid var(--border);
  border-radius: var(--radius-sm);
  background: var(--surface);
  color: var(--text-secondary);
  font-family: var(--font-display);
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.15s var(--ease);
}

button:hover:not(:disabled) {
  border-color: var(--accent);
  color: var(--text);
}

button:disabled {
  opacity: 0.3;
  cursor: default;
}

.page-info {
  font-size: 13px;
  color: var(--text-muted);
  font-family: var(--font-mono);
  min-width: 60px;
  text-align: center;
}
</style>
