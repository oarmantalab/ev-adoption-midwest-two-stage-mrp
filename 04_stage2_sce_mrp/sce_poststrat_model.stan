// =============================================================================
// sce_poststrat_model.stan
// -----------------------------------------------------------------------------
// STAGE 2  -  Stated-choice (SCE) vehicle MRP model with joint poststratification
//
// The main model of the paper. A Bayesian multinomial (categorical-logit) choice
// model over the 6 stated-choice alternatives:
//   1 Small Gas (ref) | 2 Small BEV | 3 Large Gas | 4 Large BEV
//   5 Pickup Gas       | 6 Pickup BEV
//
// Fixed effects (shared, sign-constrained via lognormal priors):
//   b_price  purchase price          b_cost   fuel cost / 100 mi
//   b_incen  purchase incentive      b_refust recharging time at station
// Varying intercepts for 8 grouping factors: PUMA, metro, sex, age, education,
// education:age, income, and current vehicle type (the extra dimension that makes
// this the *two-stage* / joint poststratification model).
//
// Generated quantities:
//   phi[N_6, 6]   posterior PUMA-level fleet share of each alternative, formed by
//                 summing softmax utilities over the JOINT poststratification
//                 table P and dividing by the PUMA population total.
//
//   P[111,5,2,7,4,28,12,6]  joint cell counts indexed by
//                 [pums, metro, sex, age, educ, educ_age, income, current_vehicle]
//                 (built by 04_stage2_sce_mrp/build_poststrat_array.R from the
//                  IPF-reconciled joint table produced in Stage 1b).
//
// This file is brms-generated Stan code with a hand-written generated-quantities
// poststratification block. The body is kept verbatim so the fit reproduces the
// paper exactly; only this header was added.
// =============================================================================

