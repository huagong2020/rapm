# ============================================================
# convert_season.R
# Convert a RAPM CSV file to a per-season JSON file and
# update the seasons index for the RAPM Analytics website.
#
# Usage:
#   Rscript scripts/convert_season.R <csv_file> <season_label>
#
# Example:
#   Rscript scripts/convert_season.R data/df_result.csv "2024-25"
#   Rscript scripts/convert_season.R data/df_result_2023.csv "2023-24"
#
# Required package: jsonlite
#   install.packages("jsonlite")
# ============================================================

library(jsonlite)

# ---- Parse arguments ----
args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 2) {
  cat("Usage: Rscript scripts/convert_season.R <csv_file> <season_label>\n")
  cat("Example: Rscript scripts/convert_season.R data/df_result.csv \"2024-25\"\n")
  quit(status = 1)
}

csv_path <- args[1]
season_label <- '1997-98'

# ---- Paths ----
# Determine project root (assumes script is in scripts/)
# script_dir <- dirname(sys.frame(1)$ofile %||% ".")
# project_root <- file.path(script_dir, "..")
data_dir <- '/Users/hg37/Desktop/rapm/public/data' #file.path(project_root, "public", "data")

# Create data dir if needed
# if (!dir.exists(data_dir)) {
#   dir.create(data_dir, recursive = TRUE)
# }

# ---- Read CSV ----
df <- read.csv(paste0('/Users/hg37/Desktop/df_result',substr(season_label,1,4),'.csv'), stringsAsFactors = FALSE)

# ---- Clean player names (insert space before capitals) ----
clean_name <- function(name) {
  # Insert space between lowercase and uppercase: "AlexCaruso" -> "Alex Caruso"
  name <- gsub("([a-z])([A-Z])", "\\1 \\2", name)
  # Insert space between consecutive uppercase and uppercase+lowercase: "OGAnunoby" -> "OG Anunoby"
  name <- gsub("([A-Z]+)([A-Z][a-z])", "\\1 \\2", name)
  return(name)
}

# ---- Build player list ----
players <- data.frame(
  id      = as.integer(df$id),
  name    = sapply(df$Player, clean_name, USE.NAMES = FALSE),
  orapm   = round(df$off_rapm, 1),
  drapm   = round(df$def_rapm, 1),
  rapm    = round(df$total_rapm, 1),
  se_off  = round(df$se_off, 2),
  se_def  = round(df$se_def, 2),
  se_total = round(df$se_total, 2),
  stringsAsFactors = FALSE
)

# ---- Write per-season JSON ----
season_file <- file.path(data_dir, paste0(season_label, ".json"))
season_file
write_json(players, season_file, auto_unbox = TRUE, pretty = FALSE)
cat(sprintf("✓ Wrote %d players → %s\n", nrow(players), season_file))

# ---- Update seasons index ----
index_file <- file.path(data_dir, "seasons.json")

if (file.exists(index_file)) {
  existing_seasons <- fromJSON(index_file)
} else {
  existing_seasons <- character(0)
}

# Add new season if not already present
if (!(season_label %in% existing_seasons)) {
  updated_seasons <- sort(c(existing_seasons, season_label))
} else {
  updated_seasons <- sort(existing_seasons)
}

write_json(as.list(updated_seasons), index_file, auto_unbox = TRUE, pretty = FALSE)
cat(sprintf("✓ Updated season index: %s\n", paste(updated_seasons, collapse = ", ")))
cat("Done!\n")
