# =============================================================================
# 03_experian_aggregate_shares.R
# -----------------------------------------------------------------------------
# STAGE 0 - Data preparation (Experian vehicle registration data)
#
# Purpose
#   Aggregate the recoded registration records to PUMA level and express the
#   vehicle fleet as the share of each of the 12 vehicle types
#   (3 classes x 4 powertrains). These PUMA-level marginal shares (type1..type12)
#   are the column targets that the IPF step (Stage 1b) fits the demographic
#   poststratification table to.
#
# Input   : data/interim/updated_data.csv          (from script 02)
#           data/interim/county_lookup.csv          (from script 01, optional
#                                                     filter to the study region)
# Output  : data/interim/new2.csv                   (PUMA x type1..type12 shares)
#
# NOTE on type ordering
#   type1..type12 MUST be in the SAME order as the 12 vehicle-type columns of
#   the demographic MRP output (new_post.csv, columns 9:21). The factor order
#   below defines that mapping explicitly - adjust it if your new_post.csv uses
#   a different ordering.
#
# Run     : Rscript 01_data_prep/03_experian_aggregate_shares.R
# =============================================================================

library(here)
source(here::here("config.R"))

library(dplyr)
library(tidyr)

## ---- 1. Read recoded data ---------------------------------------------------
dat <- read.csv(file.path(DIR_DATA_INTERIM, "updated_data.csv"))

# Optional: restrict to the seven-state study region using the county lookup.
# county <- read.csv(file.path(DIR_DATA_INTERIM, "county_lookup.csv"))
# dat <- dat[dat$id %in% county$id, ]

## ---- 2. Define the canonical 12 vehicle-type ordering ----------------------
# 3 classes x 4 powertrains. Keep this identical to the demographic model output.
dat <- dat %>%
  mutate(
    vehicle_type = paste(Vehicle, Vehicle_f, sep = "_"),
    vehicle_type = factor(
      vehicle_type,
      levels = c(
        "SmallCar_ICE", "SmallCar_HEV", "SmallCar_PHEV", "SmallCar_BEV",
        "LargeCar_ICE", "LargeCar_HEV", "LargeCar_PHEV", "LargeCar_BEV",
        "Pickup_ICE",   "Pickup_HEV",   "Pickup_PHEV",   "Pickup_BEV"
      )
    )
  )

## ---- 3. Count registrations by PUMA x vehicle type -------------------------
counts <- dat %>%
  group_by(pums, vehicle_type, .drop = FALSE) %>%
  summarise(count = sum(count), .groups = "drop")

## ---- 4. Pivot to wide type1..type12 and convert to within-PUMA shares ------
shares <- counts %>%
  tidyr::pivot_wider(names_from = vehicle_type, values_from = count, values_fill = 0) %>%
  rowwise() %>%
  mutate(total = sum(c_across(-pums))) %>%
  ungroup()

# Normalise each type column to a share of the PUMA total, rename to type1..type12
type_cols <- setdiff(names(shares), c("pums", "total"))
shares_out <- shares %>%
  mutate(across(all_of(type_cols), ~ .x / total)) %>%
  select(pums, all_of(type_cols))

names(shares_out) <- c("pums", paste0("type", seq_along(type_cols)))

## ---- 5. Write PUMA-level marginal shares -----------------------------------
write.csv(shares_out, file.path(DIR_DATA_INTERIM, "new2.csv"), row.names = FALSE)
