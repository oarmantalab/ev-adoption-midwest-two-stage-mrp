# =============================================================================
# 01_experian_extract_counties.R
# -----------------------------------------------------------------------------
# STAGE 0 - Data preparation (Experian vehicle registration data)
#
# Purpose
#   Read the county-level Experian vehicle registration parquet file and extract
#   the unique list of (State Code, County Code, State Abbr, County Name). This
#   lookup is used downstream to restrict the vehicle data to the seven-state
#   Midwest study region (IA, KS, MN, MO, NE, ND, SD).
#
# Input   : data/raw/COUNTY_2021.parquet       (Experian registration extract)
# Output  : data/interim/county_lookup.csv
#
# Run     : Rscript 01_data_prep/01_experian_extract_counties.R
# =============================================================================

## ---- Load project configuration (edit paths once in config.R) --------------
library(here)                     # locates the repo root via the .here marker
source(here::here("config.R"))

library(arrow)
library(dplyr)

## ---- 1. Read the parquet file ----------------------------------------------
parquet_path <- file.path(DIR_DATA_RAW, "COUNTY_2021.parquet")
parquet_data <- read_parquet(parquet_path)
cat("Rows in parquet file:", nrow(parquet_data), "\n")

## ---- 2. Extract unique county identifiers ----------------------------------
county_lookup <- parquet_data %>%
  select(`State Code`, `County Code`, `State Abbr`, `County Name`) %>%
  distinct()

cat("Unique counties:", nrow(county_lookup), "\n")

## ---- 3. Write the lookup table ---------------------------------------------
write.csv(county_lookup,
          file.path(DIR_DATA_INTERIM, "county_lookup.csv"),
          row.names = FALSE)
