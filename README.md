# 🏀 RAPM Analytics

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

## Deploy to GitHub Pages

### Option 1: GitHub Actions (recommended)

1. Create a new repo on GitHub named `rapm-analytics`
2. Push this project:
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/rapm-analytics.git
   git push -u origin main
   ```
3. In your repo, go to **Settings → Pages**
4. Under **Source**, select **GitHub Actions**
5. The included `.github/workflows/deploy.yml` will auto-build and deploy on every push
6. Your site will be live at `https://YOUR_USERNAME.github.io/rapm-analytics/`

### Option 2: Manual deploy

```bash
npm run build
npx gh-pages -d dist
```

> **Important**: Update `base` in `vite.config.js` to match your repo name:
> ```js
> base: '/your-repo-name/'
> ```

## Adding New Seasons

```bash
python3 scripts/add_season.py path/to/new_season.csv "2023-24"
```

This merges the new season into `public/data/seasons.json`. The CSV must have these columns:
`player, off_rapm, def_rapm, total_rapm, se_off, se_def, se_total, cov_off_def, id, Player`

After adding, commit and push — the site auto-redeploys.

## Project Structure

```
rapm-analytics/
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
