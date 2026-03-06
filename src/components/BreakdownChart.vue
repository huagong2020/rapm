<script setup>
import { ref, onMounted, onBeforeUnmount, watch, nextTick } from 'vue'
import { Chart, registerables } from 'chart.js'

Chart.register(...registerables)

const props = defineProps({
  playerData: Object, // { orapm, drapm, rapm, se_off, se_def, se_total }
})

const canvasRef = ref(null)
let chartInstance = null

// Custom plugin for error bars
const errorBarPlugin = {
  id: 'errorBars',
  afterDraw(chart) {
    const pd = props.playerData
    if (!pd) return

    const { ctx, scales: { y } } = chart
    const se = [pd.se_off, pd.se_def, pd.se_total]
    const vals = [pd.orapm, pd.drapm, pd.rapm]
    const meta = chart.getDatasetMeta(0)

    ctx.save()
    ctx.strokeStyle = '#1a1e2b'
    ctx.lineWidth = 1.5

    meta.data.forEach((bar, i) => {
      const cx = bar.x
      const yTop = y.getPixelForValue(vals[i] + se[i])
      const yBot = y.getPixelForValue(vals[i] - se[i])

      // Vertical line
      ctx.beginPath()
      ctx.moveTo(cx, yTop)
      ctx.lineTo(cx, yBot)
      ctx.stroke()

      // Top cap
      ctx.beginPath()
      ctx.moveTo(cx - 7, yTop)
      ctx.lineTo(cx + 7, yTop)
      ctx.stroke()

      // Bottom cap
      ctx.beginPath()
      ctx.moveTo(cx - 7, yBot)
      ctx.lineTo(cx + 7, yBot)
      ctx.stroke()
    })
    ctx.restore()
  },
}

function renderChart() {
  if (chartInstance) chartInstance.destroy()
  if (!canvasRef.value || !props.playerData) return

  const pd = props.playerData

  chartInstance = new Chart(canvasRef.value, {
    type: 'bar',
    data: {
      labels: ['Offensive', 'Defensive', 'Total'],
      datasets: [{
        label: 'RAPM',
        data: [pd.orapm, pd.drapm, pd.rapm],
        backgroundColor: [
          'rgba(37, 99, 235, 0.55)',
          'rgba(22, 163, 74, 0.55)',
          'rgba(217, 119, 6, 0.55)',
        ],
        borderColor: ['#2563eb', '#16a34a', '#d97706'],
        borderWidth: 2,
        borderRadius: 8,
        maxBarThickness: 80,
      }],
    },
    plugins: [errorBarPlugin],
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: { display: false },
        tooltip: {
          backgroundColor: '#1a1e2b',
          titleColor: '#ffffff',
          bodyColor: '#ffffff',
          borderColor: '#d8dde6',
          borderWidth: 1,
          titleFont: { family: 'Roboto', weight: '600' },
          bodyFont: { family: 'Roboto Mono', size: 12 },
          padding: 12,
          cornerRadius: 8,
          callbacks: {
            afterLabel(ctx) {
              const ses = [pd.se_off, pd.se_def, pd.se_total]
              return `± ${ses[ctx.dataIndex].toFixed(2)} SE`
            },
          },
        },
      },
      scales: {
        x: {
          ticks: { color: '#5a6378', font: { family: 'Roboto', size: 13, weight: '500' } },
          grid: { display: false },
        },
        y: {
          ticks: { color: '#5a6378', font: { family: 'Roboto Mono', size: 11 } },
          grid: { color: '#e4e8ef' },
          title: {
            display: true,
            text: 'RAPM Value',
            color: '#5a6378',
            font: { family: 'Roboto', size: 12, weight: '500' },
          },
        },
      },
    },
  })
}

onMounted(() => nextTick(renderChart))
watch(() => props.playerData, () => nextTick(renderChart), { deep: true })
onBeforeUnmount(() => { if (chartInstance) chartInstance.destroy() })
</script>

<template>
  <div class="chart-card">
    <h3 class="chart-title">Season Breakdown <span class="subtitle">(with ± 1 SE)</span></h3>
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

.subtitle {
  font-weight: 400;
  color: var(--text-muted);
  font-size: 13px;
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
