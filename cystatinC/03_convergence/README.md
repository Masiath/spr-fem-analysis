# 03 — Convergence and discretisation study

**Code:** `run_03_convergence.py` (uses `_shared/_p3_common.py`)

## What this step does

Establishes that the reported quantities are converged, using the model's **own** most-resolved solution as the reference: 3381 elements, Nedelec order 4, 77465 degrees of freedom. No transfer-matrix or literature value enters at any point. Four studies run: global mesh scale at three element orders, Cu element size, element order on a fixed coarse mesh, and buffer thickness on both semi-infinite sides.

Run in stages if you prefer:

```bash
PYTHONPATH=../_shared python run_03_convergence.py mesh
PYTHONPATH=../_shared python run_03_convergence.py cu order buffer
```

State is cached in `convergence_state.json`. Delete it after any change to the design.

## Mesh-scale convergence

Maximum relative deviation from the self-reference:

| maxh scale | order 1 | order 2 | order 3 |
|---|---|---|---|
| 8 | 5.7e-2 | 6.8e-4 | 9.5e-7 |
| 4 | 6.2e-2 | 5.3e-4 | 9.4e-7 |
| 2 | 2.9e-2 | 5.1e-5 | 2.2e-8 |
| 1 | 1.0e-2 | 6.2e-6 | 2.1e-8 |
| 0.5 | 4.4e-3 | 1.9e-6 | 1.6e-8 |

## Element-order convergence, fixed 144-element mesh

| order | DOF | theta_SPR | R_min | max rel. deviation | observed rate |
|---|---|---|---|---|---|
| 0 | 286 | 84.4465 | 0.013915 | 2.8e-1 | – |
| 1 | 572 | 84.5717 | 0.018123 | 6.2e-2 | 2.17 |
| 2 | 1290 | 84.7260 | 0.019319 | 5.3e-4 | 5.86 |
| 3 | 2296 | 84.72633 | 0.0193288 | 9.4e-7 | 10.99 |
| 4 | 3590 | 84.72633 | 0.0193288 | 2.3e-8 | – |

Raising the order on the same mesh drops the error by seven orders of magnitude, with the rate climbing 2.2, 5.9, 11.0 — the exponential behaviour expected for a piecewise-analytic solution. Order 3 on 144 elements (2296 DOF) beats order 1 on 2046 elements (6592 DOF) by four orders of magnitude, so p-refinement rather than h-refinement was adopted.

## Cu element size

The 4 nm Floquet cell width bounds the triangle size, so Cu maxh above about 4 nm is inactive and the sweep starts there.

| h_Cu (nm) | order 1: theta_SPR | error | order 3: theta_SPR | error |
|---|---|---|---|---|
| 4 | 84.6927 | 1.4e-2 | 84.7263303 | 1.8e-8 |
| 2 | 84.7128 | 1.0e-2 | 84.7263304 | 2.1e-8 |
| 1 | 84.7183 | 7.8e-3 | 84.7263304 | 2.3e-8 |
| 0.5 | 84.7205 | 6.6e-3 | 84.7263303 | 1.6e-8 |

At order 1 the Cu mesh controls the error and is still 0.66 percent off at 0.5 nm elements. At order 3 it is irrelevant across the whole range: the cubic edge basis resolves the field decay inside the metal without geometric refinement.

## Buffer independence

| prism buffer (nm) | error | | analyte buffer (nm) | error |
|---|---|---|---|---|
| 25 | 2.1e-8 | | 100 | 1.4e-8 |
| 50 | 1.4e-8 | | 200 | 1.9e-7 |
| 100 | 2.1e-8 | | 350 | 1.8e-8 |
| 150 | 2.1e-8 | | 500 | 2.1e-8 |
| 300 | 1.9e-8 | | 900 | 1.8e-8 |

Flat to the root-finder floor over a 12x range on the prism side and 9x on the analyte side. There is no trend to converge away because both outer conditions are exact Dirichlet-to-Neumann relations rather than absorbing layers. A PML-based model would show a visible tail here and would need thickness and stretching parameters tuned. The analyte buffer can sit at half the evanescent decay length without loss.

## Production settings

Nedelec order 3, baseline maxh set, h_Cu 2 nm, prism buffer 150 nm, analyte buffer 500 nm. Each is at least one refinement level past the 0.01 percent criterion.

The 1e-7 to 1e-8 floor is the resonance and FWHM root-finder tolerance (`xatol` 1e-6 degrees), not discretisation error. Convergence rates are not reported below it.

## Data

`data/05_convergence_mesh.csv`, `06_convergence_cu_order1.csv`, `07_convergence_cu_order3.csv`, `08_convergence_order.csv`, `09_buffer_prism.csv`, `10_buffer_analyte.csv`.

## Figures

**`figures/FigS_mesh_convergence`** — maximum relative deviation against degrees of freedom for orders 1, 2 and 3, log-log, with the root-finder floor marked. The order-3 curve is flat because it starts already converged.

**`figures/FigS_order_buffer`** — left: error against element order on the fixed coarse mesh, showing the seven-decade drop. Right: error against buffer thickness for both sides, flat, which is the Dirichlet-to-Neumann result stated above.
