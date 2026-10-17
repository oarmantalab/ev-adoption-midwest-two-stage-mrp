# =============================================================================
# run_sce_model.R
# -----------------------------------------------------------------------------
# STAGE 2 - Fit the stated-choice (SCE) vehicle MRP model with joint
#           poststratification, and export the PUMA-level fleet forecast.
#
# Compiles sce_poststrat_model.stan with CmdStanR, samples, saves the fit, and
# writes the posterior summary of phi (the PUMA x alternative fleet shares that
# are the main result of the paper, Figs. 8-10).
#
# Input   : data/processed/sce_stan_data_withP.rds   (from build_poststrat_array.R)
#           04_stage2_sce_mrp/sce_poststrat_model.stan
# Output  : outputs/fits/sce_model.RDS
#           outputs/tables/summary_sce_model.csv
#
# Run     : Rscript 04_stage2_sce_mrp/run_sce_model.R
#
# To run a policy scenario (paper Fig. 11 B/C): rebuild P with N_VEHICLE = 12
# (build_poststrat_array.R) and point MODEL_FILE at sce_poststrat_model_policy.stan.
# =============================================================================

library(here)
source(here::here("config.R"))

library(cmdstanr)

MODEL_FILE <- here::here("04_stage2_sce_mrp", "sce_poststrat_model.stan")

## ---- 1. Load the model-ready Stan data (with P attached) --------------------
data_list <- readRDS(file.path(DIR_DATA_PROCESSED, "sce_stan_data_withP.rds"))

## ---- 2. Compile and sample --------------------------------------------------
# The generated-quantities poststratification loop is expensive, so the paper
# uses short chains (4 chains x 400 iters, 200 warmup). Increase for production.
model <- cmdstan_model(MODEL_FILE)

fit <- model$sample(
  data            = data_list,
  seed            = SEED,
  refresh         = 100,
  adapt_delta     = 0.95,
  iter_warmup     = 200,
  iter_sampling   = 200,
  chains          = 4,
  parallel_chains = 4
)

## ---- 3. Save the fit and the phi summary -----------------------------------
fit$save_object(file = file.path(DIR_FITS, "sce_model.RDS"))

summ <- fit$summary()
write.csv(summ, file.path(DIR_TABLES, "summary_sce_model.csv"), row.names = FALSE)

# Extract just the PUMA-level fleet shares (phi[pums, alternative]) into a tidy
# wide table (one row per PUMA, columns SG/SE/LG/LE/PG/PE) for the figure scripts.
library(dplyr)
library(tidyr)

alt_names <- c("SG", "SE", "LG", "LE", "PG", "PE")
phi <- summ %>%
  filter(grepl("^phi\\[", variable)) %>%
  transmute(
    pums = as.integer(sub("phi\\[(\\d+),(\\d+)\\]", "\\1", variable)),
    alt  = as.integer(sub("phi\\[(\\d+),(\\d+)\\]", "\\2", variable)),
    mean = mean
  )

if (nrow(phi) > 0) {
  wide <- phi %>%
    mutate(alt = alt_names[alt]) %>%
    pivot_wider(names_from = alt, values_from = mean) %>%
    rename(PUMS = pums) %>%
    arrange(PUMS)
  write.csv(wide, file.path(DIR_TABLES, "puma_fleet_shares.csv"), row.names = FALSE)
}
