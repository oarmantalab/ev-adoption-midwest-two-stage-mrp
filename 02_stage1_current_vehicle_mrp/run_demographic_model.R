# =============================================================================
# run_demographic_model.R
# -----------------------------------------------------------------------------
# STAGE 1 - Fit the current-vehicle (demographic-only) MRP model
#
# Compiles demographic_model.stan with CmdStanR and draws posterior samples,
# then saves the fit object and a posterior summary table of the varying
# intercepts (r_*). Those summaries are consumed by poststratify_demographic.R.
#
# Input   : data/processed/demog_stan_data.rds   (list produced by
#                                                 produce_stan_data_demographic.R)
#           02_stage1_current_vehicle_mrp/demographic_model.stan
# Output  : outputs/fits/demographic_model.RDS
#           outputs/tables/summary_demographic_model.csv
#
# Run     : Rscript 02_stage1_current_vehicle_mrp/run_demographic_model.R
#
# Sampler settings reproduce the paper (4 chains / 400 iters, 200 warmup in the
# final run). The small warmup/sampling values below are a fast smoke-test;
# raise them for a production fit.
# =============================================================================

library(here)
source(here::here("config.R"))

library(cmdstanr)

## ---- 1. Load the model-ready Stan data list --------------------------------
data_list <- readRDS(file.path(DIR_DATA_PROCESSED, "demog_stan_data.rds"))

## ---- 2. Compile the Stan model ---------------------------------------------
model <- cmdstan_model(
  here::here("02_stage1_current_vehicle_mrp", "demographic_model.stan")
)

## ---- 3. Sample --------------------------------------------------------------
fit <- model$sample(
  data            = data_list,
  seed            = SEED,
  refresh         = 100,
  adapt_delta     = 0.95,
  iter_warmup     = 200,   # paper: 200
  iter_sampling   = 200,   # paper: 200 (x4 chains)
  chains          = 4,
  parallel_chains = 4
)

## ---- 4. Save the fit and a tidy summary of the random effects --------------
fit$save_object(file = file.path(DIR_FITS, "demographic_model.RDS"))

summ <- fit$summary()
write.csv(summ,
          file.path(DIR_TABLES, "summary_demographic_model.csv"),
          row.names = FALSE)
