"""
ipf_reconciliation.py
---------------------------------------------------------------------------
STAGE 1b - Iterative Proportional Fitting (IPF) reconciliation

Reconciles the two halves of the first-stage poststratification table:

  * ROWS  (human population):  per-cell vehicle-type probabilities predicted by
                               the demographic MRP model
                               (new_post.csv, columns col_1..col_12), scaled by
                               the cell population weight `perwt`.
  * COLS  (vehicle population): per-PUMA vehicle-type marginal shares from the
                               Experian registration data
                               (new2.csv, columns type1..type12).

For every PUMA the demographic x vehicle-type matrix is adjusted by IPF so that
its row sums match the cell populations and its column sums match the Experian
vehicle marginals. The stacked result is the JOINT demographic-vehicle post-
stratification table consumed by the Stage-2 model (build_poststrat_array.R).

Inputs  : data/interim/new_post.csv   (cell demographics + perwt + col_1..col_12)
          data/interim/new2.csv       (pums + type1..type12 shares)
Output  : data/interim/joint_poststrat_table.csv  (col_1..col_12 + pums index i)

Run     : python 03_stage1_ipf/ipf_reconciliation.py
---------------------------------------------------------------------------
"""

from pathlib import Path

import numpy as np
import pandas as pd

# --- Paths (relative to the repository root) --------------------------------
ROOT = Path(__file__).resolve().parents[1]
INTERIM = ROOT / "data" / "interim"

CELLS_FILE = INTERIM / "new_post.csv"   # demographic MRP output
MARGS_FILE = INTERIM / "new2.csv"       # Experian PUMA vehicle marginals
OUT_FILE = INTERIM / "joint_poststrat_table.csv"

N_PUMAS = 111          # number of PUMAs in the study region
N_TYPES = 12           # vehicle types (3 classes x 4 powertrains)
MAX_ITERS = 10         # IPF iterations per PUMA
TOL = 1e-4             # convergence tolerance on the L2 marginal residuals

TYPE_COLS = [f"col_{j}" for j in range(1, N_TYPES + 1)]
MARG_COLS = [f"type{j}" for j in range(1, N_TYPES + 1)]


def ipf_update(M, u, v):
    """One IPF sweep: scale rows to targets `u`, then columns to targets `v`."""
    r_sums = M.sum(axis=1, keepdims=True)
    N = M * (u[:, None] / np.where(r_sums == 0, 1, r_sums))

    c_sums = N.sum(axis=0, keepdims=True)
    O = N * (v[None, :] / np.where(c_sums == 0, 1, c_sums))

    d_u = np.linalg.norm(u - O.sum(axis=1), 2)
    d_v = np.linalg.norm(v - O.sum(axis=0), 2)
    return O, d_u, d_v


def reconcile_puma(cells, margins, pums):
    """Return the IPF-reconciled cell x vehicle-type matrix for one PUMA."""
    rows = cells[cells["pums_idx"] == pums]

    # Expected counts per cell = population weight x predicted type probability.
    probs = rows[TYPE_COLS].to_numpy(dtype=float)
    perwt = rows["perwt"].to_numpy(dtype=float)
    X = probs * perwt[:, None]

    # Row targets u: the cell populations. Column targets v: Experian shares
    # scaled to the same PUMA total so both margins are consistent.
    u = X.sum(axis=1)
    HH = u.sum()
    shares = margins.loc[margins["pums"] == pums, MARG_COLS].to_numpy(dtype=float).ravel()
    v = HH * shares

    M = X.copy()
    for _ in range(MAX_ITERS):
        M, d_u, d_v = ipf_update(M, u, v)
        if d_u <= TOL and d_v <= TOL:
            break
    return M, d_u, d_v


def main():
    cells = pd.read_csv(CELLS_FILE)
    margins = pd.read_csv(MARGS_FILE)

    frames = []
    for i in range(1, N_PUMAS + 1):
        M, d_u, d_v = reconcile_puma(cells, margins, i)
        df_i = pd.DataFrame(M, columns=TYPE_COLS)
        df_i["i"] = i
        frames.append(df_i)
        print(f"PUMA {i:3d}:  d_u = {d_u:.5f}, d_v = {d_v:.5f}")

    out = pd.concat(frames, ignore_index=True)
    out.to_csv(OUT_FILE, index=False)
    print(f"\nWrote joint poststratification table -> {OUT_FILE}")


if __name__ == "__main__":
    main()
