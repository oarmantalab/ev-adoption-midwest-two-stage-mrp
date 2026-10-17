# =============================================================================
# config.R  --  Central configuration for the two-stage MRP EV-adoption pipeline
# =============================================================================
# Every R script in this repository sources this file instead of hard-coding
# absolute paths. Edit the paths below ONCE for your machine and all scripts
# will resolve their inputs/outputs relative to the project root.
#
# Usage inside a script:
#     source(here::here("config.R"))     # or source("../config.R")
#
# The project uses the `here` package so that scripts run correctly regardless
# of the working directory. If you prefer not to use `here`, set PROJECT_ROOT
# manually below.
# =============================================================================

## ---- Project root -----------------------------------------------------------
# `here::here()` locates the repository root by looking for the .here / .Rproj /
# .git marker. Install once with: install.packages("here")
if (requireNamespace("here", quietly = TRUE)) {
  PROJECT_ROOT <- here::here()
} else {
  # Fallback: set this to the absolute path of the repository root.
  PROJECT_ROOT <- normalizePath(".")
}

## ---- Standard sub-directories -----------------------------------------------
DIR_DATA_RAW       <- file.path(PROJECT_ROOT, "data", "raw")        # untouched source data
DIR_DATA_INTERIM   <- file.path(PROJECT_ROOT, "data", "interim")    # intermediate products
DIR_DATA_PROCESSED <- file.path(PROJECT_ROOT, "data", "processed")  # model-ready inputs
DIR_FITS           <- file.path(PROJECT_ROOT, "outputs", "fits")    # saved Stan fit objects (.RDS)
DIR_TABLES         <- file.path(PROJECT_ROOT, "outputs", "tables")  # posterior summaries (.csv)
DIR_FIGURES        <- file.path(PROJECT_ROOT, "outputs", "figures") # exported figures

## ---- Reproducibility --------------------------------------------------------
SEED <- 76544   # global RNG seed used across sampling scripts

## ---- Convenience: make sure output folders exist ----------------------------
for (d in c(DIR_DATA_INTERIM, DIR_DATA_PROCESSED, DIR_FITS, DIR_TABLES, DIR_FIGURES)) {
  if (!dir.exists(d)) dir.create(d, recursive = TRUE, showWarnings = FALSE)
}

# Multi-core Stan / brms by default
options(mc.cores = parallel::detectCores())
