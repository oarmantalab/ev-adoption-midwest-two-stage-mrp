# Potential for Electric Vehicle Adoption in Midwest US States: A Stated Preference and Two-Stage MRP Study

Reproducible code for the paper:

> Armantalab, O., Ghosh, R., & Hawkins, J. (2026). *Potential for electric vehicle
> adoption in Midwest US States: A stated preference and two-stage MRP study.*
> **Journal of Choice Modelling, 59, 100597.**
> https://doi.org/10.1016/j.jocm.2026.100597

This repository contains the end-to-end pipeline used to forecast the light-duty
vehicle fleet (vehicle class × powertrain) at the Public Use Microdata Area
(PUMA) level across seven US Midwest states (IA, KS, MN, MO, NE, ND, SD), using a
**two-stage multi-level regression with poststratification (MRP)** choice model
estimated from a stated-preference survey.

---

## Overview

The study jointly models the choice of **vehicle class** (small car, large car,
pickup truck) and **powertrain** (gasoline vs. electric) across six alternatives:

| # | Alternative | # | Alternative |
|---|-------------|---|-------------|
| 1 | Small Gas (reference) | 4 | Large BEV |
| 2 | Small BEV | 5 | Pickup Truck Gas |
| 3 | Large Gas | 6 | Pickup Truck BEV |

The key methodological contribution is a **two-stage MRP** that corrects for bias
not only in the survey's demographic composition (census poststratification) but
also in its vehicle-fleet composition (Experian vehicle-registration data),
reconciled with Iterative Proportional Fitting (IPF).

```
                            ┌──────────────┐
          Survey data ─────▶│  Stage 1:    │
                            │  Current-    │──┐
                            │  vehicle MRP │  │  per-cell vehicle-type
                            └──────────────┘  │  probabilities
  Socio-economic                              ▼
  poststrat table  ───────────────▶ ┌──────────────┐
  (2016–2020 ACS)                   │  Stage 1b:   │
                                    │     IPF      │◀── Experian vehicle
                                    └──────────────┘    registration data
                                           │
                                           ▼  joint demographic × vehicle
                                              poststratification table
                            ┌──────────────┐
          Survey data ─────▶│  Stage 2:    │
                            │  SCE vehicle │─────▶  PUMA-level fleet forecast
                            │  MRP         │        (main results, Figs. 8–11)
                            └──────────────┘
```

---

## Repository structure

```
.
├── config.R                         # central path/seed configuration (edit once)
├── requirements-R.txt               # R package dependencies
├── requirements-python.txt          # Python dependencies (IPF step)
│
├── 01_data_prep/                    # STAGE 0 — Experian registration cleaning
│   ├── 01_experian_extract_counties.R    # parquet → county lookup
│   ├── 02_experian_recode_vehicle.R      # fine body styles → 3 classes × 4 powertrains
│   └── 03_experian_aggregate_shares.R    # → PUMA × type1..type12 marginal shares
│
├── 02_stage1_current_vehicle_mrp/   # STAGE 1 — demographic (current-vehicle) MRP
│   ├── produce_stan_data_demographic.R   # brms → Stan data list (demographics only)
│   ├── demographic_model.stan            # 12-category categorical-logit MRP model
│   ├── run_demographic_model.R           # fit with cmdstanr
│   └── poststratify_demographic.R        # → per-cell 12 vehicle-type probabilities
│
├── 03_stage1_ipf/                   # STAGE 1b — IPF reconciliation
│   ├── ipf_reconciliation.py             # script version
│   └── ipf_reconciliation.ipynb          # notebook version (equivalent)
│
├── 04_stage2_sce_mrp/               # STAGE 2 — stated-choice vehicle MRP
│   ├── produce_stan_data.R               # brms → Stan data list (SCE design)
│   ├── build_poststrat_array.R           # build joint poststratification array P
│   ├── sce_poststrat_model.stan          # main model (poststrat in gen. quantities)
│   ├── sce_poststrat_model_policy.stan   # policy-scenario variant (Fig. 11 B/C)
│   └── run_sce_model.R                    # fit + export PUMA fleet shares (phi)
│
├── 05_figures/                      # FIGURES
│   ├── plot_puma_results.R               # box plots (Fig. 8) + heatmaps (Fig. 9)
│   └── plot_state_shares.R               # state stacked bars (Fig. 11)
│
├── data/            raw / interim / processed   (inputs — not distributed)
└── outputs/         fits / tables / figures     (generated)
```

---

## Requirements

