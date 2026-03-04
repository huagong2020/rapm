<script setup>
const props = defineProps({
  modelValue: String,
})
const emit = defineEmits(['update:modelValue'])
</script>

<template>
  <div class="search-wrap">
    <svg class="search-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
      <circle cx="11" cy="11" r="8" />
      <path d="m21 21-4.35-4.35" />
    </svg>
    <input
      type="text"
      :value="modelValue"
      @input="emit('update:modelValue', $event.target.value)"
      placeholder="Search players…"
    />
  </div>
</template>

<style scoped>
.search-wrap {
  position: relative;
  width: 100%;
  max-width: 400px;
}

.search-icon {
  position: absolute;
  left: 14px;
  top: 50%;
  transform: translateY(-50%);
  color: var(--text-muted);
  pointer-events: none;
}

input {
  width: 100%;
  padding: 11px 16px 11px 42px;
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  color: var(--text);
  font-size: 14px;
  font-family: var(--font-display);
  outline: none;
  transition: border-color 0.2s var(--ease), box-shadow 0.2s var(--ease);
}

input::placeholder {
  color: var(--text-muted);
}

input:focus {
  border-color: var(--accent);
  box-shadow: 0 0 0 3px var(--accent-soft);
}
</style>
