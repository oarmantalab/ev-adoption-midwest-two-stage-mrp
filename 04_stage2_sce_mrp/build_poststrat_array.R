# =============================================================================
# build_poststrat_array.R
# -----------------------------------------------------------------------------
# STAGE 2 - Build the joint poststratification array P and attach it to the
#           Stan data list for the SCE model.
#
# The Stage-2 model poststratifies over a JOINT table that crosses the seven
# demographic dimensions with the household's current vehicle type. This script
# fills the integer array P that sce_poststrat_model.stan expects, using the
# IPF-reconciled cell counts from Stage 1b.
#
# IMPORTANT - the dimension order of P must match the Stan declaration exactly:
#     P[pums, metro, sex, age, educ, educ_age, income, vehicle]
#          111     5     2    7     4      28       12     <n_vehicle>
#   sce_poststrat_model.stan        expects <n_vehicle> = 6
#   sce_poststrat_model_policy.stan expects <n_vehicle> = 12
#   Set N_VEHICLE below to match the model you intend to fit.
#
# Inputs
#   data/interim/new_post.csv                 cell demographic indices + perwt
#   data/interim/joint_poststrat_table.csv    IPF-reconciled counts (col_1..12)
#                                             aligned row-for-row with new_post
#   data/processed/sce_stan_data.rds          Stan data list from produce_stan_data.R
# Output
#   data/processed/sce_stan_data_withP.rds    Stan data list with P attached
#
# Run     : Rscript 04_stage2_sce_mrp/build_poststrat_array.R
# =============================================================================

library(here)
source(here::here("config.R"))

## ---- Settings ---------------------------------------------------------------
N_VEHICLE <- 6   # 6 for sce_poststrat_model.stan, 12 for the policy variant

# Dimension sizes in the exact order P is indexed in the Stan model.
DIMS <- c(pums = 111, metro = 5, sex = 2, age = 7, educ = 4,
          educ_age = 28, income = 12, vehicle = N_VEHICLE)

# When collapsing the 12 IPF vehicle types to the 6 SCE alternatives, map
# powertrains HEV/PHEV/BEV -> electric. Order within each class: ICE,HEV,PHEV,BEV.
#   1 SmallICE 2 SmallHEV 3 SmallPHEV 4 SmallBEV
#   5 LargeICE 6 LargeHEV 7 LargePHEV 8 LargeBEV
#   9 PickICE 10 PickHEV 11 PickPHEV 12 PickBEV
#   -> 6 levels: 1 SmallGas 2 SmallElec 3 LargeGas 4 LargeElec 5 PickGas 6 PickElec
collapse_12_to_6 <- c(1,2,2,2, 3,4,4,4, 5,6,6,6)

## ---- 1. Load inputs ---------------------------------------------------------
cells <- read.csv(file.path(DIR_DATA_INTERIM, "new_post.csv"))
joint <- read.csv(file.path(DIR_DATA_INTERIM, "joint_poststrat_table.csv"))
stan_data <- readRDS(file.path(DIR_DATA_PROCESSED, "sce_stan_data.rds"))

stopifnot(nrow(cells) == nrow(joint))   # rows must align 1:1

type_cols <- paste0("col_", 1:12)
counts12  <- as.matrix(joint[, type_cols])

## ---- 2. Collapse vehicle types if the model uses 6 levels ------------------
if (N_VEHICLE == 6) {
  counts <- sapply(1:6, function(v) rowSums(counts12[, collapse_12_to_6 == v, drop = FALSE]))
} else {
  counts <- counts12
}

## ---- 3. Allocate and populate the integer array ----------------------------
P <- array(0L, dim = unname(DIMS))

for (r in seq_len(nrow(cells))) {
  idx <- c(cells$pums_idx[r], cells$metro[r], cells$sex[r], cells$agec[r],
           cells$educ[r], cells$educ_age[r], cells$inc[r])
  # guard against any index exceeding the declared dimension
  if (any(idx > DIMS[1:7]) || any(idx < 1)) next
  for (v in seq_len(N_VEHICLE)) {
    P[idx[1], idx[2], idx[3], idx[4], idx[5], idx[6], idx[7], v] <-
      P[idx[1], idx[2], idx[3], idx[4], idx[5], idx[6], idx[7], v] +
      as.integer(round(counts[r, v]))
  }
}

## ---- 4. Attach P to the Stan data list and save ----------------------------
stan_data$P <- P
saveRDS(stan_data, file.path(DIR_DATA_PROCESSED, "sce_stan_data_withP.rds"))
cat("Attached P with dims:", paste(dim(P), collapse = " x "), "\n")
