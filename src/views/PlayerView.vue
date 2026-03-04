<script setup>
import { ref, computed, watch, inject } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import PlayerAvatar from '../components/PlayerAvatar.vue'
import StatCard from '../components/StatCard.vue'
import TrendChart from '../components/TrendChart.vue'
import BreakdownChart from '../components/BreakdownChart.vue'

const props = defineProps({
  allData: Object,
  seasons: Array,
  selectedSeason: String,
})

const route = useRoute()
const router = useRouter()

const playerId = computed(() => Number(route.params.id))
const viewSeason = ref(props.selectedSeason)

// Find this player across all seasons
const playerSeasons = computed(() => {
  return props.seasons.filter(s =>
    (props.allData[s] || []).some(p => p.id === playerId.value)
  )
})

// Get player info (use first available)
const playerInfo = computed(() => {
  for (const s of props.seasons) {
    const found = (props.allData[s] || []).find(p => p.id === playerId.value)
    if (found) return found
  }
  return null
})

// Current season data
const playerData = computed(() => {
  if (!viewSeason.value) return null
  return (props.allData[viewSeason.value] || []).find(p => p.id === playerId.value) || null
})

// History across all seasons
const playerHistory = computed(() => {
  return playerSeasons.value.map(s => {
    const p = (props.allData[s] || []).find(pl => pl.id === playerId.value)
    return p ? { season: s, ...p } : null
  }).filter(Boolean)
})

// Default view season to latest available
watch(playerSeasons, (ss) => {
  if (ss.length && !ss.includes(viewSeason.value)) {
    viewSeason.value = ss[ss.length - 1]
  }
}, { immediate: true })

function goBack() {
  router.push({ name: 'rankings' })
}
</script>

<template>
  <div class="player-view" v-if="playerInfo">
    <!-- Back -->
    <button class="back-btn" @click="goBack">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
        <path d="m15 18-6-6 6-6" />
      </svg>
      Back to Rankings
    </button>

    <!-- Player Header -->
    <div class="player-header">
      <PlayerAvatar :playerId="playerId" :size="100" class="big-avatar" />
      <div class="player-meta">
        <h1>{{ playerInfo.name }}</h1>
        <div class="player-id">ID {{ playerInfo.id }}</div>
        <div class="season-badges">
          <button
            v-for="s in playerSeasons"
            :key="s"
            :class="['badge', { active: viewSeason === s }]"
            @click="viewSeason = s"
          >
            {{ s }}
          </button>
        </div>
      </div>
    </div>

    <!-- Stat Cards -->
    <div class="stat-grid" v-if="playerData">
      <StatCard
        label="Offensive RAPM"
        :value="playerData.orapm"
        :se="playerData.se_off"
        variant="accent"
      />
      <StatCard
        label="Defensive RAPM"
        :value="playerData.drapm"
        :se="playerData.se_def"
        variant="green"
      />
      <StatCard
        label="Total RAPM"
        :value="playerData.rapm"
        :se="playerData.se_total"
        variant="amber"
      />
    </div>

    <!-- Charts -->
    <div class="charts-grid">
      <TrendChart :history="playerHistory" />
      <BreakdownChart v-if="playerData" :playerData="playerData" />
    </div>
  </div>

  <!-- Not found -->
  <div v-else class="not-found">
    <p>Player not found.</p>
    <button class="back-btn" @click="goBack">← Back to Rankings</button>
  </div>
</template>

<style scoped>
.player-view {
  padding-top: 20px;
}

.back-btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
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
  margin-bottom: 24px;
}

.back-btn:hover {
  border-color: var(--accent);
  color: var(--text);
}

/* Header */
.player-header {
  display: flex;
  align-items: flex-start;
  gap: 24px;
  margin-bottom: 28px;
}

.big-avatar {
  border-radius: var(--radius-lg) !important;
  border: 2px solid var(--border) !important;
  flex-shrink: 0;
}

.player-meta h1 {
  font-size: 30px;
  font-weight: 800;
  letter-spacing: -0.5px;
  line-height: 1.2;
}

.player-id {
  font-family: var(--font-mono);
  font-size: 12px;
  color: var(--text-muted);
  margin-top: 4px;
}

.season-badges {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  margin-top: 14px;
}

.badge {
  padding: 5px 12px;
  border-radius: 6px;
  font-size: 12px;
  font-family: var(--font-display);
  font-weight: 600;
  background: var(--surface-raised);
  color: var(--text-secondary);
  border: 1px solid var(--border);
  cursor: pointer;
  transition: all 0.15s var(--ease);
}

.badge.active {
  background: var(--accent);
  color: #fff;
  border-color: var(--accent);
  box-shadow: 0 2px 8px rgba(59, 130, 246, 0.25);
}

.badge:hover:not(.active) {
  border-color: var(--accent);
  color: var(--text);
}

/* Stat Grid */
.stat-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 14px;
  margin-bottom: 28px;
}

/* Charts Grid */
.charts-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  margin-bottom: 20px;
}

/* Not found */
.not-found {
  text-align: center;
  padding: 80px 0;
  color: var(--text-secondary);
}

@media (max-width: 768px) {
  .player-header {
    gap: 16px;
  }
  .big-avatar {
    width: 72px !important;
    height: 72px !important;
  }
  .player-meta h1 {
    font-size: 22px;
  }
  .stat-grid {
    grid-template-columns: repeat(3, 1fr);
    gap: 8px;
  }
  .charts-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 480px) {
  .stat-grid {
    grid-template-columns: 1fr 1fr 1fr;
    gap: 6px;
  }
}
</style>
