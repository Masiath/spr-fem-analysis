# 04 — Validation against the transfer-matrix method

**Code:** `run_04_validation.py` (uses `_shared/tmm_ref.py`)

## What this step does

This is the only place the transfer-matrix method appears. `tmm_ref.py` is an independent Python implementation of the characteristic-matrix method for p-polarisation. It imports the configuration and nothing else — no FEM quantity enters it, and it was written after the FEM results were final.

The FEM numbers are read back from the CSV written by step 01, not recomputed, so what is compared is exactly what the FEM reported.

## Results

Worst deviation per quantity, across all four analytes:

| Quantity | Max relative deviation |
|---|---|
| R_min | 2.2e-10 |
| FWHM | 8.0e-9 |
| theta_SPR | 1.9e-8 |
| S, FOM, QF | 2.3e-5 |

Pointwise `|R_FEM - R_TMM|` stays below 1e-7 across the full 68 to 90 degree sweep.

## Why sensitivity is the outlier

Sensitivity is a finite difference of two resonance angles separated by 0.093 degrees at 1 mg/mL. A residual angular error near 1e-7 degrees divides by that small gap and is amplified by roughly three orders of magnitude. FOM and QF inherit it because both are built from S. The amplification shrinks as the concentration gap widens (2.3e-5 at 1 mg/mL, 1.1e-6 at 5 mg/mL, 7.6e-7 at 10 mg/mL), which is the signature of that mechanism rather than of a numerical problem.

## What this comparison does and does not prove

For a planar multilayer the transfer-matrix method is the exact solution of the same boundary-value problem, so a converged FEM solution **must** reproduce it. Agreement is the expected outcome, not a discovery. The value lies in how the two solutions were obtained: different unknown, different function space, different mesh topology, different boundary treatment, and an unguided resonance search. Their agreement validates the reported figures of merit against implementation error in either method.

A reviewer asking why the FEM section exists should be pointed at step 02, which produces the interior field distribution, penetration depth and interfacial enhancement that the transfer-matrix formalism does not expose.

## Data

`data/12_fem_vs_tmm.csv` — FEM value, TMM value, absolute and relative difference for every quantity and analyte. Also includes a comparison against the values as printed in the manuscript table, where every difference is under half a unit in the last printed digit.

## Figures

**`figures/Fig_FEM_vs_TMM`** — two panels sharing an angle axis. Top: reflectance curves for all four analytes, TMM drawn thick and FEM dashed over it, indistinguishable at plotting resolution. Bottom: pointwise absolute difference on a log axis, below 1e-7 everywhere. The lower panel is what makes this figure worth including; the upper panel alone would just look like one set of curves.

## Reproduce

```bash
PYTHONPATH=../_shared python run_04_validation.py
```

Requires step 01 to have run.
