# =============================================================================
# produce_stan_data_demographic.R
# -----------------------------------------------------------------------------
# STAGE 1 - Build the Stan data list for the demographic current-vehicle model
#
# Same idea as 04_stage2_sce_mrp/produce_stan_data.R, but the outcome is the
# respondent's CURRENT vehicle type (12 categories) and the right-hand side
# contains demographics ONLY (no stated-choice attributes). brms is used just to
# assemble the design matrices / grouping indices; its draws are discarded.
#
# Input   : data/processed/model_ev_data.csv   (must contain `current_vehicle`
#                                                coded 1..12 plus the demographic
#                                                columns below)
# Output  : data/processed/demog_stan_data.rds (list consumed by
#                                                run_demographic_model.R)
#
# NOTE: adjust the outcome column name / formula to match your data. The grouping
# factors and their order must match demographic_model.stan.
#
# Run     : Rscript 02_stage1_current_vehicle_mrp/produce_stan_data_demographic.R
# =============================================================================

library(here)
source(here::here("config.R"))

library(tidyverse)
library(brms)

## ---- 1. Read survey data and keep the demographic columns ------------------
dat <- read_csv(file.path(DIR_DATA_PROCESSED, "model_ev_data.csv")) %>%
  rename(sex = gender, inc = inc_idx) %>%
  mutate(across(c(current_vehicle, sex, pums_idx, educ, metro, inc, agec, educ_age),
                as.character))

## ---- 2. Demographic-only categorical model (12 current-vehicle types) ------
formula <- bf(
  current_vehicle ~ 1 + (1 | sex) + (1 | pums_idx) + (1 | educ) + (1 | metro) +
    (1 | inc) + (1 | agec) + (1 | educ_age)
)

brms_skeleton <- brm(
  data    = dat,
  family  = categorical(refcat = "1"),
  formula = formula,
  chains  = 1, iter = 2, warmup = 1, seed = SEED,
  control = list(adapt_delta = 0.95)
)

## ---- 3. Export the Stan data list ------------------------------------------
stan_data <- standata(brms_skeleton)
saveRDS(stan_data, file.path(DIR_DATA_PROCESSED, "demog_stan_data.rds"))
