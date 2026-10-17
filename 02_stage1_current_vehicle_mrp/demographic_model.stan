// =============================================================================
// demographic_model.stan
// -----------------------------------------------------------------------------
// STAGE 1  -  Current-vehicle (demographic-only) MRP model  [12-category]
//
// A Bayesian multinomial (categorical-logit) model for a household's CURRENT
// vehicle type across the 12 vehicle types (3 classes x 4 powertrains). The
// outcome is explained by demographics ONLY, with varying intercepts for the
// 7 poststratification factors:
//     agec, education:age, educ, income, metro, PUMA, sex
// Category 1 is the reference (utility fixed to 0); utilities mu2..mu12 are
// modelled. There are 7 x 11 = 77 varying-intercept groups, named
//     r_1_mu2_1 .. r_7_mu2_1   (category 2, factors agec..sex)
//     r_8_mu3_1 .. r_14_mu3_1  (category 3)   ...   up to r_77_mu12_1
// i.e. category c (c = 2..12) uses groups r_{(c-2)*7 + 1 .. (c-2)*7 + 7}
// in factor order [agec, educ_age, educ, inc, metro, pums_idx, sex].
//
// The fitted random-effect summaries feed poststratify_demographic.R, which
// maps them onto the census poststratification table to produce per-cell
// vehicle-type probabilities (new_post.csv) for the IPF step.
//
// P[28,4,12,111,5,2,7]  poststratification cell counts, indexed
//     [educ_age, educ, income, pums, metro, sex, age].
// phi[N_6, 12]          posterior PUMA-level share of each of the 12 types.
//
// brms-generated Stan code; body kept verbatim so the fit reproduces the
// paper. Only this header was added.
// =============================================================================

