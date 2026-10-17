# =============================================================================
# poststratify_demographic.R
# -----------------------------------------------------------------------------
# STAGE 1 - Poststratify the demographic current-vehicle model
#
# For every cell of the census poststratification table, reconstruct the linear
# predictor of each vehicle type from the fitted varying intercepts, apply the
# softmax, and write the resulting 12 vehicle-type probabilities. These per-cell
# probabilities (new_post.csv, columns col_1..col_12) are the ROW targets that
# the IPF step (Stage 1b) reconciles against the Experian PUMA marginals.
#
# Inputs
#   outputs/tables/summary_demographic_model.csv   posterior means of the
#                                                   intercepts (b_mu*_Intercept)
#                                                   and random effects (r_*_mu*_1)
#   data/processed/dem_poststrat.csv                census cells with columns:
#                                                   pums_idx, metro, sex, agec,
#                                                   educ, age_educ, inc, educ_age,
#                                                   perwt
# Output
#   data/interim/new_post.csv                       cells + col_1..col_12 probs
#
# Convention (see demographic_model.stan header)
#   category c (c = 2..12) uses groups r_{(c-2)*7+1 .. (c-2)*7+7} in factor order
#   [agec, educ_age, educ, inc, metro, pums_idx, sex]. Category 1 is the
#   reference with utility 0.
#
# Run     : Rscript 02_stage1_current_vehicle_mrp/poststratify_demographic.R
# =============================================================================

library(here)
source(here::here("config.R"))

## ---- 1. Load fitted summary and poststratification cells --------------------
fit  <- read.csv(file.path(DIR_TABLES, "summary_demographic_model.csv"),
                 stringsAsFactors = FALSE)
post <- read.csv(file.path(DIR_DATA_PROCESSED, "dem_poststrat.csv"),
                 stringsAsFactors = FALSE)

# Helper: posterior mean of a named Stan variable
mean_of <- function(varname) {
  val <- fit$mean[fit$variable == varname]
  if (length(val) == 0) return(0)      # factor level with no fitted effect -> 0
  val[1]
}

## ---- 2. Factor columns in the fixed order expected by the model ------------
# Order MUST match the model's grouping-factor order within each category.
factor_cols <- c("agec", "educ_age", "educ", "inc", "metro", "pums_idx", "sex")

n_categories <- 12                       # categories 2..12 modelled, 1 = reference
groups_per_cat <- length(factor_cols)    # 7

## ---- 3. Build the utility for each category, for every cell -----------------
# Utility of category c for a cell = Intercept_c + sum over the 7 factor levels
# of the corresponding random-effect posterior mean.
util <- matrix(0, nrow = nrow(post), ncol = n_categories)   # column 1 stays 0 (ref)

for (c in 2:n_categories) {
  intercept_c <- mean_of(sprintf("b_mu%d_Intercept", c))
  base_idx    <- (c - 2) * groups_per_cat                   # r-index offset

  util_c <- rep(intercept_c, nrow(post))
  for (j in seq_along(factor_cols)) {
    r_id  <- base_idx + j                                    # which r_*_mu c _1 group
    level <- post[[factor_cols[j]]]                          # level index per cell
    reff  <- vapply(level,
                    function(l) mean_of(sprintf("r_%d_mu%d_1[%d]", r_id, c, l)),
                    numeric(1))
    util_c <- util_c + reff
  }
  util[, c] <- util_c
}

## ---- 4. Softmax to probabilities col_1..col_12 -----------------------------
softmax_rows <- function(m) {
  m <- m - apply(m, 1, max)             # numerical stability
  e <- exp(m)
  e / rowSums(e)
}
probs <- softmax_rows(util)
colnames(probs) <- paste0("col_", seq_len(n_categories))

## ---- 5. Write the per-cell vehicle-type probability table ------------------
new_post <- cbind(post, probs)
write.csv(new_post, file.path(DIR_DATA_INTERIM, "new_post.csv"), row.names = FALSE)
