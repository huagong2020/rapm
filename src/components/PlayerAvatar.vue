<script setup>
import { ref } from 'vue'

const props = defineProps({
  playerId: [Number, String],
  size: { type: Number, default: 40 },
})

const errored = ref(false)

const imgUrl = `https://cdn.nba.com/headshots/nba/latest/260x190/${props.playerId}.png`

function onError() {
  errored.value = true
}
</script>

<template>
  <div
    class="avatar"
    :style="{ width: size + 'px', height: size + 'px' }"
  >
    <img
      v-if="!errored"
      :src="imgUrl"
      :alt="'Player ' + playerId"
      loading="lazy"
      @error="onError"
    />
    <div v-else class="avatar-fallback">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
        <circle cx="12" cy="7" r="4" />
      </svg>
    </div>
  </div>
</template>

<style scoped>
.avatar {
  border-radius: 50%;
  overflow: hidden;
  background: var(--surface-raised);
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
}

.avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.avatar-fallback {
  width: 55%;
  height: 55%;
  color: var(--text-muted);
}

.avatar-fallback svg {
  width: 100%;
  height: 100%;
}
</style>
