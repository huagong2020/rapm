<script setup>
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import PlayerAvatar from './PlayerAvatar.vue'

const props = defineProps({
  players: Array,
  page: Number,
  perPage: Number,
  sortKey: String,
  sortDir: String,
})

const emit = defineEmits(['sort'])
const router = useRouter()

const columns = [
  { key: 'orapm', label: 'ORAPM', title: 'Offensive RAPM' },
  { key: 'drapm', label: 'DRAPM', title: 'Defensive RAPM' },
  { key: 'rapm', label: 'RAPM', title: 'Total RAPM' },
]

function valClass(v) {
  if (v > 0) return 'val-pos'
  if (v < 0) return 'val-neg'
  return 'val-zero'
}

function fmtVal(v) {
  return (v >= 0 ? '+' : '') + v.toFixed(2)
}

function goToPlayer(id) {
  router.push({ name: 'player', params: { id } })
}
</script>

<template>
  <div class="table-wrap">
    <div class="table-scroll">
      <table>
        <thead>
          <tr>
            <th class="col-rank">#</th>
            <th class="col-name">Player</th>
            <th
              v-for="col in columns"
              :key="col.key"
              :class="['col-stat', { sorted: sortKey === col.key }]"
              :title="col.title"
              @click="emit('sort', col.key)"
            >
              {{ col.label }}
              <span v-if="sortKey === col.key" class="arrow">
                {{ sortDir === 'desc' ? '▼' : '▲' }}
              </span>
            </th>
            <th class="col-se hide-mobile">SE (Off)</th>
            <th class="col-se hide-mobile">SE (Def)</th>
            <th class="col-se hide-mobile">SE (Total)</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="(p, i) in players"
            :key="p.id"
            @click="goToPlayer(p.id)"
          >
            <td class="cell-rank">{{ (page - 1) * perPage + i + 1 }}</td>
            <td class="cell-name">
              <PlayerAvatar :playerId="p.id" :size="34" />
              <span class="player-name">{{ p.name }}</span>
            </td>
            <td :class="valClass(p.orapm)">{{ fmtVal(p.orapm) }}</td>
            <td :class="valClass(p.drapm)">{{ fmtVal(p.drapm) }}</td>
            <td :class="valClass(p.rapm)">{{ fmtVal(p.rapm) }}</td>
            <td class="cell-se hide-mobile">±{{ p.se_off.toFixed(2) }}</td>
            <td class="cell-se hide-mobile">±{{ p.se_def.toFixed(2) }}</td>
            <td class="cell-se hide-mobile">±{{ p.se_total.toFixed(2) }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<style scoped>
.table-wrap {
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius-lg);
  overflow: hidden;
  background: var(--surface);
}

.table-scroll {
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
}

table {
  width: 100%;
  border-collapse: collapse;
}

thead th {
  background: var(--surface-raised);
  padding: 12px 14px;
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.8px;
  color: var(--text-muted);
  text-align: left;
  white-space: nowrap;
  cursor: pointer;
  user-select: none;
  transition: color 0.15s;
  position: sticky;
  top: 0;
  z-index: 2;
}

thead th:hover {
  color: var(--text-secondary);
}

thead th.sorted {
  color: var(--accent);
}

.arrow {
  font-size: 9px;
  margin-left: 3px;
}

.col-rank {
  width: 48px;
  cursor: default !important;
}

.col-name {
  min-width: 180px;
  cursor: default !important;
}

.col-se {
  cursor: default !important;
}

tbody tr {
  border-top: 1px solid var(--border-subtle);
  transition: background 0.15s;
  cursor: pointer;
}

tbody tr:hover {
  background: var(--surface-hover);
}

td {
  padding: 10px 14px;
  font-size: 14px;
  white-space: nowrap;
}

.cell-rank {
  font-family: var(--font-mono);
  font-size: 12px;
  color: var(--text-muted);
}

.cell-name {
  display: flex;
  align-items: center;
  gap: 12px;
  font-weight: 500;
}

.player-name {
  overflow: hidden;
  text-overflow: ellipsis;
}

.cell-se {
  font-family: var(--font-mono);
  font-size: 12px;
  color: var(--text-muted);
}

/* Value coloring */
.val-pos {
  color: var(--green);
  font-family: var(--font-mono);
  font-size: 13px;
  font-weight: 600;
}
.val-neg {
  color: var(--red);
  font-family: var(--font-mono);
  font-size: 13px;
  font-weight: 600;
}
.val-zero {
  color: var(--text-secondary);
  font-family: var(--font-mono);
  font-size: 13px;
}

@media (max-width: 768px) {
  td {
    padding: 8px 10px;
    font-size: 13px;
  }
  .hide-mobile {
    display: none;
  }
  .col-name {
    min-width: 140px;
  }
}
</style>
