# =============================================================================
# 02_experian_recode_vehicle.R
# -----------------------------------------------------------------------------
# STAGE 0 - Data preparation (Experian vehicle registration data)
#
# Purpose
#   Collapse the very granular Experian vehicle descriptions into the three
#   vehicle classes and four powertrains used throughout the study, so that the
#   registration data is directly comparable to the stated-choice alternatives.
#
#     Vehicle class : SmallCar | LargeCar | Pickup
#     Powertrain    : ICE | HEV | PHEV | BEV
#
# Input   : data/raw/VC_i_output.csv        (Experian records; must contain the
#                                            columns `Vehicle` and `Vehicle_f`)
# Output  : data/interim/updated_data.csv
#
# Run     : Rscript 01_data_prep/02_experian_recode_vehicle.R
# =============================================================================

library(here)
source(here::here("config.R"))

library(dplyr)

## ---- 1. Read the raw registration records ----------------------------------
data <- read.csv(file.path(DIR_DATA_RAW, "VC_i_output.csv"))

## ---- 2. Vehicle-class crosswalks -------------------------------------------
# Experian uses dozens of fine-grained body styles. We map them to the three
# classes shown to survey respondents (small car, large car, pickup truck).
small_car_mapping <- c(
  "Sport Car - Subcompact Luxury", "Sport Car - Subcompact Exotic", "Sport Car - Subcompact",
  "Sport Car - Midsize", "Sport Car - Compact", "Car - Compact", "Car - Compact Exotic",
  "Car - Compact Luxury", "Car - Micro", "Car - Midsize", "Car - Midsize Exotic",
  "Car - Midsize Luxury", "Car - Subcompact", "Car - Subcompact Luxury",
  "Sport Car - Compact Exotic", "Sport Car - Compact Luxury", "Sport Car - Midsize Exotic",
  "Sport Car - Midsize Luxury"
)

large_car_mapping <- c(
  "CUV - Compact", "Van - Full Sized", "Van - Fullsize", "Van - Fullsize Luxury",
  "Van - Mini", "Van - Mini Luxury", "Sport Car - Large Exotic", "Sport Car - Large",
  "Sport Car - Large Luxury", "Car - Large", "Car - Large Exotic", "Car - Large Luxury",
  "CUV - Compact Exotic", "CUV - Compact Luxury", "CUV - Large", "CUV - Large Exotic",
  "CUV - Large Luxury", "CUV - Midsize", "CUV - Midsize Luxury", "CUV - Subcompact",
  "SUV - Compact", "SUV - Compact Luxury", "SUV - Large", "SUV - Large Luxury",
  "SUV - Midsize", "SUV - Midsize Exotic", "SUV - Midsize Luxury", "SUV - Subcompact",
  "CUV - Subcompact Exotic"
)

pickup_mapping <- c(
  "Pickup - Compact", "Pickup - Fullsize", "Pickup - Fullsize Luxury", "Pickup - Midsize"
)

## ---- 3. Powertrain crosswalk ------------------------------------------------
ice_fuels <- c(
  "Biodiesel", "CNG", "CNG~Flex~Gasoline", "CNG~Gasoline", "CNG~LPG~Gasoline",
  "Diesel", "Diesel~Gasoline", "E85~Flex~Gasoline", "Ethanol", "Flex",
  "Flex Fuel", "Flex Fuel~Gasoline", "Flex~Gasoline", "Flex~Gasoline/E85/CNG/LPG",
  "GFP", "Gas/Electric Hybrid", "Gasoline", "Gasoline Hybrid", "Gasoline Hybrid~Gasoline",
  "Gasoline/LPG", "Gasoline~Natural Gas", "LPG", "LPG~Gasoline", "Methanol",
  "Natural Gas", "Natural Gas/Propane", "Propane"
)

## ---- 4. Apply the recodes ---------------------------------------------------
data <- data %>%
  mutate(
    Vehicle = case_when(
      Vehicle %in% small_car_mapping ~ "SmallCar",
      Vehicle %in% large_car_mapping ~ "LargeCar",
      Vehicle %in% pickup_mapping    ~ "Pickup",
      TRUE                           ~ Vehicle
    ),
    Vehicle_f = case_when(
      Vehicle_f %in% ice_fuels                                             ~ "ICE",
      Vehicle_f %in% c("Hydrogen Fuel Cell", "Plug-In Hybrid",
                       "Plug-in Gas/Electric Hybrid")                      ~ "PHEV",
      Vehicle_f == "Electric"                                             ~ "BEV",
      Vehicle_f %in% c("Electric with Gas Generator",
                       "Electric~Gasoline Hybrid")                        ~ "HEV",
      TRUE                                                                 ~ Vehicle_f
    )
  )

## ---- 5. Write the recoded data ---------------------------------------------
write.csv(data, file.path(DIR_DATA_INTERIM, "updated_data.csv"), row.names = FALSE)