// generated with brms 2.20.4
functions {
}
data {
  int<lower=1> N;  // total number of observations
  int<lower=2> ncat;  // number of categories
  array[N] int Y;  // response variable

  matrix[N, 3] X_mu1;  // population-level design matrix
  int<lower=1> K_mu2;  // number of population-level effects
  matrix[N, 5] X_mu2;  // population-level design matrix
  int<lower=1> K_mu3;  // number of population-level effects
  matrix[N, 3] X_mu3;  // population-level design matrix
  int<lower=1> K_mu4;  // number of population-level effects
  matrix[N, 5] X_mu4;  // population-level design matrix
  int<lower=1> K_mu5;  // number of population-level effects
  matrix[N, 3] X_mu5;  // population-level design matrix
  int<lower=1> K_mu6;  // number of population-level effects
  matrix[N, 5] X_mu6;  // population-level design matrix


  // data for group-level effects of ID 1
  int<lower=1> N_1;  // number of grouping levels
  int<lower=1> M_1;  // number of coefficients per level
  array[N] int<lower=1> J_1;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_1_mu2_1;
  // data for group-level effects of ID 2
  int<lower=1> N_2;  // number of grouping levels
  int<lower=1> M_2;  // number of coefficients per level
  array[N] int<lower=1> J_2;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_2_mu2_1;
  // data for group-level effects of ID 3
  int<lower=1> N_3;  // number of grouping levels
  int<lower=1> M_3;  // number of coefficients per level
  array[N] int<lower=1> J_3;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_3_mu2_1;
  // data for group-level effects of ID 4
  int<lower=1> N_4;  // number of grouping levels
  int<lower=1> M_4;  // number of coefficients per level
  array[N] int<lower=1> J_4;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_4_mu2_1;
  // data for group-level effects of ID 5
  int<lower=1> N_5;  // number of grouping levels
  int<lower=1> M_5;  // number of coefficients per level
  array[N] int<lower=1> J_5;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_5_mu2_1;
  // data for group-level effects of ID 6
  int<lower=1> N_6;  // number of grouping levels
  int<lower=1> M_6;  // number of coefficients per level
  array[N] int<lower=1> J_6;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_6_mu2_1;
  // data for group-level effects of ID 7
  int<lower=1> N_7;  // number of grouping levels
  int<lower=1> M_7;  // number of coefficients per level
  array[N] int<lower=1> J_7;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_7_mu2_1;
  // data for group-level effects of ID 8
  int<lower=1> N_8;  // number of grouping levels
  int<lower=1> M_8;  // number of coefficients per level
  array[N] int<lower=1> J_8;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_8_mu2_1;
  // data for group-level effects of ID 9
  int<lower=1> N_9;  // number of grouping levels
  int<lower=1> M_9;  // number of coefficients per level
  array[N] int<lower=1> J_9;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_9_mu3_1;
  // data for group-level effects of ID 10
  int<lower=1> N_10;  // number of grouping levels
  int<lower=1> M_10;  // number of coefficients per level
  array[N] int<lower=1> J_10;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_10_mu3_1;
  // data for group-level effects of ID 11
  int<lower=1> N_11;  // number of grouping levels
  int<lower=1> M_11;  // number of coefficients per level
  array[N] int<lower=1> J_11;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_11_mu3_1;
  // data for group-level effects of ID 12
  int<lower=1> N_12;  // number of grouping levels
  int<lower=1> M_12;  // number of coefficients per level
  array[N] int<lower=1> J_12;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_12_mu3_1;
  // data for group-level effects of ID 13
  int<lower=1> N_13;  // number of grouping levels
  int<lower=1> M_13;  // number of coefficients per level
  array[N] int<lower=1> J_13;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_13_mu3_1;
  // data for group-level effects of ID 14
  int<lower=1> N_14;  // number of grouping levels
  int<lower=1> M_14;  // number of coefficients per level
  array[N] int<lower=1> J_14;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_14_mu3_1;
  // data for group-level effects of ID 15
  int<lower=1> N_15;  // number of grouping levels
  int<lower=1> M_15;  // number of coefficients per level
  array[N] int<lower=1> J_15;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_15_mu3_1;
  // data for group-level effects of ID 16
  int<lower=1> N_16;  // number of grouping levels
  int<lower=1> M_16;  // number of coefficients per level
  array[N] int<lower=1> J_16;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_16_mu3_1;
  // data for group-level effects of ID 17
  int<lower=1> N_17;  // number of grouping levels
  int<lower=1> M_17;  // number of coefficients per level
  array[N] int<lower=1> J_17;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_17_mu4_1;
  // data for group-level effects of ID 18
  int<lower=1> N_18;  // number of grouping levels
  int<lower=1> M_18;  // number of coefficients per level
  array[N] int<lower=1> J_18;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_18_mu4_1;
  // data for group-level effects of ID 19
  int<lower=1> N_19;  // number of grouping levels
  int<lower=1> M_19;  // number of coefficients per level
  array[N] int<lower=1> J_19;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_19_mu4_1;
  // data for group-level effects of ID 20
  int<lower=1> N_20;  // number of grouping levels
  int<lower=1> M_20;  // number of coefficients per level
  array[N] int<lower=1> J_20;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_20_mu4_1;
  // data for group-level effects of ID 21
  int<lower=1> N_21;  // number of grouping levels
  int<lower=1> M_21;  // number of coefficients per level
  array[N] int<lower=1> J_21;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_21_mu4_1;
  // data for group-level effects of ID 22
  int<lower=1> N_22;  // number of grouping levels
  int<lower=1> M_22;  // number of coefficients per level
  array[N] int<lower=1> J_22;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_22_mu4_1;
  // data for group-level effects of ID 23
  int<lower=1> N_23;  // number of grouping levels
  int<lower=1> M_23;  // number of coefficients per level
  array[N] int<lower=1> J_23;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_23_mu4_1;
  // data for group-level effects of ID 24
  int<lower=1> N_24;  // number of grouping levels
  int<lower=1> M_24;  // number of coefficients per level
  array[N] int<lower=1> J_24;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_24_mu4_1;
  // data for group-level effects of ID 25
  int<lower=1> N_25;  // number of grouping levels
  int<lower=1> M_25;  // number of coefficients per level
  array[N] int<lower=1> J_25;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_25_mu5_1;
  // data for group-level effects of ID 26
  int<lower=1> N_26;  // number of grouping levels
  int<lower=1> M_26;  // number of coefficients per level
  array[N] int<lower=1> J_26;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_26_mu5_1;
  // data for group-level effects of ID 27
  int<lower=1> N_27;  // number of grouping levels
  int<lower=1> M_27;  // number of coefficients per level
  array[N] int<lower=1> J_27;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_27_mu5_1;
  // data for group-level effects of ID 28
  int<lower=1> N_28;  // number of grouping levels
  int<lower=1> M_28;  // number of coefficients per level
  array[N] int<lower=1> J_28;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_28_mu5_1;
  // data for group-level effects of ID 29
  int<lower=1> N_29;  // number of grouping levels
  int<lower=1> M_29;  // number of coefficients per level
  array[N] int<lower=1> J_29;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_29_mu5_1;
  // data for group-level effects of ID 30
  int<lower=1> N_30;  // number of grouping levels
  int<lower=1> M_30;  // number of coefficients per level
  array[N] int<lower=1> J_30;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_30_mu5_1;
  // data for group-level effects of ID 31
  int<lower=1> N_31;  // number of grouping levels
  int<lower=1> M_31;  // number of coefficients per level
  array[N] int<lower=1> J_31;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_31_mu5_1;
  // data for group-level effects of ID 32
  int<lower=1> N_32;  // number of grouping levels
  int<lower=1> M_32;  // number of coefficients per level
  array[N] int<lower=1> J_32;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_32_mu5_1;
  // data for group-level effects of ID 33
  int<lower=1> N_33;  // number of grouping levels
  int<lower=1> M_33;  // number of coefficients per level
  array[N] int<lower=1> J_33;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_33_mu6_1;
  // data for group-level effects of ID 34
  int<lower=1> N_34;  // number of grouping levels
  int<lower=1> M_34;  // number of coefficients per level
  array[N] int<lower=1> J_34;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_34_mu6_1;
  // data for group-level effects of ID 35
  int<lower=1> N_35;  // number of grouping levels
  int<lower=1> M_35;  // number of coefficients per level
  array[N] int<lower=1> J_35;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_35_mu6_1;
  // data for group-level effects of ID 36
  int<lower=1> N_36;  // number of grouping levels
  int<lower=1> M_36;  // number of coefficients per level
  array[N] int<lower=1> J_36;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_36_mu6_1;
  // data for group-level effects of ID 37
  int<lower=1> N_37;  // number of grouping levels
  int<lower=1> M_37;  // number of coefficients per level
  array[N] int<lower=1> J_37;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_37_mu6_1;
  // data for group-level effects of ID 38
  int<lower=1> N_38;  // number of grouping levels
  int<lower=1> M_38;  // number of coefficients per level
  array[N] int<lower=1> J_38;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_38_mu6_1;
  // data for group-level effects of ID 39
  int<lower=1> N_39;  // number of grouping levels
  int<lower=1> M_39;  // number of coefficients per level
  array[N] int<lower=1> J_39;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_39_mu6_1;
  // data for group-level effects of ID 40
  int<lower=1> N_40;  // number of grouping levels
  int<lower=1> M_40;  // number of coefficients per level
  array[N] int<lower=1> J_40;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_40_mu6_1;
  // POSTSTRAT: POPULATION LEVEL DESIGN VECTORS
  //vector[3] nX_mu1;  // population-level design matrix
  //vector[5] nX_mu2;  // population-level design matrix
  //vector[3] nX_mu3;  // population-level design matrix
  //vector[5] nX_mu4;  // population-level design matrix
  //vector[3] nX_mu5;  // population-level design matrix
  //vector[5] nX_mu6;  // population-level design matrix
  // array dimensions based on [CUID, sex, pums, educ, metro, income, age, education:age interaction] for 5 alternatives = 8 x 5 = 40 N's
  array[111,5,2,7,4,28,12,6] int<lower=0> P; // Poststratification demographic data
  int prior_only;  // should the likelihood be ignored?
}
transformed data {

  int Kc_mu1 = 2;
  matrix[N, Kc_mu1] Xc_mu1;  // centered version of X_mu3 without an intercept
  vector[Kc_mu1] means_X_mu1;  // column means of X_mu3 before centering
  int Kc_mu2 = 4;
  matrix[N, Kc_mu2] Xc_mu2;  // centered version of X_mu2 without an intercept
  vector[Kc_mu2] means_X_mu2;  // column means of X_mu2 before centering
  int Kc_mu3 = 2;
  matrix[N, Kc_mu3] Xc_mu3;  // centered version of X_mu3 without an intercept
  vector[Kc_mu3] means_X_mu3;  // column means of X_mu3 before centering
  int Kc_mu4 = 4;
  matrix[N, Kc_mu4] Xc_mu4;  // centered version of X_mu4 without an intercept
  vector[Kc_mu4] means_X_mu4;  // column means of X_mu4 before centering
  int Kc_mu5 = 2;
  matrix[N, Kc_mu5] Xc_mu5;  // centered version of X_mu5 without an intercept
  vector[Kc_mu5] means_X_mu5;  // column means of X_mu5 before centering
  int Kc_mu6 = 4;
  matrix[N, Kc_mu6] Xc_mu6;  // centered version of X_mu6 without an intercept
  vector[Kc_mu6] means_X_mu6;  // column means of X_mu6 before centering
for (i in 2:3) {
    means_X_mu1[i - 1] = mean(X_mu1[, i]);
    Xc_mu1[, i - 1] = X_mu1[, i] - means_X_mu1[i - 1];
  }
  for (i in 2:5) {
    means_X_mu2[i - 1] = mean(X_mu2[, i]);
    Xc_mu2[, i - 1] = X_mu2[, i] - means_X_mu2[i - 1];
  }
  for (i in 2:3) {
    means_X_mu3[i - 1] = mean(X_mu3[, i]);
    Xc_mu3[, i - 1] = X_mu3[, i] - means_X_mu3[i - 1];
  }
  for (i in 2:5) {
    means_X_mu4[i - 1] = mean(X_mu4[, i]);
    Xc_mu4[, i - 1] = X_mu4[, i] - means_X_mu4[i - 1];
  }
  for (i in 2:3) {
    means_X_mu5[i - 1] = mean(X_mu5[, i]);
    Xc_mu5[, i - 1] = X_mu5[, i] - means_X_mu5[i - 1];
  }
  for (i in 2:5) {
    means_X_mu6[i - 1] = mean(X_mu6[, i]);
    Xc_mu6[, i - 1] = X_mu6[, i] - means_X_mu6[i - 1];
  }
}
parameters {
  //vector[Kc_mu1] b_mu1;  // population-level effects
  real b_price;
  real b_cost;
  real b_incen;
  real b_refust;
  
  //vector[Kc_mu2] b_mu2;  // regression coefficients
  real Intercept_mu2;  // temporary intercept for centered predictors
  //vector[Kc_mu3] b_mu3;  // regression coefficients
  real Intercept_mu3;  // temporary intercept for centered predictors
  //vector[Kc_mu4] b_mu4;  // regression coefficients
  real Intercept_mu4;  // temporary intercept for centered predictors
  //vector[Kc_mu5] b_mu5;  // regression coefficients
  real Intercept_mu5;  // temporary intercept for centered predictors
  //vector[Kc_mu6] b_mu6;  // regression coefficients
  real Intercept_mu6;  // temporary intercept for centered predictors
  vector<lower=0>[M_1] sd_1;  // group-level standard deviations
  array[M_1] vector[N_1] z_1;  // standardized group-level effects
  vector<lower=0>[M_2] sd_2;  // group-level standard deviations
  array[M_2] vector[N_2] z_2;  // standardized group-level effects
  vector<lower=0>[M_3] sd_3;  // group-level standard deviations
  array[M_3] vector[N_3] z_3;  // standardized group-level effects
  vector<lower=0>[M_4] sd_4;  // group-level standard deviations
  array[M_4] vector[N_4] z_4;  // standardized group-level effects
  vector<lower=0>[M_5] sd_5;  // group-level standard deviations
  array[M_5] vector[N_5] z_5;  // standardized group-level effects
  vector<lower=0>[M_6] sd_6;  // group-level standard deviations
  array[M_6] vector[N_6] z_6;  // standardized group-level effects
  vector<lower=0>[M_7] sd_7;  // group-level standard deviations
  array[M_7] vector[N_7] z_7;  // standardized group-level effects
  vector<lower=0>[M_8] sd_8;  // group-level standard deviations
  array[M_8] vector[N_8] z_8;  // standardized group-level effects
  vector<lower=0>[M_9] sd_9;  // group-level standard deviations
  array[M_9] vector[N_9] z_9;  // standardized group-level effects
  vector<lower=0>[M_10] sd_10;  // group-level standard deviations
  array[M_10] vector[N_10] z_10;  // standardized group-level effects
  vector<lower=0>[M_11] sd_11;  // group-level standard deviations
  array[M_11] vector[N_11] z_11;  // standardized group-level effects
  vector<lower=0>[M_12] sd_12;  // group-level standard deviations
  array[M_12] vector[N_12] z_12;  // standardized group-level effects
  vector<lower=0>[M_13] sd_13;  // group-level standard deviations
  array[M_13] vector[N_13] z_13;  // standardized group-level effects
  vector<lower=0>[M_14] sd_14;  // group-level standard deviations
  array[M_14] vector[N_14] z_14;  // standardized group-level effects
  vector<lower=0>[M_15] sd_15;  // group-level standard deviations
  array[M_15] vector[N_15] z_15;  // standardized group-level effects
  vector<lower=0>[M_16] sd_16;  // group-level standard deviations
  array[M_16] vector[N_16] z_16;  // standardized group-level effects
  vector<lower=0>[M_17] sd_17;  // group-level standard deviations
  array[M_17] vector[N_17] z_17;  // standardized group-level effects
  vector<lower=0>[M_18] sd_18;  // group-level standard deviations
  array[M_18] vector[N_18] z_18;  // standardized group-level effects
  vector<lower=0>[M_19] sd_19;  // group-level standard deviations
  array[M_19] vector[N_19] z_19;  // standardized group-level effects
  vector<lower=0>[M_20] sd_20;  // group-level standard deviations
  array[M_20] vector[N_20] z_20;  // standardized group-level effects
  vector<lower=0>[M_21] sd_21;  // group-level standard deviations
  array[M_21] vector[N_21] z_21;  // standardized group-level effects
  vector<lower=0>[M_22] sd_22;  // group-level standard deviations
  array[M_22] vector[N_22] z_22;  // standardized group-level effects
  vector<lower=0>[M_23] sd_23;  // group-level standard deviations
  array[M_23] vector[N_23] z_23;  // standardized group-level effects
  vector<lower=0>[M_24] sd_24;  // group-level standard deviations
  array[M_24] vector[N_24] z_24;  // standardized group-level effects
  vector<lower=0>[M_25] sd_25;  // group-level standard deviations
  array[M_25] vector[N_25] z_25;  // standardized group-level effects
  vector<lower=0>[M_26] sd_26;  // group-level standard deviations
  array[M_26] vector[N_26] z_26;  // standardized group-level effects
  vector<lower=0>[M_27] sd_27;  // group-level standard deviations
  array[M_27] vector[N_27] z_27;  // standardized group-level effects
  vector<lower=0>[M_28] sd_28;  // group-level standard deviations
  array[M_28] vector[N_28] z_28;  // standardized group-level effects
  vector<lower=0>[M_29] sd_29;  // group-level standard deviations
  array[M_29] vector[N_29] z_29;  // standardized group-level effects
  vector<lower=0>[M_30] sd_30;  // group-level standard deviations
  array[M_30] vector[N_30] z_30;  // standardized group-level effects
  vector<lower=0>[M_31] sd_31;  // group-level standard deviations
  array[M_31] vector[N_31] z_31;  // standardized group-level effects
  vector<lower=0>[M_32] sd_32;  // group-level standard deviations
  array[M_32] vector[N_32] z_32;  // standardized group-level effects
  vector<lower=0>[M_33] sd_33;  // group-level standard deviations
  array[M_33] vector[N_33] z_33;  // standardized group-level effects
  vector<lower=0>[M_34] sd_34;  // group-level standard deviations
  array[M_34] vector[N_34] z_34;  // standardized group-level effects
  vector<lower=0>[M_35] sd_35;  // group-level standard deviations
  array[M_35] vector[N_35] z_35;  // standardized group-level effects
  vector<lower=0>[M_36] sd_36;  // group-level standard deviations
  array[M_36] vector[N_36] z_36;  // standardized group-level effects
  vector<lower=0>[M_37] sd_37;  // group-level standard deviations
  array[M_37] vector[N_37] z_37;  // standardized group-level effects
  vector<lower=0>[M_38] sd_38;  // group-level standard deviations
  array[M_38] vector[N_38] z_38;  // standardized group-level effects
  vector<lower=0>[M_39] sd_39;  // group-level standard deviations
  array[M_39] vector[N_39] z_39;  // standardized group-level effects
  vector<lower=0>[M_40] sd_40;  // group-level standard deviations
  array[M_40] vector[N_40] z_40;  // standardized group-level effects
}
transformed parameters {

  vector[2] b_mu1;  // population-level effects
  vector[4] b_mu2;  // population-level effects
  vector[2] b_mu3;  // population-level effects
  vector[4] b_mu4;  // population-level effects
  vector[2] b_mu5;  // population-level effects
  vector[4] b_mu6;  // population-level effects

  b_mu1 = to_vector([-b_price, -b_cost]);
  b_mu2 = to_vector([-b_price, -b_cost, b_incen, -b_refust]);
  b_mu3 = to_vector([-b_price, -b_cost]);
  b_mu4 = to_vector([-b_price, -b_cost, b_incen, -b_refust]);
  b_mu5 = to_vector([-b_price, -b_cost]);
  b_mu6 = to_vector([-b_price, -b_cost, b_incen, -b_refust]);

  vector[N_1] r_1_mu2_1;  // actual group-level effects
  vector[N_2] r_2_mu2_1;  // actual group-level effects
  vector[N_3] r_3_mu2_1;  // actual group-level effects
  vector[N_4] r_4_mu2_1;  // actual group-level effects
  vector[N_5] r_5_mu2_1;  // actual group-level effects
  vector[N_6] r_6_mu2_1;  // actual group-level effects
  vector[N_7] r_7_mu2_1;  // actual group-level effects
  vector[N_8] r_8_mu2_1;  // actual group-level effects
  vector[N_9] r_9_mu3_1;  // actual group-level effects
  vector[N_10] r_10_mu3_1;  // actual group-level effects
  vector[N_11] r_11_mu3_1;  // actual group-level effects
  vector[N_12] r_12_mu3_1;  // actual group-level effects
  vector[N_13] r_13_mu3_1;  // actual group-level effects
  vector[N_14] r_14_mu3_1;  // actual group-level effects
  vector[N_15] r_15_mu3_1;  // actual group-level effects
  vector[N_16] r_16_mu3_1;  // actual group-level effects
  vector[N_17] r_17_mu4_1;  // actual group-level effects
  vector[N_18] r_18_mu4_1;  // actual group-level effects
  vector[N_19] r_19_mu4_1;  // actual group-level effects
  vector[N_20] r_20_mu4_1;  // actual group-level effects
  vector[N_21] r_21_mu4_1;  // actual group-level effects
  vector[N_22] r_22_mu4_1;  // actual group-level effects
  vector[N_23] r_23_mu4_1;  // actual group-level effects
  vector[N_24] r_24_mu4_1;  // actual group-level effects
  vector[N_25] r_25_mu5_1;  // actual group-level effects
  vector[N_26] r_26_mu5_1;  // actual group-level effects
  vector[N_27] r_27_mu5_1;  // actual group-level effects
  vector[N_28] r_28_mu5_1;  // actual group-level effects
  vector[N_29] r_29_mu5_1;  // actual group-level effects
  vector[N_30] r_30_mu5_1;  // actual group-level effects
  vector[N_31] r_31_mu5_1;  // actual group-level effects
  vector[N_32] r_32_mu5_1;  // actual group-level effects
  vector[N_33] r_33_mu6_1;  // actual group-level effects
  vector[N_34] r_34_mu6_1;  // actual group-level effects
  vector[N_35] r_35_mu6_1;  // actual group-level effects
  vector[N_36] r_36_mu6_1;  // actual group-level effects
  vector[N_37] r_37_mu6_1;  // actual group-level effects
  vector[N_38] r_38_mu6_1;  // actual group-level effects
  vector[N_39] r_39_mu6_1;  // actual group-level effects
  vector[N_40] r_40_mu6_1;  // actual group-level effects
  real lprior = 0;  // prior contributions to the log posterior
  r_1_mu2_1 = (sd_1[1] * (z_1[1]));
  r_2_mu2_1 = (sd_2[1] * (z_2[1]));
  r_3_mu2_1 = (sd_3[1] * (z_3[1]));
  r_4_mu2_1 = (sd_4[1] * (z_4[1]));
  r_5_mu2_1 = (sd_5[1] * (z_5[1]));
  r_6_mu2_1 = (sd_6[1] * (z_6[1]));
  r_7_mu2_1 = (sd_7[1] * (z_7[1]));
  r_8_mu2_1 = (sd_8[1] * (z_8[1]));
  r_9_mu3_1 = (sd_9[1] * (z_9[1]));
  r_10_mu3_1 = (sd_10[1] * (z_10[1]));
  r_11_mu3_1 = (sd_11[1] * (z_11[1]));
  r_12_mu3_1 = (sd_12[1] * (z_12[1]));
  r_13_mu3_1 = (sd_13[1] * (z_13[1]));
  r_14_mu3_1 = (sd_14[1] * (z_14[1]));
  r_15_mu3_1 = (sd_15[1] * (z_15[1]));
  r_16_mu3_1 = (sd_16[1] * (z_16[1]));
  r_17_mu4_1 = (sd_17[1] * (z_17[1]));
  r_18_mu4_1 = (sd_18[1] * (z_18[1]));
  r_19_mu4_1 = (sd_19[1] * (z_19[1]));
  r_20_mu4_1 = (sd_20[1] * (z_20[1]));
  r_21_mu4_1 = (sd_21[1] * (z_21[1]));
  r_22_mu4_1 = (sd_22[1] * (z_22[1]));
  r_23_mu4_1 = (sd_23[1] * (z_23[1]));
  r_24_mu4_1 = (sd_24[1] * (z_24[1]));
  r_25_mu5_1 = (sd_25[1] * (z_25[1]));
  r_26_mu5_1 = (sd_26[1] * (z_26[1]));
  r_27_mu5_1 = (sd_27[1] * (z_27[1]));
  r_28_mu5_1 = (sd_28[1] * (z_28[1]));
  r_29_mu5_1 = (sd_29[1] * (z_29[1]));
  r_30_mu5_1 = (sd_30[1] * (z_30[1]));
  r_31_mu5_1 = (sd_31[1] * (z_31[1]));
  r_32_mu5_1 = (sd_32[1] * (z_32[1]));
  r_33_mu6_1 = (sd_33[1] * (z_33[1]));
  r_34_mu6_1 = (sd_34[1] * (z_34[1]));
  r_35_mu6_1 = (sd_35[1] * (z_35[1]));
  r_36_mu6_1 = (sd_36[1] * (z_36[1]));
  r_37_mu6_1 = (sd_37[1] * (z_37[1]));
  r_38_mu6_1 = (sd_38[1] * (z_38[1]));
  r_39_mu6_1 = (sd_39[1] * (z_39[1]));
  r_40_mu6_1 = (sd_40[1] * (z_40[1]));
  lprior += student_t_lpdf(Intercept_mu2 | 3, 0, 2.5);
  lprior += student_t_lpdf(Intercept_mu3 | 3, 0, 2.5);
  lprior += student_t_lpdf(Intercept_mu4 | 3, 0, 2.5);
  lprior += student_t_lpdf(Intercept_mu5 | 3, 0, 2.5);
  lprior += student_t_lpdf(Intercept_mu6 | 3, 0, 2.5);
  lprior += exponential_lpdf(sd_1 | 1);
  lprior += exponential_lpdf(sd_2 | 1);
  lprior += exponential_lpdf(sd_3 | 1);
  lprior += exponential_lpdf(sd_4 | 1);
  lprior += exponential_lpdf(sd_5 | 1);
  lprior += exponential_lpdf(sd_6 | 1);
  lprior += exponential_lpdf(sd_7 | 1);
  lprior += exponential_lpdf(sd_8 | 1);
  lprior += exponential_lpdf(sd_9 | 1);
  lprior += exponential_lpdf(sd_10 | 1);
  lprior += exponential_lpdf(sd_11 | 1);
  lprior += exponential_lpdf(sd_12 | 1);
  lprior += exponential_lpdf(sd_13 | 1);
  lprior += exponential_lpdf(sd_14 | 1);
  lprior += exponential_lpdf(sd_15 | 1);
  lprior += exponential_lpdf(sd_16 | 1);
  lprior += exponential_lpdf(sd_17 | 1);
  lprior += exponential_lpdf(sd_18 | 1);
  lprior += exponential_lpdf(sd_19 | 1);
  lprior += exponential_lpdf(sd_20 | 1);
  lprior += exponential_lpdf(sd_21 | 1);
  lprior += exponential_lpdf(sd_22 | 1);
  lprior += exponential_lpdf(sd_23 | 1);
  lprior += exponential_lpdf(sd_24 | 1);
  lprior += exponential_lpdf(sd_25 | 1);
  lprior += exponential_lpdf(sd_26 | 1);
  lprior += exponential_lpdf(sd_27 | 1);
  lprior += exponential_lpdf(sd_28 | 1);
  lprior += exponential_lpdf(sd_29 | 1);
  lprior += exponential_lpdf(sd_30 | 1);
  lprior += exponential_lpdf(sd_31 | 1);
  lprior += exponential_lpdf(sd_32 | 1);
  lprior += exponential_lpdf(sd_33 | 1);
  lprior += exponential_lpdf(sd_34 | 1);
  lprior += exponential_lpdf(sd_35 | 1);
  lprior += exponential_lpdf(sd_36 | 1);
  lprior += exponential_lpdf(sd_37 | 1);
  lprior += exponential_lpdf(sd_38 | 1);
  lprior += exponential_lpdf(sd_39 | 1);
  lprior += exponential_lpdf(sd_40 | 1);
}
model {
  // likelihood including constants
  if (!prior_only) {
    // initialize linear predictor term
    vector[N] mu1 = rep_vector(0.0, N);
    // initialize linear predictor term
    vector[N] mu2 = rep_vector(0.0, N);
    // initialize linear predictor term
    vector[N] mu3 = rep_vector(0.0, N);
    // initialize linear predictor term
    vector[N] mu4 = rep_vector(0.0, N);
    // initialize linear predictor term
    vector[N] mu5 = rep_vector(0.0, N);
    // initialize linear predictor term
    vector[N] mu6 = rep_vector(0.0, N);
    // linear predictor matrix
    array[N] vector[ncat] mu;
    mu1 += Xc_mu1 * b_mu1;
    mu2 += Intercept_mu2 + Xc_mu2 * b_mu2;
    mu3 += Intercept_mu3 + Xc_mu3 * b_mu3;
    mu4 += Intercept_mu4 + Xc_mu4 * b_mu4;
    mu5 += Intercept_mu5 + Xc_mu5 * b_mu5;
    mu6 += Intercept_mu6 + Xc_mu6 * b_mu6;
    for (n in 1:N) {
      // add more terms to the linear predictor
      mu2[n] += r_1_mu2_1[J_1[n]] * Z_1_mu2_1[n] + r_2_mu2_1[J_2[n]] * Z_2_mu2_1[n] + r_3_mu2_1[J_3[n]] * Z_3_mu2_1[n] + r_4_mu2_1[J_4[n]] * Z_4_mu2_1[n] + r_5_mu2_1[J_5[n]] * Z_5_mu2_1[n] + r_6_mu2_1[J_6[n]] * Z_6_mu2_1[n] + r_7_mu2_1[J_7[n]] * Z_7_mu2_1[n] + r_8_mu2_1[J_8[n]] * Z_8_mu2_1[n];
    }
    for (n in 1:N) {
      // add more terms to the linear predictor
      mu3[n] += r_9_mu3_1[J_9[n]] * Z_9_mu3_1[n] + r_10_mu3_1[J_10[n]] * Z_10_mu3_1[n] + r_11_mu3_1[J_11[n]] * Z_11_mu3_1[n] + r_12_mu3_1[J_12[n]] * Z_12_mu3_1[n] + r_13_mu3_1[J_13[n]] * Z_13_mu3_1[n] + r_14_mu3_1[J_14[n]] * Z_14_mu3_1[n] + r_15_mu3_1[J_15[n]] * Z_15_mu3_1[n] + r_16_mu3_1[J_16[n]] * Z_16_mu3_1[n];
    }
    for (n in 1:N) {
      // add more terms to the linear predictor
      mu4[n] += r_17_mu4_1[J_17[n]] * Z_17_mu4_1[n] + r_18_mu4_1[J_18[n]] * Z_18_mu4_1[n] + r_19_mu4_1[J_19[n]] * Z_19_mu4_1[n] + r_20_mu4_1[J_20[n]] * Z_20_mu4_1[n] + r_21_mu4_1[J_21[n]] * Z_21_mu4_1[n] + r_22_mu4_1[J_22[n]] * Z_22_mu4_1[n] + r_23_mu4_1[J_23[n]] * Z_23_mu4_1[n] + r_24_mu4_1[J_24[n]] * Z_24_mu4_1[n];
    }
    for (n in 1:N) {
      // add more terms to the linear predictor
      mu5[n] += r_25_mu5_1[J_25[n]] * Z_25_mu5_1[n] + r_26_mu5_1[J_26[n]] * Z_26_mu5_1[n] + r_27_mu5_1[J_27[n]] * Z_27_mu5_1[n] + r_28_mu5_1[J_28[n]] * Z_28_mu5_1[n] + r_29_mu5_1[J_29[n]] * Z_29_mu5_1[n] + r_30_mu5_1[J_30[n]] * Z_30_mu5_1[n] + r_31_mu5_1[J_31[n]] * Z_31_mu5_1[n] + r_32_mu5_1[J_32[n]] * Z_32_mu5_1[n];
    }
    for (n in 1:N) {
      // add more terms to the linear predictor
      mu6[n] += r_33_mu6_1[J_33[n]] * Z_33_mu6_1[n] + r_34_mu6_1[J_34[n]] * Z_34_mu6_1[n] + r_35_mu6_1[J_35[n]] * Z_35_mu6_1[n] + r_36_mu6_1[J_36[n]] * Z_36_mu6_1[n] + r_37_mu6_1[J_37[n]] * Z_37_mu6_1[n] + r_38_mu6_1[J_38[n]] * Z_38_mu6_1[n] + r_39_mu6_1[J_39[n]] * Z_39_mu6_1[n] + r_40_mu6_1[J_40[n]] * Z_40_mu6_1[n];
    }
    for (n in 1:N) {
      mu[n] = transpose([0, mu2[n], mu3[n], mu4[n], mu5[n], mu6[n]]);
    }
    for (n in 1:N) {
      target += categorical_logit_lpmf(Y[n] | mu[n]);
    }
  }
  // priors including constants
    b_price ~ lognormal(0,1);
  b_cost ~ lognormal(0,1);
  b_incen ~ lognormal(0,1);
  b_refust ~ lognormal(0,1);
  target += lprior;
  target += std_normal_lpdf(z_1[1]);
  target += std_normal_lpdf(z_2[1]);
  target += std_normal_lpdf(z_3[1]);
  target += std_normal_lpdf(z_4[1]);
  target += std_normal_lpdf(z_5[1]);
  target += std_normal_lpdf(z_6[1]);
  target += std_normal_lpdf(z_7[1]);
  target += std_normal_lpdf(z_8[1]);
  target += std_normal_lpdf(z_9[1]);
  target += std_normal_lpdf(z_10[1]);
  target += std_normal_lpdf(z_11[1]);
  target += std_normal_lpdf(z_12[1]);
  target += std_normal_lpdf(z_13[1]);
  target += std_normal_lpdf(z_14[1]);
  target += std_normal_lpdf(z_15[1]);
  target += std_normal_lpdf(z_16[1]);
  target += std_normal_lpdf(z_17[1]);
  target += std_normal_lpdf(z_18[1]);
  target += std_normal_lpdf(z_19[1]);
  target += std_normal_lpdf(z_20[1]);
  target += std_normal_lpdf(z_21[1]);
  target += std_normal_lpdf(z_22[1]);
  target += std_normal_lpdf(z_23[1]);
  target += std_normal_lpdf(z_24[1]);
  target += std_normal_lpdf(z_25[1]);
  target += std_normal_lpdf(z_26[1]);
  target += std_normal_lpdf(z_27[1]);
  target += std_normal_lpdf(z_28[1]);
  target += std_normal_lpdf(z_29[1]);
  target += std_normal_lpdf(z_30[1]);
  target += std_normal_lpdf(z_31[1]);
  target += std_normal_lpdf(z_32[1]);
  target += std_normal_lpdf(z_33[1]);
  target += std_normal_lpdf(z_34[1]);
  target += std_normal_lpdf(z_35[1]);
  target += std_normal_lpdf(z_36[1]);
  target += std_normal_lpdf(z_37[1]);
  target += std_normal_lpdf(z_38[1]);
  target += std_normal_lpdf(z_39[1]);
  target += std_normal_lpdf(z_40[1]);
}
generated quantities {
  // actual population-level intercept
  real b_mu2_Intercept = Intercept_mu2 - dot_product(means_X_mu2, b_mu2);
  // actual population-level intercept
  real b_mu3_Intercept = Intercept_mu3 - dot_product(means_X_mu3, b_mu3);
  // actual population-level intercept
  real b_mu4_Intercept = Intercept_mu4 - dot_product(means_X_mu4, b_mu4);
  // actual population-level intercept
  real b_mu5_Intercept = Intercept_mu5 - dot_product(means_X_mu5, b_mu5);
  // actual population-level intercept
  real b_mu6_Intercept = Intercept_mu6 - dot_product(means_X_mu6, b_mu6);
  
  //POSTSTRAT: Utility specification
  vector[N] mu1 = rep_vector(0.0, N);
  vector[N] mu2 = rep_vector(0.0, N);
  vector[N] mu3 = rep_vector(0.0, N);
  vector[N] mu4 = rep_vector(0.0, N);
  vector[N] mu5 = rep_vector(0.0, N);
  vector[N] mu6 = rep_vector(0.0, N);

  mu1 += Xc_mu1 * b_mu1;
  mu2 += Intercept_mu2 + Xc_mu2 * b_mu2;
  mu3 += Intercept_mu3 + Xc_mu3 * b_mu3;
  mu4 += Intercept_mu4 + Xc_mu4 * b_mu4;
  mu5 += Intercept_mu5 + Xc_mu5 * b_mu5;
  mu6 += Intercept_mu6 + Xc_mu6 * b_mu6;
	
  // Our output is #pums (N_6) x #alternatives (6)
  
  array[N_6, 6] real expect_ch;
 
  expect_ch = rep_array(0,N_6,6);

  int total = 0;

  array[N_6, 6] real<lower=0, upper=1> phi;

  phi = rep_array(0,N_6,6);

  for (g in 1:N_6) {
                vector[6] nmu = rep_vector(0,6);
                real nmu1 = 0;
                real nmu2 = 0;
                real nmu3 = 0;
                real nmu4 = 0;
                real nmu5 = 0;
                real nmu6 = 0;

	       expect_ch = rep_array(0,N_6,6);
               total = 0;
       for (a in 1:N_1) {
	    for (b in 1:N_2) {
              for (d in 1:N_3) {
		   for (e in 1:N_4) {
		     for (f in 1:N_5) {
			   for (h in 1:N_7) {
			     for (k in 1:N_8) {
                          
                             			     nmu2 =  Intercept_mu2 + 0.04 + r_1_mu2_1[a] + r_2_mu2_1[b] + r_3_mu2_1[d]  + r_4_mu2_1[e] + r_5_mu2_1[f] + r_6_mu2_1[g] + r_7_mu2_1[h] + r_8_mu2_1[k];
                             			     nmu3 =   Intercept_mu3 +  r_9_mu3_1[a] + r_10_mu3_1[b] + r_11_mu3_1[d]   + r_12_mu3_1[e] + r_13_mu3_1[f] + r_14_mu3_1[g] + r_15_mu3_1[h] + r_16_mu3_1[k];
                             			     nmu4 =   Intercept_mu4 + 0.04  + r_17_mu4_1[a] + r_18_mu4_1[b]  + r_19_mu4_1[d]  + r_20_mu4_1[e] + r_21_mu4_1[f] + r_22_mu4_1[g] + r_23_mu4_1[h] + r_24_mu4_1[k];
                             			     nmu5 =   Intercept_mu5 +  r_25_mu5_1[a] + r_26_mu5_1[b] + r_27_mu5_1[d]   + r_28_mu5_1[e] + r_29_mu5_1[f] + r_30_mu5_1[g] + r_31_mu5_1[h] + r_32_mu5_1[k];
                             			     nmu6 =   Intercept_mu6  + 0.04 +  r_33_mu6_1[a] + r_34_mu6_1[b] + r_35_mu6_1[d]   + r_36_mu6_1[e] + r_37_mu6_1[f] + r_38_mu6_1[g] + r_39_mu6_1[h] + r_40_mu6_1[k];

				 nmu = transpose([nmu1, nmu2, nmu3, nmu4, nmu5, nmu6]);
			     total += P[g, f, h, a, d, b, e, k];   
                 vector[6] new_row = softmax(nmu);              
                 expect_ch[g, 1]
                 += P[g, f, h, a, d, b, e, k]
                 * new_row[1]; 
                 expect_ch[g, 2]
                 += P[g, f, h, a, d, b, e, k]
                 * new_row[2]; 
                 expect_ch[g, 3]
                 += P[g, f, h, a, d, b, e, k]
                 * new_row[3]; 
                 expect_ch[g, 4]
                 += P[g, f, h, a, d, b, e, k]
                 * new_row[4]; 
                 expect_ch[g, 5]
                 += P[g, f, h, a, d, b, e, k]
                 * new_row[5]; 
                 expect_ch[g, 6]
                 += P[g, f, h, a, d, b, e, k]
                 * new_row[6];                 
	            }
                
            }
           }
		  }
		}
      }

	}
      phi[g,1] = expect_ch[g,1] / total;
      phi[g,2] = expect_ch[g,2] / total;
      phi[g,3] = expect_ch[g,3] / total;
      phi[g,4] = expect_ch[g,4] / total;
      phi[g,5] = expect_ch[g,5] / total;
      phi[g,6] = expect_ch[g,6] / total;
    }
  
}

