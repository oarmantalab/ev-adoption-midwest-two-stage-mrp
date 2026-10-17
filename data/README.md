# Data directory

The authors do not have permission to redistribute the survey or the Experian
vehicle-registration data, so **no data files are included in this repository**.
To run the pipeline, place your own copies of the inputs here. The pipeline
writes all intermediate and model-ready files into the sub-folders automatically.

```
data/
├── raw/          # untouched source data you provide
├── interim/      # intermediate products written by the scripts
└── processed/    # model-ready inputs (survey, poststrat table, Stan data lists)
```

## Required input files

### `data/raw/COUNTY_2021.parquet`  (Experian)
County-level vehicle-registration extract. Must include the columns
`State Code`, `County Code`, `State Abbr`, `County Name`, plus the vehicle
records. Used by `01_experian_extract_counties.R`.

### `data/raw/VC_i_output.csv`  (Experian)
Vehicle records with (at least) the columns `Vehicle` (body style), `Vehicle_f`
(fuel), `pums`, and `count`. Used by `02_experian_recode_vehicle.R`.

### `data/processed/model_ev_data.csv`  (survey)
The stated-choice survey in long format — one row per respondent × choice task.
Expected columns include: `p_weights`, `pums`/`pums_idx`, `metro`, `gender`,
`agec`, `educ`, `educ_age`, `inc_idx`, `choice`, `CUID`, `current_vehicle`
(1–12, for Stage 1), and the alternative attribute columns
(`sg_price`, `se_incen`, … see `produce_stan_data.R`).

### `data/processed/dem_poststrat.csv`  (2016–2020 ACS)
Census poststratification table — one row per demographic cell. Expected
columns: `pums_idx`, `metro`, `sex`, `agec`, `educ`, `age_educ`, `inc`,
`educ_age`, `perwt`. Used by `poststratify_demographic.R`.

## Generated intermediates (written by the pipeline)

| File | Written by |
|---|---|
| `interim/county_lookup.csv` | `01_experian_extract_counties.R` |
| `interim/updated_data.csv` | `02_experian_recode_vehicle.R` |
| `interim/new2.csv` | `03_experian_aggregate_shares.R` |
| `interim/new_post.csv` | `poststratify_demographic.R` |
| `interim/joint_poststrat_table.csv` | `ipf_reconciliation.py` |
| `processed/demog_stan_data.rds` | `produce_stan_data_demographic.R` |
| `processed/sce_stan_data.rds` | `produce_stan_data.R` |
| `processed/sce_stan_data_withP.rds` | `build_poststrat_array.R` |
