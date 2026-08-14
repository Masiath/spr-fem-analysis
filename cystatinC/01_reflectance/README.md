# 01 — Angular reflectance and performance metrics

**Code:** `run_01_reflectance.py`

## What this step does

Sweeps the incidence angle for each analyte and lets the solver find the resonance without being told where it is. The search runs in three stages: a blind coarse sweep from just above the critical angle to grazing incidence, bracketing of the reflectance minimum, then bounded Brent refinement to a tolerance of 1e-6 degrees. The linewidth is obtained by bracketing and Brent root-finding on `R(theta) - R_half`, not by interpolating a fixed grid, so the crossing angles are resolved to 1e-7 degrees.

The reflection coefficient comes from the tangential trace on the prism face, `r = a + (k0 eps1 / ky1) Ex`, which follows from the Dirichlet-to-Neumann decomposition rather than from a post-hoc fit.

## Results

| Sample | RI (RIU) | theta_SPR (deg) | S (deg/RIU) | R_min | FWHM (deg) | DA (1/deg) | FOM (1/RIU) | QF (1/RIU) |
|---|---|---|---|---|---|---|---|---|
| Base | 1.334800 | 84.7263 | – | 0.01933 | 2.2380 | – | – | – |
| 1 mg/mL | 1.334985 | 84.8194 | 503.10 | 0.02161 | 2.2600 | 0.4425 | 217.80 | 222.61 |
| 5 mg/mL | 1.335725 | 85.2083 | 521.01 | 0.03315 | 2.3586 | 0.4240 | 213.57 | 220.89 |
| 10 mg/mL | 1.336650 | 85.7386 | 547.18 | 0.05530 | 2.5124 | 0.3980 | 205.75 | 217.79 |

Power balance was 1.000000000 at every angle, which verifies the weak form and the boundary conditions without reference to any external result.

## Data

| File | Contents |
|---|---|
| `data/01_performance_metrics.csv` | the table above, plus both QF conventions and the power balance |
| `data/02_reflectance_curves.csv` | R(theta) for all four analytes over the full sweep |

## Figures

**`figures/FigS_reflectance`** — angular reflectance for all four analyte concentrations, with the located minimum marked on each curve. The dip deepens and broadens as concentration rises: R_min goes from 0.019 to 0.055 and FWHM from 2.24 to 2.51 degrees. Sensitivity improves with concentration while coupling efficiency degrades, so the two effects pull the figure of merit in opposite directions.

## Note on QF

Two conventions are in circulation. `QF = S / FWHM` gives 222.61 to 217.79 across the concentration range; `QF = theta_SPR / FWHM` gives 37.53 to 34.13. Both columns are in the CSV. The tables here use `S / FWHM`.

## Reproduce

```bash
PYTHONPATH=../_shared python run_01_reflectance.py
```

Steps 04 and 05 read the CSV files this step writes, so run this one first.
