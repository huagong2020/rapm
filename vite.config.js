import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  // For GitHub Pages: set base to your repo name
  // e.g. base: '/rapm-analytics/'
  // For custom domain or root deploy, use '/'
  base: '/rapm/',
})
