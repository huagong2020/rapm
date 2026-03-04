# RAPM

A responsive basketball analytics dashboard built with **Vue 3 + Vite**, showing Regularized Adjusted Plus-Minus (RAPM) player rankings.

## Features

- **Rankings Table** — Sort by Total RAPM, Offensive (ORAPM), or Defensive (DRAPM)
- **Player Search** — Filter by name instantly
- **Season Selector** — Switch between different seasons
- **Player Detail Pages** — Click any player to see:
  - Player headshot (NBA CDN)
  - ORAPM / DRAPM / RAPM stat cards with posterior standard errors
  - RAPM trend line chart across all available seasons
  - Breakdown bar chart with ± 1 SE error bars
- **Responsive** — Desktop, tablet, and mobile layouts
- **GitHub Pages ready** — Auto-deploys via GitHub Actions

## Quick Start

```bash
# Install dependencies
npm install

# Start dev server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

## Project Structure

```
rapm/
├── public/
│   └── data/
│       └── seasons.json          # All season data
├── src/
│   ├── assets/
│   │   └── main.css              # Global styles & design tokens
│   ├── components/
│   │   ├── AppHeader.vue         # Top nav with logo & season picker
│   │   ├── SearchBar.vue         # Player search input
│   │   ├── MetricTabs.vue        # RAPM / ORAPM / DRAPM tabs
│   │   ├── PlayerTable.vue       # Rankings data table
│   │   ├── PlayerAvatar.vue      # Player headshot with fallback
│   │   ├── PaginationBar.vue     # Page navigation
│   │   ├── StatCard.vue          # Stat display card
│   │   ├── TrendChart.vue        # Line chart (RAPM over seasons)
│   │   └── BreakdownChart.vue    # Bar chart with error bars
│   ├── views/
│   │   ├── RankingsView.vue      # Main rankings page
│   │   └── PlayerView.vue        # Player detail page
│   ├── router/
│   │   └── index.js              # Vue Router (hash mode)
│   ├── App.vue                   # Root component
│   └── main.js                   # App entry
├── scripts/
│   └── add_season.py             # CSV → JSON helper
├── .github/
│   └── workflows/
│       └── deploy.yml            # Auto-deploy to GitHub Pages
├── vite.config.js
├── package.json
└── README.md
```

## Tech Stack

- [Vue 3](https://vuejs.org/) with Composition API
- [Vue Router 4](https://router.vuejs.org/) (hash mode for GitHub Pages)
- [Vite 5](https://vitejs.dev/) build tool
- [Chart.js 4](https://www.chartjs.org/) for visualizations
- [Outfit](https://fonts.google.com/specimen/Outfit) + [JetBrains Mono](https://fonts.google.com/specimen/JetBrains+Mono) typography
