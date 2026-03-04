import { createRouter, createWebHashHistory } from 'vue-router'
import RankingsView from '../views/RankingsView.vue'
import PlayerView from '../views/PlayerView.vue'

const routes = [
  {
    path: '/',
    name: 'rankings',
    component: RankingsView,
  },
  {
    path: '/player/:id',
    name: 'player',
    component: PlayerView,
    props: true,
  },
]

const router = createRouter({
  history: createWebHashHistory(),
  routes,
  scrollBehavior() {
    return { top: 0 }
  },
})

export default router
