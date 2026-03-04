<script setup>
import { ref, computed, watch } from 'vue'
import SearchBar from '../components/SearchBar.vue'
import MetricTabs from '../components/MetricTabs.vue'
import PlayerTable from '../components/PlayerTable.vue'
import PaginationBar from '../components/PaginationBar.vue'

const props = defineProps({
  allData: Object,
  seasons: Array,
  selectedSeason: String,
})

const search = ref('')
const metric = ref('rapm')
const sortKey = ref('rapm')
const sortDir = ref('desc')
const page = ref(1)
const perPage = 50

const currentPlayers = computed(() => {
  return props.allData[props.selectedSeason] || []
})

const filteredPlayers = computed(() => {
  let list = [...currentPlayers.value]
  if (search.value) {
    const q = search.value.toLowerCase()
    list = list.filter(p => p.name.toLowerCase().includes(q))
  }
  list.sort((a, b) => {
    const va = a[sortKey.value]
    const vb = b[sortKey.value]
    return sortDir.value === 'desc' ? vb - va : va - vb
  })
  return list
})

const totalPages = computed(() => Math.max(1, Math.ceil(filteredPlayers.value.length / perPage)))

const paginatedPlayers = computed(() => {
  const start = (page.value - 1) * perPage
  return filteredPlayers.value.slice(start, start + perPage)
})

function handleSort(key) {
  if (sortKey.value === key) {
    sortDir.value = sortDir.value === 'desc' ? 'asc' : 'desc'
  } else {
    sortKey.value = key
    sortDir.value = 'desc'
  }
  page.value = 1
}

// When metric tab changes, update sort
watch(metric, (m) => {
  sortKey.value = m
  sortDir.value = 'desc'
  page.value = 1
})

// Reset page on search or season change
watch(search, () => { page.value = 1 })
watch(() => props.selectedSeason, () => { page.value = 1 })
</script>

<template>
  <div class="rankings-view">
    <!-- Toolbar -->
    <div class="toolbar">
      <SearchBar v-model="search" />
      <MetricTabs v-model="metric" />
    </div>

    <!-- Player count -->
    <div class="result-count">
      {{ filteredPlayers.length }} player{{ filteredPlayers.length !== 1 ? 's' : '' }}
    </div>

    <!-- Table -->
    <PlayerTable
      :players="paginatedPlayers"
      :page="page"
      :perPage="perPage"
      :sortKey="sortKey"
      :sortDir="sortDir"
      @sort="handleSort"
    />

    <!-- Pagination -->
    <PaginationBar
      v-model:page="page"
      :totalPages="totalPages"
    />
  </div>
</template>

<style scoped>
.rankings-view {
  padding-top: 24px;
}

.toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 16px;
  margin-bottom: 16px;
}

.result-count {
  font-size: 12px;
  color: var(--text-muted);
  margin-bottom: 12px;
  font-family: var(--font-mono);
}

@media (max-width: 640px) {
  .toolbar {
    flex-direction: column;
    align-items: stretch;
  }
}
</style>
