<script setup>
import { useRouter, useRoute } from 'vue-router'

const props = defineProps({
  seasons: Array,
  selectedSeason: String,
  updateDate: String,
})

const emit = defineEmits(['update:selectedSeason'])

const router = useRouter()
const route = useRoute()

function goHome() {
  router.push({ name: 'rankings' })
}
</script>

<template>
  <header class="header">
    <div class="container header-inner">
      <div class="logo" @click="goHome">
        <div class="logo-text">
          NBA RAPM<span class="logo-accent"></span>
        </div>
      </div>
      <!--  -->
      <div class="header-right" > 
        <span v-if="updateDate" class="update-note">Last update: {{ updateDate }}</span>
        <select v-if="route.name === 'rankings'"
          class="season-select"
          :value="selectedSeason"
          @change="emit('update:selectedSeason', $event.target.value)"
        >
          <option v-for="s in seasons" :key="s" :value="s">{{ s }} Season</option>
        </select>
      </div>
    </div>
  </header>
</template>

<style scoped>
.header {
  border-bottom: 1px solid var(--border-subtle);
  background: var(--bg-deep);
  position: sticky;
  top: 0;
  z-index: 100;
  backdrop-filter: blur(12px);
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
}

.header-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding-top: 16px;
  padding-bottom: 16px;
  gap: 12px;
}

.logo {
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  user-select: none;
}

.logo-icon {
  font-size: 24px;
}

.logo-text {
  font-weight: 800;
  font-size: 20px;
  letter-spacing: -0.5px;
}

.logo-accent {
  color: var(--accent);
  font-weight: 500;
}

.season-select {
  background: var(--surface);
  border: 1px solid var(--border);
  color: var(--text);
  padding: 6px 14px;
  border-radius: var(--radius-sm);
  font-family: var(--font-display);
  font-size: 12px;
  font-weight: 500;
  cursor: pointer;
  outline: none;
  transition: border-color 0.2s var(--ease);
}

.season-select:focus {
  border-color: var(--accent);
}

.header-right {
  display: flex;
  align-items: center;
  gap: 14px;
}

.update-note {
  font-size: 12px;
  color: var(--text-muted);
}

@media (max-width: 640px) {
  .logo-text {
    font-size: 17px;
  }
  .season-select {
    font-size: 12px;
    padding: 6px 10px;
  }

  .update-note {
      font-size: 6x;
  color: var(--text-muted);
  }
}
</style>
