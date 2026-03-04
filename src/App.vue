<script setup>
import { ref, watch, onMounted, provide } from 'vue'
import AppHeader from './components/AppHeader.vue'

const allData = ref({})
const seasons = ref([])
const selectedSeason = ref('')
const loading = ref(true)
const loadingSeasons = ref({}) // track which seasons are being fetched

const BASE = import.meta.env.BASE_URL

async function loadSeason(season) {
  if (allData.value[season]) return // already loaded
  if (loadingSeasons.value[season]) return // already fetching

  loadingSeasons.value[season] = true
  try {
    const resp = await fetch(`${BASE}data/${season}.json`)
    const players = await resp.json()
    allData.value = { ...allData.value, [season]: players }
  } catch (e) {
    console.error(`Failed to load season ${season}:`, e)
  } finally {
    loadingSeasons.value[season] = false
  }
}

onMounted(async () => {
  try {
    // Load the season index (tiny file listing available seasons)
    const resp = await fetch(`${BASE}data/seasons.json`)
    
    const list = await resp.json()
    seasons.value = list.sort()
  
    selectedSeason.value = list[list.length - 1]

    // Load all seasons for player trend charts
    await Promise.all(list.map(s => loadSeason(s)))
  } catch (e) {
    console.error('Failed to load season index:', e)
  } finally {
    loading.value = false
  }
})

// Lazy-load when user switches season (in case it wasn't pre-loaded)
watch(selectedSeason, (s) => {
  if (s) loadSeason(s)
})

// Provide data globally to all child components
provide('allData', allData)
provide('seasons', seasons)
provide('selectedSeason', selectedSeason)
</script>

<template>
  <div class="app-root">
    <AppHeader
      :seasons="seasons"
      v-model:selectedSeason="selectedSeason"
    />
    <main class="container">
      <div v-if="loading" class="loader">
        <div class="loader-spinner"></div>
        <p>Loading RAPM data…</p>
      </div>
      <router-view
        v-else
        :allData="allData"
        :seasons="seasons"
        :selectedSeason="selectedSeason"
      />
    </main>
    <footer class="app-footer">
      <div class="container">
        RAPM Analytics · Player images via cdn.nba.com
      </div>
    </footer>
  </div>
</template>

<style scoped>
.app-root {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

main {
  flex: 1;
  padding-bottom: 40px;
}

.loader {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 80px 0;
  gap: 16px;
  color: var(--text-secondary);
}

.loader-spinner {
  width: 32px;
  height: 32px;
  border: 3px solid var(--border);
  border-top-color: var(--accent);
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.app-footer {
  text-align: center;
  padding: 28px 0;
  font-size: 12px;
  color: var(--text-muted);
  border-top: 1px solid var(--border-subtle);
}
</style>
