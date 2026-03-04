#!/usr/bin/env python3
"""
Add a season's RAPM data to public/data/seasons.json.

Usage:
    python3 scripts/add_season.py <csv_file> <season_label>

Example:
    python3 scripts/add_season.py data/df_result_2023.csv "2023-24"
"""

import csv, json, re, sys, os

def clean_name(name):
    name = re.sub(r'([a-z])([A-Z])', r'\1 \2', name)
    name = re.sub(r'([A-Z]+)([A-Z][a-z])', r'\1 \2', name)
    return name

def main():
    if len(sys.argv) != 3:
        print("Usage: python3 scripts/add_season.py <csv_file> <season_label>")
        sys.exit(1)

    csv_path, season = sys.argv[1], sys.argv[2]
    json_path = os.path.join(os.path.dirname(__file__), '..', 'public', 'data', 'seasons.json')

    players = []
    with open(csv_path) as f:
        for row in csv.DictReader(f):
            players.append({
                'id': int(row['id']),
                'name': clean_name(row['Player']),
                'orapm': round(float(row['off_rapm']), 2),
                'drapm': round(float(row['def_rapm']), 2),
                'rapm': round(float(row['total_rapm']), 2),
                'se_off': round(float(row['se_off']), 2),
                'se_def': round(float(row['se_def']), 2),
                'se_total': round(float(row['se_total']), 2),
            })

    data = {}
    if os.path.exists(json_path):
        with open(json_path) as f:
            data = json.load(f)

    data[season] = players
    with open(json_path, 'w') as f:
        json.dump(data, f)

    print(f"✓ Added {len(players)} players for '{season}' → {json_path}")

if __name__ == '__main__':
    main()
