<script setup>
const props = defineProps({
  label: String,
  value: Number,
  se: Number,
  variant: { type: String, default: 'accent' }, // accent, green, amber
})

function fmtVal(v) {
  return (v >= 0 ? '+' : '') + v.toFixed(1)
}
</script>

<template>
  <div :class="['stat-card', variant]">
    <div class="stat-label">{{ label }}</div>
    <div class="stat-value">{{ fmtVal(value) }}</div>
    <div class="stat-se">± {{ se.toFixed(2) }} SE</div>
  </div>
</template>

<style scoped>
.stat-card {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: var(--radius-lg);
  padding: 22px 18px;
  text-align: center;
  transition: transform 0.2s var(--ease), box-shadow 0.2s var(--ease);
}

.stat-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
}

.stat-label {
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 1.2px;
  color: var(--text-muted);
  margin-bottom: 10px;
}

.stat-value {
  font-family: var(--font-mono);
  font-size: 30px;
  font-weight: 600;
  line-height: 1;
}

.stat-se {
  font-size: 12px;
  color: var(--text-muted);
  margin-top: 8px;
  font-family: var(--font-mono);
}

/* Variants */
.accent .stat-value { color: var(--accent); }
.green .stat-value { color: var(--green); }
.amber .stat-value { color: var(--amber); }

/* Subtle border glow */
.accent { border-color: rgba(37, 99, 235, 0.25); }
.green { border-color: rgba(22, 163, 74, 0.25); }
.amber { border-color: rgba(217, 119, 6, 0.25); }

@media (max-width: 640px) {
  .stat-card { padding: 14px 10px; }
  .stat-value { font-size: 22px; }
  .stat-label { font-size: 10px; }
}
</style>
