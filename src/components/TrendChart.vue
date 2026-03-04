<script setup>
import { ref, onMounted, onBeforeUnmount, watch, nextTick } from 'vue'
import { Chart, registerables } from 'chart.js'

Chart.register(...registerables)

const props = defineProps({
  history: Array, // [{ season, orapm, drapm, rapm, se_off, se_def, se_total }]
})

const canvasRef = ref(null)
let chartInstance = null

function renderChart() {
  if (chartInstance) chartInstance.destroy()
  if (!canvasRef.value || !props.history?.length) return

  const labels = props.history.map(h => h.season)

  chartInstance = new Chart(canvasRef.value, {
    type: 'line',
    data: {
      labels,
      datasets: [
        {
          label: 'ORAPM',
          data: props.history.map(h => h.orapm),
          borderColor: '#2563eb',
          backgroundColor: 'rgba(37,99,235,0.06)',
          fill: false,
          tension: 0.35,
          pointRadius: 6,
          pointHoverRadius: 9,
          pointBackgroundColor: '#2563eb',
          pointBorderColor: '#ffffff',
          pointBorderWidth: 2,
          borderWidth: 2.5,
        },
        {
          label: 'DRAPM',
          data: props.history.map(h => h.drapm),
          borderColor: '#16a34a',
          backgroundColor: 'rgba(22,163,74,0.06)',
          fill: false,
          tension: 0.35,
          pointRadius: 6,
          pointHoverRadius: 9,
          pointBackgroundColor: '#16a34a',
          pointBorderColor: '#ffffff',
          pointBorderWidth: 2,
          borderWidth: 2.5,
        },
        {
          label: 'Total RAPM',
          data: props.history.map(h => h.rapm),
          borderColor: '#d97706',
          backgroundColor: 'rgba(217,119,6,0.06)',
          fill: false,
          tension: 0.35,
          pointRadius: 6,
          pointHoverRadius: 9,
          pointBackgroundColor: '#d97706',
          pointBorderColor: '#ffffff',
          pointBorderWidth: 2,
          borderWidth: 2.5,
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      interaction: {
        intersect: false,
        mode: 'index',
      },
      plugins: {
        legend: {
          labels: {
            color: '#5a6378',
            font: { family: 'Outfit', size: 12 },
            usePointStyle: true,
            pointStyle: 'circle',
            padding: 20,
          },
        },
        tooltip: {
          backgroundColor: '#1a1e2b',
          titleColor: '#ffffff',
          bodyColor: '#ffffff',
          borderColor: '#d8dde6',
          borderWidth: 1,
          titleFont: { family: 'Outfit', weight: '600' },
          bodyFont: { family: 'JetBrains Mono', size: 12 },
          padding: 12,
          cornerRadius: 8,
        },
      },
      scales: {
        x: {
          ticks: { color: '#5a6378', font: { family: 'Outfit', size: 12 } },
          grid: { color: '#e4e8ef' },
        },
        y: {
          ticks: { color: '#5a6378', font: { family: 'JetBrains Mono', size: 11 } },
          grid: { color: '#e4e8ef' },
          title: {
            display: true,
            text: 'RAPM Value',
            color: '#5a6378',
            font: { family: 'Outfit', size: 12, weight: '500' },
          },
        },
      },
    },
  })
}

onMounted(() => nextTick(renderChart))
watch(() => props.history, () => nextTick(renderChart), { deep: true })
onBeforeUnmount(() => { if (chartInstance) chartInstance.destroy() })
</script>

<template>
  <div class="chart-card">
    <h3 class="chart-title">RAPM Trend Over Seasons</h3>
    <div v-if="history.length <= 1" class="chart-note">
      Add more seasons to see trends. Currently showing 1 season.
    </div>
    <div class="chart-container">
      <canvas ref="canvasRef"></canvas>
    </div>
  </div>
</template>

<style scoped>
.chart-card {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: var(--radius-lg);
  padding: 24px;
}

.chart-title {
  font-size: 15px;
  font-weight: 600;
  margin-bottom: 16px;
  color: var(--text);
}

.chart-note {
  font-size: 13px;
  color: var(--text-muted);
  margin-bottom: 12px;
  font-style: italic;
}

.chart-container {
  position: relative;
  width: 100%;
  height: 300px;
}

@media (max-width: 640px) {
  .chart-card { padding: 16px; }
  .chart-container { height: 220px; }
}
</style>
