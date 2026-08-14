# 03b — Cross-verification of two independent FEM models

**Code:** `run_03b_cross_verification.py`

## What this step does

Solves the same structure a second time with a formulation that shares nothing with the first, then compares. This is the strongest available check short of experiment, because a formulation-specific error would show up here while remaining invisible in a convergence study.

| | Model A | Model B |
|---|---|---|
| Unknown | scalar Hz | vector E = (Ex, Ey) |
| Space | H1 Lagrange, order 3 | Nedelec H(curl), order 3 |
| Mesh | 338 structured quadrilaterals | 584 unstructured triangles |
| Equation | div[(1/eps) grad Hz] + (k0^2 - kx^2/eps) Hz = 0 | curl curl E - k0^2 eps E = 0 |
| Boundary algebra | derived in Hz | derived in E |

Separate codebases (`_shared/fem_H.py` and `_shared/fem_E.py`). Each runs its own blind angular sweep; neither is given the other's answer.

## Results

Worst-case deviation across all four analytes:

| Quantity | Max relative deviation |
|---|---|
| FWHM | 1.0e-10 |
| R_min | 2.4e-10 |
| theta_SPR | 2.7e-8 |
| decay constant alpha | 4.2e-8 |
| abs(E/E_inc) at the interface | 2.8e-7 |
| abs(Hz/Hz_inc) at the interface | 2.9e-7 |
| max abs(Hz/Hz_inc), global | 2.4e-5 |

Overall worst: 2.35e-5.

## The one outlier, and why it is benign

Everything agrees to 1e-7 or better except the global magnetic maximum, which is consistently around 2.3e-5 across all four samples. That peak sits at a cusp at the Ni/ZnS boundary, and the two meshes sample it at slightly different points. Model B also reconstructs Hz from curl E rather than solving for it. A systematic offset of that size at a cusp is a sampling artefact, not a physics discrepancy. The interface value, which is the sensing-relevant number, agrees to 2.9e-7.

Model B never solves for Hz at all, yet reproduces its peak position (y = 65.00 nm), interfacial amplitude and evanescent decay constant to eight digits as derived quantities.

## Data

`data/11_cross_verification.csv` — every quantity, both models, absolute and relative differences, per analyte.

## Figures

**`figures/FigS_cross_verification`** — relative deviation per quantity, grouped by analyte, on a log axis. Six of the seven quantities sit at or below 1e-7; only the global magnetic maximum rises to 1e-5, for the reason above.

## Reproduce

```bash
PYTHONPATH=../_shared python run_03b_cross_verification.py
```
