# =============================================================================
# produce_stan_data.R
# -----------------------------------------------------------------------------
# STAGE 2 - Build the Stan data list for the stated-choice (SCE) vehicle model
#
# brms is used ONLY to construct the design matrices, grouping indices and
# standardised data that the custom Stan model (sce_poststrat_model.stan)
# consumes. We fit brms for a trivial number of iterations (its draws are
# discarded) and then call standata() to export the data list. The poststrati-
# fication array P is attached separately by build_poststrat_array.R.
#
# Input   : data/processed/model_ev_data.csv   (long SCE data; one row per
#                                                respondent x choice task)
# Output  : data/processed/sce_stan_data.rds   (list for cmdstanr)
#
# Run     : Rscript 04_stage2_sce_mrp/produce_stan_data.R
# =============================================================================

library(here)
source(here::here("config.R"))

library(tidyverse)
library(brms)

## ---- 1. Read the SCE survey data -------------------------------------------
ev_data1 <- read_csv(file.path(DIR_DATA_PROCESSED, "model_ev_data.csv"))

## ---- 2. Select the variables used by the model -----------------------------
# Continuous alternative attributes (kept numeric); everything else is treated
# as a categorical grouping variable.
numeric_attrs <- c(
  "sg_price","sg_costper100mi","sg_ancost","sg_range",
  "se_price","se_incen","se_costper100mi","se_ancost","se_refutst","se_refutho","se_rangee",
  "lg_price","lg_costper100mi","lg_ancost","lg_range","lg_towcap",
  "le_price","le_incen","le_costper100mi","le_ancost","le_refutst","le_refutho","le_rangee","le_towcap",
  "tg_price","tg_costper100mi","tg_ancost","tg_range","tg_towcap",
  "te_price","te_incen","te_costper100mi","te_ancost","te_refutst","te_refutho","te_rangee","te_towcap","te_onboardcap"
)

ev_data <- ev_data1 %>%
  select(p_weights, pums, metro, gender, agec, educ, inc_idx, choice, CUID,
         all_of(numeric_attrs)) %>%
  rename(sex = gender, inc = inc_idx) %>%
  # make every non-attribute column a character factor for brms grouping terms
  mutate_at(vars(-one_of(numeric_attrs)),
            ~ if (is.double(.)) as.character(.) else .)

## ---- 3. Rescale attributes so coefficients are well-conditioned ------------
# (prices in $10k, annual costs in $1k, range in 100s of miles, etc.)
ev_data <- ev_data %>%
  mutate(
    across(c(sg_price, se_price, lg_price, le_price, tg_price, te_price),  ~ . * 1e-4),
    across(c(sg_ancost, se_ancost, lg_ancost, le_ancost, tg_ancost, te_ancost), ~ . * 1e-3),
    across(c(sg_range, se_rangee, lg_range, le_rangee, tg_range, te_rangee), ~ . * 1e-2),
    across(c(se_incen, le_incen, te_incen),  ~ . * 1e-3),
    across(c(lg_towcap, le_towcap, tg_towcap, te_towcap), ~ . * 1e-3)
  )

## ---- 4. Specify the categorical model (design matrices only) ---------------
# Random intercepts for each poststratification factor + the shared attribute
# fixed effects. Iterations are deliberately tiny: we only need standata().
formula <- bf(
  choice ~ 1 + (1 | sex) + (1 | pums_idx) + (1 | educ) + (1 | metro) +
    (1 | inc) + (1 | agec) + (1 | educ_age) +
    sg_price + sg_costper100mi + se_price + se_costper100mi +
    lg_price + lg_costper100mi + le_price + le_costper100mi +
    tg_price + tg_costper100mi + te_price + te_costper100mi +
    se_incen + le_incen + te_incen + se_refutst + le_refutst + te_refutst
)

brms_skeleton <- brm(
  data    = ev_data,
  family  = categorical(refcat = "1"),
  formula = formula,
  prior   = c(prior(exponential(1), class = sd, dpar = mu2),
              prior(exponential(1), class = sd, dpar = mu3),
              prior(exponential(1), class = sd, dpar = mu4),
              prior(exponential(1), class = sd, dpar = mu5),
              prior(exponential(1), class = sd, dpar = mu6)),
  chains  = 1, iter = 2, warmup = 1, seed = SEED,
  control = list(adapt_delta = 0.97)
)

## ---- 5. Export the Stan data list ------------------------------------------
stan_data <- standata(brms_skeleton)
saveRDS(stan_data, file.path(DIR_DATA_PROCESSED, "sce_stan_data.rds"))

# The exported Stan code (brms version) can be inspected with:
#   stancode(brms_skeleton)
# The paper's custom model (sce_poststrat_model.stan) is that code plus the
# sign-constrained attribute coefficients and the poststratification block.
