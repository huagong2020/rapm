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
          borderColor: '#3b82f6',
          backgroundColor: 'rgba(59,130,246,0.08)',
          fill: false,
          tension: 0.35,
          pointRadius: 6,
          pointHoverRadius: 9,
          pointBackgroundColor: '#3b82f6',
          pointBorderColor: '#0e1117',
          pointBorderWidth: 2,
          borderWidth: 2.5,
        },
        {
          label: 'DRAPM',
          data: props.history.map(h => h.drapm),
          borderColor: '#22c55e',
          backgroundColor: 'rgba(34,197,94,0.08)',
          fill: false,
          tension: 0.35,
          pointRadius: 6,
          pointHoverRadius: 9,
          pointBackgroundColor: '#22c55e',
          pointBorderColor: '#0e1117',
          pointBorderWidth: 2,
          borderWidth: 2.5,
        },
        {
          label: 'Total RAPM',
          data: props.history.map(h => h.rapm),
          borderColor: '#f59e0b',
          backgroundColor: 'rgba(245,158,11,0.08)',
          fill: false,
          tension: 0.35,
          pointRadius: 6,
          pointHoverRadius: 9,
          pointBackgroundColor: '#f59e0b',
          pointBorderColor: '#0e1117',
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
            color: '#7c869e',
            font: { family: 'Outfit', size: 12 },
            usePointStyle: true,
            pointStyle: 'circle',
            padding: 20,
          },
        },
        tooltip: {
          backgroundColor: '#1c2233',
          titleColor: '#eaedf4',
          bodyColor: '#eaedf4',
          borderColor: '#262e40',
          borderWidth: 1,
          titleFont: { family: 'Outfit', weight: '600' },
          bodyFont: { family: 'JetBrains Mono', size: 12 },
          padding: 12,
          cornerRadius: 8,
        },
      },
      scales: {
        x: {
          ticks: { color: '#4e576e', font: { family: 'Outfit', size: 12 } },
          grid: { color: '#1e2536' },
        },
        y: {
          ticks: { color: '#4e576e', font: { family: 'JetBrains Mono', size: 11 } },
          grid: { color: '#1e2536' },
          title: {
            display: true,
            text: 'RAPM Value',
            color: '#4e576e',
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