// generated with brms 2.20.4
functions {
}
data {
  int<lower=1> N;  // total number of observations
  int<lower=2> ncat;  // number of categories
  array[N] int Y;  // response variable
  // data for group-level effects of ID 1
  int<lower=1> N_1;  // number of grouping levels
  int<lower=1> M_1;  // number of coefficients per level
  array[N] int<lower=1> J_1;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_1_mu10_1;
  // data for group-level effects of ID 2
  int<lower=1> N_2;  // number of grouping levels
  int<lower=1> M_2;  // number of coefficients per level
  array[N] int<lower=1> J_2;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_2_mu10_1;
  // data for group-level effects of ID 3
  int<lower=1> N_3;  // number of grouping levels
  int<lower=1> M_3;  // number of coefficients per level
  array[N] int<lower=1> J_3;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_3_mu10_1;
  // data for group-level effects of ID 4
  int<lower=1> N_4;  // number of grouping levels
  int<lower=1> M_4;  // number of coefficients per level
  array[N] int<lower=1> J_4;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_4_mu10_1;
  // data for group-level effects of ID 5
  int<lower=1> N_5;  // number of grouping levels
  int<lower=1> M_5;  // number of coefficients per level
  array[N] int<lower=1> J_5;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_5_mu10_1;
  // data for group-level effects of ID 6
  int<lower=1> N_6;  // number of grouping levels
  int<lower=1> M_6;  // number of coefficients per level
  array[N] int<lower=1> J_6;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_6_mu10_1;
  // data for group-level effects of ID 7
  int<lower=1> N_7;  // number of grouping levels
  int<lower=1> M_7;  // number of coefficients per level
  array[N] int<lower=1> J_7;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_7_mu10_1;
  // data for group-level effects of ID 8
  int<lower=1> N_8;  // number of grouping levels
  int<lower=1> M_8;  // number of coefficients per level
  array[N] int<lower=1> J_8;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_8_mu11_1;
  // data for group-level effects of ID 9
  int<lower=1> N_9;  // number of grouping levels
  int<lower=1> M_9;  // number of coefficients per level
  array[N] int<lower=1> J_9;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_9_mu11_1;
  // data for group-level effects of ID 10
  int<lower=1> N_10;  // number of grouping levels
  int<lower=1> M_10;  // number of coefficients per level
  array[N] int<lower=1> J_10;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_10_mu11_1;
  // data for group-level effects of ID 11
  int<lower=1> N_11;  // number of grouping levels
  int<lower=1> M_11;  // number of coefficients per level
  array[N] int<lower=1> J_11;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_11_mu11_1;
  // data for group-level effects of ID 12
  int<lower=1> N_12;  // number of grouping levels
  int<lower=1> M_12;  // number of coefficients per level
  array[N] int<lower=1> J_12;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_12_mu11_1;
  // data for group-level effects of ID 13
  int<lower=1> N_13;  // number of grouping levels
  int<lower=1> M_13;  // number of coefficients per level
  array[N] int<lower=1> J_13;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_13_mu11_1;
  // data for group-level effects of ID 14
  int<lower=1> N_14;  // number of grouping levels
  int<lower=1> M_14;  // number of coefficients per level
  array[N] int<lower=1> J_14;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_14_mu11_1;
  // data for group-level effects of ID 15
  int<lower=1> N_15;  // number of grouping levels
  int<lower=1> M_15;  // number of coefficients per level
  array[N] int<lower=1> J_15;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_15_mu12_1;
  // data for group-level effects of ID 16
  int<lower=1> N_16;  // number of grouping levels
  int<lower=1> M_16;  // number of coefficients per level
  array[N] int<lower=1> J_16;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_16_mu12_1;
  // data for group-level effects of ID 17
  int<lower=1> N_17;  // number of grouping levels
  int<lower=1> M_17;  // number of coefficients per level
  array[N] int<lower=1> J_17;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_17_mu12_1;
  // data for group-level effects of ID 18
  int<lower=1> N_18;  // number of grouping levels
  int<lower=1> M_18;  // number of coefficients per level
  array[N] int<lower=1> J_18;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_18_mu12_1;
  // data for group-level effects of ID 19
  int<lower=1> N_19;  // number of grouping levels
  int<lower=1> M_19;  // number of coefficients per level
  array[N] int<lower=1> J_19;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_19_mu12_1;
  // data for group-level effects of ID 20
  int<lower=1> N_20;  // number of grouping levels
  int<lower=1> M_20;  // number of coefficients per level
  array[N] int<lower=1> J_20;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_20_mu12_1;
  // data for group-level effects of ID 21
  int<lower=1> N_21;  // number of grouping levels
  int<lower=1> M_21;  // number of coefficients per level
  array[N] int<lower=1> J_21;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_21_mu12_1;
  // data for group-level effects of ID 22
  int<lower=1> N_22;  // number of grouping levels
  int<lower=1> M_22;  // number of coefficients per level
  array[N] int<lower=1> J_22;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_22_mu2_1;
  // data for group-level effects of ID 23
  int<lower=1> N_23;  // number of grouping levels
  int<lower=1> M_23;  // number of coefficients per level
  array[N] int<lower=1> J_23;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_23_mu2_1;
  // data for group-level effects of ID 24
  int<lower=1> N_24;  // number of grouping levels
  int<lower=1> M_24;  // number of coefficients per level
  array[N] int<lower=1> J_24;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_24_mu2_1;
  // data for group-level effects of ID 25
  int<lower=1> N_25;  // number of grouping levels
  int<lower=1> M_25;  // number of coefficients per level
  array[N] int<lower=1> J_25;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_25_mu2_1;
  // data for group-level effects of ID 26
  int<lower=1> N_26;  // number of grouping levels
  int<lower=1> M_26;  // number of coefficients per level
  array[N] int<lower=1> J_26;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_26_mu2_1;
  // data for group-level effects of ID 27
  int<lower=1> N_27;  // number of grouping levels
  int<lower=1> M_27;  // number of coefficients per level
  array[N] int<lower=1> J_27;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_27_mu2_1;
  // data for group-level effects of ID 28
  int<lower=1> N_28;  // number of grouping levels
  int<lower=1> M_28;  // number of coefficients per level
  array[N] int<lower=1> J_28;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_28_mu2_1;
  // data for group-level effects of ID 29
  int<lower=1> N_29;  // number of grouping levels
  int<lower=1> M_29;  // number of coefficients per level
  array[N] int<lower=1> J_29;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_29_mu3_1;
  // data for group-level effects of ID 30
  int<lower=1> N_30;  // number of grouping levels
  int<lower=1> M_30;  // number of coefficients per level
  array[N] int<lower=1> J_30;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_30_mu3_1;
  // data for group-level effects of ID 31
  int<lower=1> N_31;  // number of grouping levels
  int<lower=1> M_31;  // number of coefficients per level
  array[N] int<lower=1> J_31;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_31_mu3_1;
  // data for group-level effects of ID 32
  int<lower=1> N_32;  // number of grouping levels
  int<lower=1> M_32;  // number of coefficients per level
  array[N] int<lower=1> J_32;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_32_mu3_1;
  // data for group-level effects of ID 33
  int<lower=1> N_33;  // number of grouping levels
  int<lower=1> M_33;  // number of coefficients per level
  array[N] int<lower=1> J_33;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_33_mu3_1;
  // data for group-level effects of ID 34
  int<lower=1> N_34;  // number of grouping levels
  int<lower=1> M_34;  // number of coefficients per level
  array[N] int<lower=1> J_34;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_34_mu3_1;
  // data for group-level effects of ID 35
  int<lower=1> N_35;  // number of grouping levels
  int<lower=1> M_35;  // number of coefficients per level
  array[N] int<lower=1> J_35;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_35_mu3_1;
  // data for group-level effects of ID 36
  int<lower=1> N_36;  // number of grouping levels
  int<lower=1> M_36;  // number of coefficients per level
  array[N] int<lower=1> J_36;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_36_mu4_1;
  // data for group-level effects of ID 37
  int<lower=1> N_37;  // number of grouping levels
  int<lower=1> M_37;  // number of coefficients per level
  array[N] int<lower=1> J_37;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_37_mu4_1;
  // data for group-level effects of ID 38
  int<lower=1> N_38;  // number of grouping levels
  int<lower=1> M_38;  // number of coefficients per level
  array[N] int<lower=1> J_38;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_38_mu4_1;
  // data for group-level effects of ID 39
  int<lower=1> N_39;  // number of grouping levels
  int<lower=1> M_39;  // number of coefficients per level
  array[N] int<lower=1> J_39;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_39_mu4_1;
  // data for group-level effects of ID 40
  int<lower=1> N_40;  // number of grouping levels
  int<lower=1> M_40;  // number of coefficients per level
  array[N] int<lower=1> J_40;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_40_mu4_1;
  // data for group-level effects of ID 41
  int<lower=1> N_41;  // number of grouping levels
  int<lower=1> M_41;  // number of coefficients per level
  array[N] int<lower=1> J_41;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_41_mu4_1;
  // data for group-level effects of ID 42
  int<lower=1> N_42;  // number of grouping levels
  int<lower=1> M_42;  // number of coefficients per level
  array[N] int<lower=1> J_42;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_42_mu4_1;
  // data for group-level effects of ID 43
  int<lower=1> N_43;  // number of grouping levels
  int<lower=1> M_43;  // number of coefficients per level
  array[N] int<lower=1> J_43;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_43_mu5_1;
  // data for group-level effects of ID 44
  int<lower=1> N_44;  // number of grouping levels
  int<lower=1> M_44;  // number of coefficients per level
  array[N] int<lower=1> J_44;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_44_mu5_1;
  // data for group-level effects of ID 45
  int<lower=1> N_45;  // number of grouping levels
  int<lower=1> M_45;  // number of coefficients per level
  array[N] int<lower=1> J_45;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_45_mu5_1;
  // data for group-level effects of ID 46
  int<lower=1> N_46;  // number of grouping levels
  int<lower=1> M_46;  // number of coefficients per level
  array[N] int<lower=1> J_46;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_46_mu5_1;
  // data for group-level effects of ID 47
  int<lower=1> N_47;  // number of grouping levels
  int<lower=1> M_47;  // number of coefficients per level
  array[N] int<lower=1> J_47;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_47_mu5_1;
  // data for group-level effects of ID 48
  int<lower=1> N_48;  // number of grouping levels
  int<lower=1> M_48;  // number of coefficients per level
  array[N] int<lower=1> J_48;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_48_mu5_1;
  // data for group-level effects of ID 49
  int<lower=1> N_49;  // number of grouping levels
  int<lower=1> M_49;  // number of coefficients per level
  array[N] int<lower=1> J_49;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_49_mu5_1;
  // data for group-level effects of ID 50
  int<lower=1> N_50;  // number of grouping levels
  int<lower=1> M_50;  // number of coefficients per level
  array[N] int<lower=1> J_50;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_50_mu6_1;
  // data for group-level effects of ID 51
  int<lower=1> N_51;  // number of grouping levels
  int<lower=1> M_51;  // number of coefficients per level
  array[N] int<lower=1> J_51;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_51_mu6_1;
  // data for group-level effects of ID 52
  int<lower=1> N_52;  // number of grouping levels
  int<lower=1> M_52;  // number of coefficients per level
  array[N] int<lower=1> J_52;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_52_mu6_1;
  // data for group-level effects of ID 53
  int<lower=1> N_53;  // number of grouping levels
  int<lower=1> M_53;  // number of coefficients per level
  array[N] int<lower=1> J_53;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_53_mu6_1;
  // data for group-level effects of ID 54
  int<lower=1> N_54;  // number of grouping levels
  int<lower=1> M_54;  // number of coefficients per level
  array[N] int<lower=1> J_54;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_54_mu6_1;
  // data for group-level effects of ID 55
  int<lower=1> N_55;  // number of grouping levels
  int<lower=1> M_55;  // number of coefficients per level
  array[N] int<lower=1> J_55;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_55_mu6_1;
  // data for group-level effects of ID 56
  int<lower=1> N_56;  // number of grouping levels
  int<lower=1> M_56;  // number of coefficients per level
  array[N] int<lower=1> J_56;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_56_mu6_1;
  // data for group-level effects of ID 57
  int<lower=1> N_57;  // number of grouping levels
  int<lower=1> M_57;  // number of coefficients per level
  array[N] int<lower=1> J_57;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_57_mu7_1;
  // data for group-level effects of ID 58
  int<lower=1> N_58;  // number of grouping levels
  int<lower=1> M_58;  // number of coefficients per level
  array[N] int<lower=1> J_58;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_58_mu7_1;
  // data for group-level effects of ID 59
  int<lower=1> N_59;  // number of grouping levels
  int<lower=1> M_59;  // number of coefficients per level
  array[N] int<lower=1> J_59;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_59_mu7_1;
  // data for group-level effects of ID 60
  int<lower=1> N_60;  // number of grouping levels
  int<lower=1> M_60;  // number of coefficients per level
  array[N] int<lower=1> J_60;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_60_mu7_1;
  // data for group-level effects of ID 61
  int<lower=1> N_61;  // number of grouping levels
  int<lower=1> M_61;  // number of coefficients per level
  array[N] int<lower=1> J_61;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_61_mu7_1;
  // data for group-level effects of ID 62
  int<lower=1> N_62;  // number of grouping levels
  int<lower=1> M_62;  // number of coefficients per level
  array[N] int<lower=1> J_62;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_62_mu7_1;
  // data for group-level effects of ID 63
  int<lower=1> N_63;  // number of grouping levels
  int<lower=1> M_63;  // number of coefficients per level
  array[N] int<lower=1> J_63;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_63_mu7_1;
  // data for group-level effects of ID 64
  int<lower=1> N_64;  // number of grouping levels
  int<lower=1> M_64;  // number of coefficients per level
  array[N] int<lower=1> J_64;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_64_mu8_1;
  // data for group-level effects of ID 65
  int<lower=1> N_65;  // number of grouping levels
  int<lower=1> M_65;  // number of coefficients per level
  array[N] int<lower=1> J_65;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_65_mu8_1;
  // data for group-level effects of ID 66
  int<lower=1> N_66;  // number of grouping levels
  int<lower=1> M_66;  // number of coefficients per level
  array[N] int<lower=1> J_66;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_66_mu8_1;
  // data for group-level effects of ID 67
  int<lower=1> N_67;  // number of grouping levels
  int<lower=1> M_67;  // number of coefficients per level
  array[N] int<lower=1> J_67;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_67_mu8_1;
  // data for group-level effects of ID 68
  int<lower=1> N_68;  // number of grouping levels
  int<lower=1> M_68;  // number of coefficients per level
  array[N] int<lower=1> J_68;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_68_mu8_1;
  // data for group-level effects of ID 69
  int<lower=1> N_69;  // number of grouping levels
  int<lower=1> M_69;  // number of coefficients per level
  array[N] int<lower=1> J_69;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_69_mu8_1;
  // data for group-level effects of ID 70
  int<lower=1> N_70;  // number of grouping levels
  int<lower=1> M_70;  // number of coefficients per level
  array[N] int<lower=1> J_70;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_70_mu8_1;
  // data for group-level effects of ID 71
  int<lower=1> N_71;  // number of grouping levels
  int<lower=1> M_71;  // number of coefficients per level
  array[N] int<lower=1> J_71;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_71_mu9_1;
  // data for group-level effects of ID 72
  int<lower=1> N_72;  // number of grouping levels
  int<lower=1> M_72;  // number of coefficients per level
  array[N] int<lower=1> J_72;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_72_mu9_1;
  // data for group-level effects of ID 73
  int<lower=1> N_73;  // number of grouping levels
  int<lower=1> M_73;  // number of coefficients per level
  array[N] int<lower=1> J_73;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_73_mu9_1;
  // data for group-level effects of ID 74
  int<lower=1> N_74;  // number of grouping levels
  int<lower=1> M_74;  // number of coefficients per level
  array[N] int<lower=1> J_74;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_74_mu9_1;
  // data for group-level effects of ID 75
  int<lower=1> N_75;  // number of grouping levels
  int<lower=1> M_75;  // number of coefficients per level
  array[N] int<lower=1> J_75;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_75_mu9_1;
  // data for group-level effects of ID 76
  int<lower=1> N_76;  // number of grouping levels
  int<lower=1> M_76;  // number of coefficients per level
  array[N] int<lower=1> J_76;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_76_mu9_1;
  // data for group-level effects of ID 77
  int<lower=1> N_77;  // number of grouping levels
  int<lower=1> M_77;  // number of coefficients per level
  array[N] int<lower=1> J_77;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_77_mu9_1;
  int prior_only;  // should the likelihood be ignored?
    array[28,4,12,111,5,2,7] int<lower=0> P; // Poststratification demographic data

}
transformed data {
}
parameters {
  real Intercept_mu10;  // temporary intercept for centered predictors
  real Intercept_mu11;  // temporary intercept for centered predictors
  real Intercept_mu12;  // temporary intercept for centered predictors
  real Intercept_mu2;  // temporary intercept for centered predictors
  real Intercept_mu3;  // temporary intercept for centered predictors
  real Intercept_mu4;  // temporary intercept for centered predictors
  real Intercept_mu5;  // temporary intercept for centered predictors
  real Intercept_mu6;  // temporary intercept for centered predictors
  real Intercept_mu7;  // temporary intercept for centered predictors
  real Intercept_mu8;  // temporary intercept for centered predictors
  real Intercept_mu9;  // temporary intercept for centered predictors
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
  vector<lower=0>[M_41] sd_41;  // group-level standard deviations
  array[M_41] vector[N_41] z_41;  // standardized group-level effects
  vector<lower=0>[M_42] sd_42;  // group-level standard deviations
  array[M_42] vector[N_42] z_42;  // standardized group-level effects
  vector<lower=0>[M_43] sd_43;  // group-level standard deviations
  array[M_43] vector[N_43] z_43;  // standardized group-level effects
  vector<lower=0>[M_44] sd_44;  // group-level standard deviations
  array[M_44] vector[N_44] z_44;  // standardized group-level effects
  vector<lower=0>[M_45] sd_45;  // group-level standard deviations
  array[M_45] vector[N_45] z_45;  // standardized group-level effects
  vector<lower=0>[M_46] sd_46;  // group-level standard deviations
  array[M_46] vector[N_46] z_46;  // standardized group-level effects
  vector<lower=0>[M_47] sd_47;  // group-level standard deviations
  array[M_47] vector[N_47] z_47;  // standardized group-level effects
  vector<lower=0>[M_48] sd_48;  // group-level standard deviations
  array[M_48] vector[N_48] z_48;  // standardized group-level effects
  vector<lower=0>[M_49] sd_49;  // group-level standard deviations
  array[M_49] vector[N_49] z_49;  // standardized group-level effects
  vector<lower=0>[M_50] sd_50;  // group-level standard deviations
  array[M_50] vector[N_50] z_50;  // standardized group-level effects
  vector<lower=0>[M_51] sd_51;  // group-level standard deviations
  array[M_51] vector[N_51] z_51;  // standardized group-level effects
  vector<lower=0>[M_52] sd_52;  // group-level standard deviations
  array[M_52] vector[N_52] z_52;  // standardized group-level effects
  vector<lower=0>[M_53] sd_53;  // group-level standard deviations
  array[M_53] vector[N_53] z_53;  // standardized group-level effects
  vector<lower=0>[M_54] sd_54;  // group-level standard deviations
  array[M_54] vector[N_54] z_54;  // standardized group-level effects
  vector<lower=0>[M_55] sd_55;  // group-level standard deviations
  array[M_55] vector[N_55] z_55;  // standardized group-level effects
  vector<lower=0>[M_56] sd_56;  // group-level standard deviations
  array[M_56] vector[N_56] z_56;  // standardized group-level effects
  vector<lower=0>[M_57] sd_57;  // group-level standard deviations
  array[M_57] vector[N_57] z_57;  // standardized group-level effects
  vector<lower=0>[M_58] sd_58;  // group-level standard deviations
  array[M_58] vector[N_58] z_58;  // standardized group-level effects
  vector<lower=0>[M_59] sd_59;  // group-level standard deviations
  array[M_59] vector[N_59] z_59;  // standardized group-level effects
  vector<lower=0>[M_60] sd_60;  // group-level standard deviations
  array[M_60] vector[N_60] z_60;  // standardized group-level effects
  vector<lower=0>[M_61] sd_61;  // group-level standard deviations
  array[M_61] vector[N_61] z_61;  // standardized group-level effects
  vector<lower=0>[M_62] sd_62;  // group-level standard deviations
  array[M_62] vector[N_62] z_62;  // standardized group-level effects
  vector<lower=0>[M_63] sd_63;  // group-level standard deviations
  array[M_63] vector[N_63] z_63;  // standardized group-level effects
  vector<lower=0>[M_64] sd_64;  // group-level standard deviations
  array[M_64] vector[N_64] z_64;  // standardized group-level effects
  vector<lower=0>[M_65] sd_65;  // group-level standard deviations
  array[M_65] vector[N_65] z_65;  // standardized group-level effects
  vector<lower=0>[M_66] sd_66;  // group-level standard deviations
  array[M_66] vector[N_66] z_66;  // standardized group-level effects
  vector<lower=0>[M_67] sd_67;  // group-level standard deviations
  array[M_67] vector[N_67] z_67;  // standardized group-level effects
  vector<lower=0>[M_68] sd_68;  // group-level standard deviations
  array[M_68] vector[N_68] z_68;  // standardized group-level effects
  vector<lower=0>[M_69] sd_69;  // group-level standard deviations
  array[M_69] vector[N_69] z_69;  // standardized group-level effects
  vector<lower=0>[M_70] sd_70;  // group-level standard deviations
  array[M_70] vector[N_70] z_70;  // standardized group-level effects
  vector<lower=0>[M_71] sd_71;  // group-level standard deviations
  array[M_71] vector[N_71] z_71;  // standardized group-level effects
  vector<lower=0>[M_72] sd_72;  // group-level standard deviations
  array[M_72] vector[N_72] z_72;  // standardized group-level effects
  vector<lower=0>[M_73] sd_73;  // group-level standard deviations
  array[M_73] vector[N_73] z_73;  // standardized group-level effects
  vector<lower=0>[M_74] sd_74;  // group-level standard deviations
  array[M_74] vector[N_74] z_74;  // standardized group-level effects
  vector<lower=0>[M_75] sd_75;  // group-level standard deviations
  array[M_75] vector[N_75] z_75;  // standardized group-level effects
  vector<lower=0>[M_76] sd_76;  // group-level standard deviations
  array[M_76] vector[N_76] z_76;  // standardized group-level effects
  vector<lower=0>[M_77] sd_77;  // group-level standard deviations
  array[M_77] vector[N_77] z_77;  // standardized group-level effects
}
transformed parameters {
  vector[N_1] r_1_mu10_1;  // actual group-level effects
  vector[N_2] r_2_mu10_1;  // actual group-level effects
  vector[N_3] r_3_mu10_1;  // actual group-level effects
  vector[N_4] r_4_mu10_1;  // actual group-level effects
  vector[N_5] r_5_mu10_1;  // actual group-level effects
  vector[N_6] r_6_mu10_1;  // actual group-level effects
  vector[N_7] r_7_mu10_1;  // actual group-level effects
  vector[N_8] r_8_mu11_1;  // actual group-level effects
  vector[N_9] r_9_mu11_1;  // actual group-level effects
  vector[N_10] r_10_mu11_1;  // actual group-level effects
  vector[N_11] r_11_mu11_1;  // actual group-level effects
  vector[N_12] r_12_mu11_1;  // actual group-level effects
  vector[N_13] r_13_mu11_1;  // actual group-level effects
  vector[N_14] r_14_mu11_1;  // actual group-level effects
  vector[N_15] r_15_mu12_1;  // actual group-level effects
  vector[N_16] r_16_mu12_1;  // actual group-level effects
  vector[N_17] r_17_mu12_1;  // actual group-level effects
  vector[N_18] r_18_mu12_1;  // actual group-level effects
  vector[N_19] r_19_mu12_1;  // actual group-level effects
  vector[N_20] r_20_mu12_1;  // actual group-level effects
  vector[N_21] r_21_mu12_1;  // actual group-level effects
  vector[N_22] r_22_mu2_1;  // actual group-level effects
  vector[N_23] r_23_mu2_1;  // actual group-level effects
  vector[N_24] r_24_mu2_1;  // actual group-level effects
  vector[N_25] r_25_mu2_1;  // actual group-level effects
  vector[N_26] r_26_mu2_1;  // actual group-level effects
  vector[N_27] r_27_mu2_1;  // actual group-level effects
  vector[N_28] r_28_mu2_1;  // actual group-level effects
  vector[N_29] r_29_mu3_1;  // actual group-level effects
  vector[N_30] r_30_mu3_1;  // actual group-level effects
  vector[N_31] r_31_mu3_1;  // actual group-level effects
  vector[N_32] r_32_mu3_1;  // actual group-level effects
  vector[N_33] r_33_mu3_1;  // actual group-level effects
  vector[N_34] r_34_mu3_1;  // actual group-level effects
  vector[N_35] r_35_mu3_1;  // actual group-level effects
  vector[N_36] r_36_mu4_1;  // actual group-level effects
  vector[N_37] r_37_mu4_1;  // actual group-level effects
  vector[N_38] r_38_mu4_1;  // actual group-level effects
  vector[N_39] r_39_mu4_1;  // actual group-level effects
  vector[N_40] r_40_mu4_1;  // actual group-level effects
  vector[N_41] r_41_mu4_1;  // actual group-level effects
  vector[N_42] r_42_mu4_1;  // actual group-level effects
  vector[N_43] r_43_mu5_1;  // actual group-level effects
  vector[N_44] r_44_mu5_1;  // actual group-level effects
  vector[N_45] r_45_mu5_1;  // actual group-level effects
  vector[N_46] r_46_mu5_1;  // actual group-level effects
  vector[N_47] r_47_mu5_1;  // actual group-level effects
  vector[N_48] r_48_mu5_1;  // actual group-level effects
  vector[N_49] r_49_mu5_1;  // actual group-level effects
  vector[N_50] r_50_mu6_1;  // actual group-level effects
  vector[N_51] r_51_mu6_1;  // actual group-level effects
  vector[N_52] r_52_mu6_1;  // actual group-level effects
  vector[N_53] r_53_mu6_1;  // actual group-level effects
  vector[N_54] r_54_mu6_1;  // actual group-level effects
  vector[N_55] r_55_mu6_1;  // actual group-level effects
  vector[N_56] r_56_mu6_1;  // actual group-level effects
  vector[N_57] r_57_mu7_1;  // actual group-level effects
  vector[N_58] r_58_mu7_1;  // actual group-level effects
  vector[N_59] r_59_mu7_1;  // actual group-level effects
  vector[N_60] r_60_mu7_1;  // actual group-level effects
  vector[N_61] r_61_mu7_1;  // actual group-level effects
  vector[N_62] r_62_mu7_1;  // actual group-level effects
  vector[N_63] r_63_mu7_1;  // actual group-level effects
  vector[N_64] r_64_mu8_1;  // actual group-level effects
  vector[N_65] r_65_mu8_1;  // actual group-level effects
  vector[N_66] r_66_mu8_1;  // actual group-level effects
  vector[N_67] r_67_mu8_1;  // actual group-level effects
  vector[N_68] r_68_mu8_1;  // actual group-level effects
  vector[N_69] r_69_mu8_1;  // actual group-level effects
  vector[N_70] r_70_mu8_1;  // actual group-level effects
  vector[N_71] r_71_mu9_1;  // actual group-level effects
  vector[N_72] r_72_mu9_1;  // actual group-level effects
  vector[N_73] r_73_mu9_1;  // actual group-level effects
  vector[N_74] r_74_mu9_1;  // actual group-level effects
  vector[N_75] r_75_mu9_1;  // actual group-level effects
  vector[N_76] r_76_mu9_1;  // actual group-level effects
  vector[N_77] r_77_mu9_1;  // actual group-level effects
  real lprior = 0;  // prior contributions to the log posterior
  r_1_mu10_1 = (sd_1[1] * (z_1[1]));
  r_2_mu10_1 = (sd_2[1] * (z_2[1]));
  r_3_mu10_1 = (sd_3[1] * (z_3[1]));
  r_4_mu10_1 = (sd_4[1] * (z_4[1]));
  r_5_mu10_1 = (sd_5[1] * (z_5[1]));
  r_6_mu10_1 = (sd_6[1] * (z_6[1]));
  r_7_mu10_1 = (sd_7[1] * (z_7[1]));
  r_8_mu11_1 = (sd_8[1] * (z_8[1]));
  r_9_mu11_1 = (sd_9[1] * (z_9[1]));
  r_10_mu11_1 = (sd_10[1] * (z_10[1]));
  r_11_mu11_1 = (sd_11[1] * (z_11[1]));
  r_12_mu11_1 = (sd_12[1] * (z_12[1]));
  r_13_mu11_1 = (sd_13[1] * (z_13[1]));
  r_14_mu11_1 = (sd_14[1] * (z_14[1]));
  r_15_mu12_1 = (sd_15[1] * (z_15[1]));
  r_16_mu12_1 = (sd_16[1] * (z_16[1]));
  r_17_mu12_1 = (sd_17[1] * (z_17[1]));
  r_18_mu12_1 = (sd_18[1] * (z_18[1]));
  r_19_mu12_1 = (sd_19[1] * (z_19[1]));
  r_20_mu12_1 = (sd_20[1] * (z_20[1]));
  r_21_mu12_1 = (sd_21[1] * (z_21[1]));
  r_22_mu2_1 = (sd_22[1] * (z_22[1]));
  r_23_mu2_1 = (sd_23[1] * (z_23[1]));
  r_24_mu2_1 = (sd_24[1] * (z_24[1]));
  r_25_mu2_1 = (sd_25[1] * (z_25[1]));
  r_26_mu2_1 = (sd_26[1] * (z_26[1]));
  r_27_mu2_1 = (sd_27[1] * (z_27[1]));
  r_28_mu2_1 = (sd_28[1] * (z_28[1]));
  r_29_mu3_1 = (sd_29[1] * (z_29[1]));
  r_30_mu3_1 = (sd_30[1] * (z_30[1]));
  r_31_mu3_1 = (sd_31[1] * (z_31[1]));
  r_32_mu3_1 = (sd_32[1] * (z_32[1]));
  r_33_mu3_1 = (sd_33[1] * (z_33[1]));
  r_34_mu3_1 = (sd_34[1] * (z_34[1]));
  r_35_mu3_1 = (sd_35[1] * (z_35[1]));
  r_36_mu4_1 = (sd_36[1] * (z_36[1]));
  r_37_mu4_1 = (sd_37[1] * (z_37[1]));
  r_38_mu4_1 = (sd_38[1] * (z_38[1]));
  r_39_mu4_1 = (sd_39[1] * (z_39[1]));
  r_40_mu4_1 = (sd_40[1] * (z_40[1]));
  r_41_mu4_1 = (sd_41[1] * (z_41[1]));
  r_42_mu4_1 = (sd_42[1] * (z_42[1]));
  r_43_mu5_1 = (sd_43[1] * (z_43[1]));
  r_44_mu5_1 = (sd_44[1] * (z_44[1]));
  r_45_mu5_1 = (sd_45[1] * (z_45[1]));
  r_46_mu5_1 = (sd_46[1] * (z_46[1]));
  r_47_mu5_1 = (sd_47[1] * (z_47[1]));
  r_48_mu5_1 = (sd_48[1] * (z_48[1]));
  r_49_mu5_1 = (sd_49[1] * (z_49[1]));
  r_50_mu6_1 = (sd_50[1] * (z_50[1]));
  r_51_mu6_1 = (sd_51[1] * (z_51[1]));
  r_52_mu6_1 = (sd_52[1] * (z_52[1]));
  r_53_mu6_1 = (sd_53[1] * (z_53[1]));
  r_54_mu6_1 = (sd_54[1] * (z_54[1]));
  r_55_mu6_1 = (sd_55[1] * (z_55[1]));
  r_56_mu6_1 = (sd_56[1] * (z_56[1]));
  r_57_mu7_1 = (sd_57[1] * (z_57[1]));
  r_58_mu7_1 = (sd_58[1] * (z_58[1]));
  r_59_mu7_1 = (sd_59[1] * (z_59[1]));
  r_60_mu7_1 = (sd_60[1] * (z_60[1]));
  r_61_mu7_1 = (sd_61[1] * (z_61[1]));
  r_62_mu7_1 = (sd_62[1] * (z_62[1]));
  r_63_mu7_1 = (sd_63[1] * (z_63[1]));
  r_64_mu8_1 = (sd_64[1] * (z_64[1]));
  r_65_mu8_1 = (sd_65[1] * (z_65[1]));
  r_66_mu8_1 = (sd_66[1] * (z_66[1]));
  r_67_mu8_1 = (sd_67[1] * (z_67[1]));
  r_68_mu8_1 = (sd_68[1] * (z_68[1]));
  r_69_mu8_1 = (sd_69[1] * (z_69[1]));
  r_70_mu8_1 = (sd_70[1] * (z_70[1]));
  r_71_mu9_1 = (sd_71[1] * (z_71[1]));
  r_72_mu9_1 = (sd_72[1] * (z_72[1]));
  r_73_mu9_1 = (sd_73[1] * (z_73[1]));
  r_74_mu9_1 = (sd_74[1] * (z_74[1]));
  r_75_mu9_1 = (sd_75[1] * (z_75[1]));
  r_76_mu9_1 = (sd_76[1] * (z_76[1]));
  r_77_mu9_1 = (sd_77[1] * (z_77[1]));
  lprior += student_t_lpdf(Intercept_mu10 | 3, 0, 2.5);
  lprior += student_t_lpdf(Intercept_mu11 | 3, 0, 2.5);
  lprior += student_t_lpdf(Intercept_mu12 | 3, 0, 2.5);
  lprior += student_t_lpdf(Intercept_mu2 | 3, 0, 2.5);
  lprior += student_t_lpdf(Intercept_mu3 | 3, 0, 2.5);
  lprior += student_t_lpdf(Intercept_mu4 | 3, 0, 2.5);
  lprior += student_t_lpdf(Intercept_mu5 | 3, 0, 2.5);
  lprior += student_t_lpdf(Intercept_mu6 | 3, 0, 2.5);
  lprior += student_t_lpdf(Intercept_mu7 | 3, 0, 2.5);
  lprior += student_t_lpdf(Intercept_mu8 | 3, 0, 2.5);
  lprior += student_t_lpdf(Intercept_mu9 | 3, 0, 2.5);
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
  lprior += exponential_lpdf(sd_41 | 1);
  lprior += exponential_lpdf(sd_42 | 1);
  lprior += exponential_lpdf(sd_43 | 1);
  lprior += exponential_lpdf(sd_44 | 1);
  lprior += exponential_lpdf(sd_45 | 1);
  lprior += exponential_lpdf(sd_46 | 1);
  lprior += exponential_lpdf(sd_47 | 1);
  lprior += exponential_lpdf(sd_48 | 1);
  lprior += exponential_lpdf(sd_49 | 1);
  lprior += exponential_lpdf(sd_50 | 1);
  lprior += exponential_lpdf(sd_51 | 1);
  lprior += exponential_lpdf(sd_52 | 1);
  lprior += exponential_lpdf(sd_53 | 1);
  lprior += exponential_lpdf(sd_54 | 1);
  lprior += exponential_lpdf(sd_55 | 1);
  lprior += exponential_lpdf(sd_56 | 1);
  lprior += exponential_lpdf(sd_57 | 1);
  lprior += exponential_lpdf(sd_58 | 1);
  lprior += exponential_lpdf(sd_59 | 1);
  lprior += exponential_lpdf(sd_60 | 1);
  lprior += exponential_lpdf(sd_61 | 1);
  lprior += exponential_lpdf(sd_62 | 1);
  lprior += exponential_lpdf(sd_63 | 1);
  lprior += exponential_lpdf(sd_64 | 1);
  lprior += exponential_lpdf(sd_65 | 1);
  lprior += exponential_lpdf(sd_66 | 1);
  lprior += exponential_lpdf(sd_67 | 1);
  lprior += exponential_lpdf(sd_68 | 1);
  lprior += exponential_lpdf(sd_69 | 1);
  lprior += exponential_lpdf(sd_70 | 1);
  lprior += exponential_lpdf(sd_71 | 1);
  lprior += exponential_lpdf(sd_72 | 1);
  lprior += exponential_lpdf(sd_73 | 1);
  lprior += exponential_lpdf(sd_74 | 1);
  lprior += exponential_lpdf(sd_75 | 1);
  lprior += exponential_lpdf(sd_76 | 1);
  lprior += exponential_lpdf(sd_77 | 1);
}
model {
  // likelihood including constants
  if (!prior_only) {
    // initialize linear predictor term
    vector[N] mu10 = rep_vector(0.0, N);
    // initialize linear predictor term
    vector[N] mu11 = rep_vector(0.0, N);
    // initialize linear predictor term
    vector[N] mu12 = rep_vector(0.0, N);
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
    // initialize linear predictor term
    vector[N] mu7 = rep_vector(0.0, N);
    // initialize linear predictor term
    vector[N] mu8 = rep_vector(0.0, N);
    // initialize linear predictor term
    vector[N] mu9 = rep_vector(0.0, N);
    // linear predictor matrix
    array[N] vector[ncat] mu;
    mu10 += Intercept_mu10;
    mu11 += Intercept_mu11;
    mu12 += Intercept_mu12;
    mu2 += Intercept_mu2;
    mu3 += Intercept_mu3;
    mu4 += Intercept_mu4;
    mu5 += Intercept_mu5;
    mu6 += Intercept_mu6;
    mu7 += Intercept_mu7;
    mu8 += Intercept_mu8;
    mu9 += Intercept_mu9;
    for (n in 1:N) {
      // add more terms to the linear predictor
      mu10[n] += r_1_mu10_1[J_1[n]] * Z_1_mu10_1[n] + r_2_mu10_1[J_2[n]] * Z_2_mu10_1[n] + r_3_mu10_1[J_3[n]] * Z_3_mu10_1[n] + r_4_mu10_1[J_4[n]] * Z_4_mu10_1[n] + r_5_mu10_1[J_5[n]] * Z_5_mu10_1[n] + r_6_mu10_1[J_6[n]] * Z_6_mu10_1[n] + r_7_mu10_1[J_7[n]] * Z_7_mu10_1[n];
    }
    for (n in 1:N) {
      // add more terms to the linear predictor
      mu11[n] += r_8_mu11_1[J_8[n]] * Z_8_mu11_1[n] + r_9_mu11_1[J_9[n]] * Z_9_mu11_1[n] + r_10_mu11_1[J_10[n]] * Z_10_mu11_1[n] + r_11_mu11_1[J_11[n]] * Z_11_mu11_1[n] + r_12_mu11_1[J_12[n]] * Z_12_mu11_1[n] + r_13_mu11_1[J_13[n]] * Z_13_mu11_1[n] + r_14_mu11_1[J_14[n]] * Z_14_mu11_1[n];
    }
    for (n in 1:N) {
      // add more terms to the linear predictor
      mu12[n] += r_15_mu12_1[J_15[n]] * Z_15_mu12_1[n] + r_16_mu12_1[J_16[n]] * Z_16_mu12_1[n] + r_17_mu12_1[J_17[n]] * Z_17_mu12_1[n] + r_18_mu12_1[J_18[n]] * Z_18_mu12_1[n] + r_19_mu12_1[J_19[n]] * Z_19_mu12_1[n] + r_20_mu12_1[J_20[n]] * Z_20_mu12_1[n] + r_21_mu12_1[J_21[n]] * Z_21_mu12_1[n];
    }
    for (n in 1:N) {
      // add more terms to the linear predictor
      mu2[n] += r_22_mu2_1[J_22[n]] * Z_22_mu2_1[n] + r_23_mu2_1[J_23[n]] * Z_23_mu2_1[n] + r_24_mu2_1[J_24[n]] * Z_24_mu2_1[n] + r_25_mu2_1[J_25[n]] * Z_25_mu2_1[n] + r_26_mu2_1[J_26[n]] * Z_26_mu2_1[n] + r_27_mu2_1[J_27[n]] * Z_27_mu2_1[n] + r_28_mu2_1[J_28[n]] * Z_28_mu2_1[n];
    }
    for (n in 1:N) {
      // add more terms to the linear predictor
      mu3[n] += r_29_mu3_1[J_29[n]] * Z_29_mu3_1[n] + r_30_mu3_1[J_30[n]] * Z_30_mu3_1[n] + r_31_mu3_1[J_31[n]] * Z_31_mu3_1[n] + r_32_mu3_1[J_32[n]] * Z_32_mu3_1[n] + r_33_mu3_1[J_33[n]] * Z_33_mu3_1[n] + r_34_mu3_1[J_34[n]] * Z_34_mu3_1[n] + r_35_mu3_1[J_35[n]] * Z_35_mu3_1[n];
    }
    for (n in 1:N) {
      // add more terms to the linear predictor
      mu4[n] += r_36_mu4_1[J_36[n]] * Z_36_mu4_1[n] + r_37_mu4_1[J_37[n]] * Z_37_mu4_1[n] + r_38_mu4_1[J_38[n]] * Z_38_mu4_1[n] + r_39_mu4_1[J_39[n]] * Z_39_mu4_1[n] + r_40_mu4_1[J_40[n]] * Z_40_mu4_1[n] + r_41_mu4_1[J_41[n]] * Z_41_mu4_1[n] + r_42_mu4_1[J_42[n]] * Z_42_mu4_1[n];
    }
    for (n in 1:N) {
      // add more terms to the linear predictor
      mu5[n] += r_43_mu5_1[J_43[n]] * Z_43_mu5_1[n] + r_44_mu5_1[J_44[n]] * Z_44_mu5_1[n] + r_45_mu5_1[J_45[n]] * Z_45_mu5_1[n] + r_46_mu5_1[J_46[n]] * Z_46_mu5_1[n] + r_47_mu5_1[J_47[n]] * Z_47_mu5_1[n] + r_48_mu5_1[J_48[n]] * Z_48_mu5_1[n] + r_49_mu5_1[J_49[n]] * Z_49_mu5_1[n];
    }
    for (n in 1:N) {
      // add more terms to the linear predictor
      mu6[n] += r_50_mu6_1[J_50[n]] * Z_50_mu6_1[n] + r_51_mu6_1[J_51[n]] * Z_51_mu6_1[n] + r_52_mu6_1[J_52[n]] * Z_52_mu6_1[n] + r_53_mu6_1[J_53[n]] * Z_53_mu6_1[n] + r_54_mu6_1[J_54[n]] * Z_54_mu6_1[n] + r_55_mu6_1[J_55[n]] * Z_55_mu6_1[n] + r_56_mu6_1[J_56[n]] * Z_56_mu6_1[n];
    }
    for (n in 1:N) {
      // add more terms to the linear predictor
      mu7[n] += r_57_mu7_1[J_57[n]] * Z_57_mu7_1[n] + r_58_mu7_1[J_58[n]] * Z_58_mu7_1[n] + r_59_mu7_1[J_59[n]] * Z_59_mu7_1[n] + r_60_mu7_1[J_60[n]] * Z_60_mu7_1[n] + r_61_mu7_1[J_61[n]] * Z_61_mu7_1[n] + r_62_mu7_1[J_62[n]] * Z_62_mu7_1[n] + r_63_mu7_1[J_63[n]] * Z_63_mu7_1[n];
    }
    for (n in 1:N) {
      // add more terms to the linear predictor
      mu8[n] += r_64_mu8_1[J_64[n]] * Z_64_mu8_1[n] + r_65_mu8_1[J_65[n]] * Z_65_mu8_1[n] + r_66_mu8_1[J_66[n]] * Z_66_mu8_1[n] + r_67_mu8_1[J_67[n]] * Z_67_mu8_1[n] + r_68_mu8_1[J_68[n]] * Z_68_mu8_1[n] + r_69_mu8_1[J_69[n]] * Z_69_mu8_1[n] + r_70_mu8_1[J_70[n]] * Z_70_mu8_1[n];
    }
    for (n in 1:N) {
      // add more terms to the linear predictor
      mu9[n] += r_71_mu9_1[J_71[n]] * Z_71_mu9_1[n] + r_72_mu9_1[J_72[n]] * Z_72_mu9_1[n] + r_73_mu9_1[J_73[n]] * Z_73_mu9_1[n] + r_74_mu9_1[J_74[n]] * Z_74_mu9_1[n] + r_75_mu9_1[J_75[n]] * Z_75_mu9_1[n] + r_76_mu9_1[J_76[n]] * Z_76_mu9_1[n] + r_77_mu9_1[J_77[n]] * Z_77_mu9_1[n];
    }
    for (n in 1:N) {
      mu[n] = transpose([0, mu10[n], mu11[n], mu12[n], mu2[n], mu3[n], mu4[n], mu5[n], mu6[n], mu7[n], mu8[n], mu9[n]]);
    }
    for (n in 1:N) {
      target += categorical_logit_lpmf(Y[n] | mu[n]);
    }
  }
  // priors including constants
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
  target += std_normal_lpdf(z_41[1]);
  target += std_normal_lpdf(z_42[1]);
  target += std_normal_lpdf(z_43[1]);
  target += std_normal_lpdf(z_44[1]);
  target += std_normal_lpdf(z_45[1]);
  target += std_normal_lpdf(z_46[1]);
  target += std_normal_lpdf(z_47[1]);
  target += std_normal_lpdf(z_48[1]);
  target += std_normal_lpdf(z_49[1]);
  target += std_normal_lpdf(z_50[1]);
  target += std_normal_lpdf(z_51[1]);
  target += std_normal_lpdf(z_52[1]);
  target += std_normal_lpdf(z_53[1]);
  target += std_normal_lpdf(z_54[1]);
  target += std_normal_lpdf(z_55[1]);
  target += std_normal_lpdf(z_56[1]);
  target += std_normal_lpdf(z_57[1]);
  target += std_normal_lpdf(z_58[1]);
  target += std_normal_lpdf(z_59[1]);
  target += std_normal_lpdf(z_60[1]);
  target += std_normal_lpdf(z_61[1]);
  target += std_normal_lpdf(z_62[1]);
  target += std_normal_lpdf(z_63[1]);
  target += std_normal_lpdf(z_64[1]);
  target += std_normal_lpdf(z_65[1]);
  target += std_normal_lpdf(z_66[1]);
  target += std_normal_lpdf(z_67[1]);
  target += std_normal_lpdf(z_68[1]);
  target += std_normal_lpdf(z_69[1]);
  target += std_normal_lpdf(z_70[1]);
  target += std_normal_lpdf(z_71[1]);
  target += std_normal_lpdf(z_72[1]);
  target += std_normal_lpdf(z_73[1]);
  target += std_normal_lpdf(z_74[1]);
  target += std_normal_lpdf(z_75[1]);
  target += std_normal_lpdf(z_76[1]);
  target += std_normal_lpdf(z_77[1]);
}
generated quantities {
  // actual population-level intercept
  real b_mu10_Intercept = Intercept_mu10;
  // actual population-level intercept
  real b_mu11_Intercept = Intercept_mu11;
  // actual population-level intercept
  real b_mu12_Intercept = Intercept_mu12;
  // actual population-level intercept
  real b_mu2_Intercept = Intercept_mu2;
  // actual population-level intercept
  real b_mu3_Intercept = Intercept_mu3;
  // actual population-level intercept
  real b_mu4_Intercept = Intercept_mu4;
  // actual population-level intercept
  real b_mu5_Intercept = Intercept_mu5;
  // actual population-level intercept
  real b_mu6_Intercept = Intercept_mu6;
  // actual population-level intercept
  real b_mu7_Intercept = Intercept_mu7;
  // actual population-level intercept
  real b_mu8_Intercept = Intercept_mu8;
  // actual population-level intercept
  real b_mu9_Intercept = Intercept_mu9;


 //POSTSTRAT: Utility specification
  vector[N] mu1 = rep_vector(0.0, N);
  vector[N] mu2 = rep_vector(0.0, N);
  vector[N] mu3 = rep_vector(0.0, N);
  vector[N] mu4 = rep_vector(0.0, N);
  vector[N] mu5 = rep_vector(0.0, N);
  vector[N] mu6 = rep_vector(0.0, N);
  vector[N] mu7 = rep_vector(0.0, N);
  vector[N] mu8 = rep_vector(0.0, N);
  vector[N] mu9 = rep_vector(0.0, N);
  vector[N] mu10 = rep_vector(0.0, N);
  vector[N] mu11 = rep_vector(0.0, N);
  vector[N] mu12 = rep_vector(0.0, N);

  mu1 += 0;
  mu2 += Intercept_mu2;
  mu3 += Intercept_mu3;
  mu4 += Intercept_mu4;
  mu5 += Intercept_mu5;
  mu6 += Intercept_mu6;
  mu7 += Intercept_mu7;
  mu8 += Intercept_mu8;
  mu9 += Intercept_mu9;
  mu10 += Intercept_mu10;
  mu11 += Intercept_mu11;
  mu12 += Intercept_mu12;
	
  // Our output is pums (N_6) x alternatives (12)
  
  array[N_6, 12] real expect_ch;
 
  expect_ch = rep_array(0,N_6,12);

  

  array[N_6, 12] real<lower=0, upper=1> phi;

  phi = rep_array(0,N_6,12);

  for (g in 1:N_6) {
                vector[12] nmu = rep_vector(0,12);
                real nmu1 = 0;
                real nmu2 = 0;
                real nmu3 = 0;
                real nmu4 = 0;
                real nmu5 = 0;
                real nmu6 = 0;
		real nmu7 = 0;
                real nmu8 = 0;
                real nmu9 = 0;
                real nmu10 = 0;
                real nmu11 = 0;
                real nmu12 = 0;
                int total = 0;

	       expect_ch = rep_array(0,N_6,12);
               total = 0;
          for (a in 1:N_1) {
	    for (b in 1:N_2) {
              for (d in 1:N_3) {
		   for (e in 1:N_4) {
		     for (f in 1:N_5) {
			   for (h in 1:N_7) {
                                        

                                                                             
                             			     nmu10 = Intercept_mu10  + r_1_mu10_1[a] + r_2_mu10_1[b] + r_3_mu10_1[d]  + r_4_mu10_1[e] + r_5_mu10_1[f] + r_6_mu10_1[g] + r_7_mu10_1[h];
                             			     nmu11 =  Intercept_mu11  + r_8_mu11_1[a] + r_9_mu11_1[b] + r_10_mu11_1[d]   + r_11_mu11_1[e] + r_12_mu11_1[f] + r_13_mu11_1[g] + r_14_mu11_1[h];
                             			     nmu12 = Intercept_mu12  + r_15_mu12_1[a] + r_16_mu12_1[b]  + r_17_mu12_1[d]  + r_18_mu12_1[e] + r_19_mu12_1[f] + r_20_mu12_1[g] + r_21_mu12_1[h];
                             			     nmu2 =   Intercept_mu2  + r_22_mu2_1[a] + r_23_mu2_1[b] + r_24_mu2_1[d]   + r_25_mu2_1[e] + r_26_mu2_1[f] + r_27_mu2_1[g] + r_28_mu2_1[h];
                             			     nmu3 =  Intercept_mu3  + r_29_mu3_1[a] + r_30_mu3_1[b] + r_31_mu3_1[d]   + r_32_mu3_1[e] + r_33_mu3_1[f] + r_34_mu3_1[g] + r_35_mu3_1[h];
											 nmu4 =  Intercept_mu4  + r_36_mu4_1[a] + r_37_mu4_1[b] + r_38_mu4_1[d]   + r_39_mu4_1[e] + r_40_mu4_1[f] + r_41_mu4_1[g] + r_42_mu4_1[h];
											 nmu5 = Intercept_mu5  +  r_43_mu5_1[a] + r_44_mu5_1[b] + r_45_mu5_1[d]   + r_46_mu5_1[e] + r_47_mu5_1[f] + r_48_mu5_1[g] + r_49_mu5_1[h];
											 nmu6 = Intercept_mu6  +  r_50_mu6_1[a] + r_51_mu6_1[b] + r_52_mu6_1[d]   + r_53_mu6_1[e] + r_54_mu6_1[f] + r_55_mu6_1[g] + r_56_mu6_1[h];
											 nmu7 = Intercept_mu7  + r_57_mu7_1[a] + r_58_mu7_1[b] + r_59_mu7_1[d]   + r_60_mu7_1[e] + r_61_mu7_1[f] + r_62_mu7_1[g] + r_63_mu7_1[h];
											 nmu8 = Intercept_mu8  + r_64_mu8_1[a] + r_65_mu8_1[b] + r_66_mu8_1[d]   + r_67_mu8_1[e] + r_68_mu8_1[f] + r_69_mu8_1[g] + r_70_mu8_1[h];
											 nmu9 = Intercept_mu9  +  r_71_mu9_1[a] + r_72_mu9_1[b] + r_73_mu9_1[d]   + r_74_mu9_1[e] + r_75_mu9_1[f] + r_76_mu9_1[g] + r_77_mu9_1[h];

				 nmu = transpose([nmu1, nmu2, nmu3, nmu4, nmu5, nmu6, nmu7, nmu8, nmu9, nmu10, nmu11, nmu12]);
			     total += P[b, d, e, g, f, h, a];   
                 vector[12] new_row = softmax(nmu);              
                 expect_ch[g, 1]
                 += P[b, d, e, g, f, h, a]
                 * new_row[1]; 
                 expect_ch[g, 2]
                 += P[b, d, e, g, f, h, a]
                 * new_row[2]; 
                 expect_ch[g, 3]
                 += P[b, d, e, g, f, h, a]
                 * new_row[3]; 
                 expect_ch[g, 4]
                 += P[b, d, e, g, f, h, a]
                 * new_row[4]; 
                 expect_ch[g, 5]
                 += P[b, d, e, g, f, h, a]
                 * new_row[5]; 
                 expect_ch[g, 6]
                 += P[b, d, e, g, f, h, a]
                 * new_row[6]; 
                 expect_ch[g, 7]
                 += P[b, d, e, g, f, h, a]
                 * new_row[7];
                 expect_ch[g, 8]
                 += P[b, d, e, g, f, h, a]
                 * new_row[8];
                 expect_ch[g, 9]
                 += P[b, d, e, g, f, h, a]
                 * new_row[9];
                 expect_ch[g, 10]
                 += P[b, d, e, g, f, h, a]
                 * new_row[10];
                 expect_ch[g, 11]
                 += P[b, d, e, g, f, h, a]
                 * new_row[11];
                 expect_ch[g, 12]
                 += P[b, d, e, g, f, h, a]
                 * new_row[12];				 
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
      phi[g,7] = expect_ch[g,7] / total;
      phi[g,8] = expect_ch[g,8] / total;
      phi[g,9] = expect_ch[g,9] / total;
      phi[g,10] = expect_ch[g,10] / total;
      phi[g,11] = expect_ch[g,11] / total;
      phi[g,12] = expect_ch[g,12] / total;
    }
  
}