- **R ≥ 4.2** with [CmdStanR](https://mc-stan.org/cmdstanr/) and a working
  CmdStan toolchain, plus the packages listed in `requirements-R.txt`.
- **Python ≥ 3.9** with the packages in `requirements-python.txt` (IPF step only).

```r
# R packages
install.packages(c("here","tidyverse","brms","tidybayes","broom.mixed",
                   "fastDummies","arrow","patchwork","viridis","gridExtra"))
install.packages("cmdstanr", repos = c("https://stan-dev.r-universe.dev", getOption("repos")))
cmdstanr::install_cmdstan()
```

```bash
# Python packages
pip install -r requirements-python.txt
```

All R scripts locate the project root with the `here` package (via the `.here`
marker file) and read/write paths defined in **`config.R`** — edit that file once
and every script resolves its inputs and outputs automatically. No `setwd()` and
no absolute paths are used anywhere.

---

## Data

> **Note on data availability.** As stated in the paper, the authors do not have
> permission to redistribute the survey or the Experian vehicle-registration
> data. This repository therefore ships **code only**. Place your own copies of
> the input files in `data/` as described below; expected file names and column
> layouts are documented at the top of each script and in `data/README.md`.

| File (place in) | Produced by / source | Used by |
|---|---|---|
| `data/raw/COUNTY_2021.parquet` | Experian | `01_experian_extract_counties.R` |
| `data/raw/VC_i_output.csv` | Experian | `02_experian_recode_vehicle.R` |
| `data/processed/model_ev_data.csv` | survey (long SCE format) | `produce_stan_data*.R` |
| `data/processed/dem_poststrat.csv` | 2016–2020 ACS poststrat table | `poststratify_demographic.R` |

Intermediate products (`new_post.csv`, `new2.csv`, `joint_poststrat_table.csv`,
the Stan data `.rds` lists, the fitted `.RDS` objects, and the summary tables)
are written to `data/interim/`, `data/processed/` and `outputs/` as the pipeline
runs.

---

## How to reproduce

Run from the repository root, in order:

```bash
# ── Stage 0: clean the Experian vehicle-registration data ──────────────────
Rscript 01_data_prep/01_experian_extract_counties.R
Rscript 01_data_prep/02_experian_recode_vehicle.R
Rscript 01_data_prep/03_experian_aggregate_shares.R        # → new2.csv

# ── Stage 1: demographic (current-vehicle) MRP ─────────────────────────────
Rscript 02_stage1_current_vehicle_mrp/produce_stan_data_demographic.R
Rscript 02_stage1_current_vehicle_mrp/run_demographic_model.R
Rscript 02_stage1_current_vehicle_mrp/poststratify_demographic.R   # → new_post.csv

# ── Stage 1b: IPF reconciliation ───────────────────────────────────────────
python 03_stage1_ipf/ipf_reconciliation.py                  # → joint_poststrat_table.csv

# ── Stage 2: stated-choice vehicle MRP ─────────────────────────────────────
Rscript 04_stage2_sce_mrp/produce_stan_data.R
Rscript 04_stage2_sce_mrp/build_poststrat_array.R           # attach joint array P
Rscript 04_stage2_sce_mrp/run_sce_model.R                   # → PUMA fleet forecast

# ── Figures ────────────────────────────────────────────────────────────────
Rscript 05_figures/plot_puma_results.R
Rscript 05_figures/plot_state_shares.R
```

### Policy scenarios (Fig. 11 B/C)

Rebuild the poststratification array with `N_VEHICLE = 12` in
`build_poststrat_array.R`, point `MODEL_FILE` in `run_sce_model.R` at
`sce_poststrat_model_policy.stan`, and set the counterfactual attribute offsets
in that model's generated-quantities block (e.g. +20 % BEV pickup incentive, or
−20 % station charging time).

---

## Modelling notes

- **Model family.** Bayesian multinomial (categorical-logit) choice models fit
  with Hamiltonian Monte Carlo via CmdStan. The Stan files are brms-generated and
  then extended by hand with (a) sign-constrained, lognormal-prior attribute
  coefficients shared across alternatives, and (b) a poststratification loop in
  the `generated quantities` block that produces subpopulation choice
  probabilities `phi`.
- **Varying intercepts.** PUMA (111), metro (5), sex (2), age (7), education (4),
  education×age (28), income (12), and — in Stage 2 only — current vehicle type,
  which couples the two stages.
- **Sampler settings.** The paper uses 4 chains × 400 iterations (200 warmup).
  The runner scripts ship with modest iteration counts for a quick smoke-test;
  increase `iter_warmup` / `iter_sampling` for a production fit, and check
  convergence (R-hat < 1.1).
- **The `phi` output** of `run_sce_model.R` (one share per PUMA × alternative) is
  the main result and feeds all PUMA- and state-level figures.

---

## Citation

If you use this code, please cite the paper (see `CITATION.cff`).

## License

No license is set yet — add one (e.g. MIT) before publishing if you intend others
to reuse the code. The input data are **not** covered by any license here and are
not included.
