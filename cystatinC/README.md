# cystatinC

One folder per analysis step. Each holds the code that produces the step, the data tables it writes, the figures it draws, and a README explaining what the step does and what each figure shows.

## Steps

| Folder | Produces | Runtime |
|---|---|---|
| `00_schematic` | sensor schematic (Fig. 1) | seconds |
| `01_reflectance` | resonance angle, R_min, FWHM, S, DA, FOM, QF | ~1 min |
| `02_fields` | field enhancement, evanescent decay | ~2 min |
| `03_convergence` | mesh, Cu, element-order and buffer convergence | ~10 min |
| `03b_cross_verification` | vector FEM vs scalar FEM | ~2 min |
| `04_validation` | FEM vs transfer-matrix method | seconds |
| `05_table` | publication table (LaTeX + markdown) | instant |
| `06_main_figure` | combined 3-panel field figure | ~1 min |
| `07_mesh_figure` | mesh figure | seconds |
| `08_3d_surface` | 3D field surface | ~30 s |
| `09_field_bands` | layer-banded field profile in kV/m | seconds |

Order matters in two places. Steps 04 and 05 read the CSV files written by step 01. Steps 06, 08 and 09 read the field data written by step 02.

## `_shared`

The solver modules live here rather than being copied into every folder, so there is one source of truth.

| File | Role |
|---|---|
| `fem_E.py` | main solver: vector E, Nedelec H(curl), triangular mesh, exact Dirichlet-to-Neumann boundary conditions. All physical inputs are in the block at the top |
| `fem_H.py` | second, unrelated FEM: scalar Hz, H1 Lagrange, quadrilateral mesh. Used only for cross-verification in step 03b |
| `tmm_ref.py` | transfer-matrix reference. Used only in step 04 |
| `figkit.py` | figure helper: layer labelling with automatic de-collision |
| `paths.py` | output directory |
| `_p3_common.py` | shared convergence-study machinery for step 03 |

Run any step with the shared modules on the path:

```bash
cd cystatinC/01_reflectance
PYTHONPATH=../_shared python run_01_reflectance.py
```

## Method in one paragraph

For p-polarised light the time-harmonic Maxwell system reduces to `curl curl E - k0^2 eps_r E = 0`. A Floquet substitution `E = u exp(i kx x)` with `u` periodic carries the angular dependence through `kx = k0 n_prism sin(theta)`, and the lateral boundary terms cancel between trial and test functions. Nedelec curl-conforming elements enforce continuity of the tangential field at every interface while allowing the normal component to jump by the permittivity ratio, which is the physical condition at a metal/dielectric boundary. Both semi-infinite media are truncated with exact Dirichlet-to-Neumann relations rather than a perfectly matched layer, which is why the results are independent of buffer thickness (step 03 demonstrates this). An independent check runs at every angle: reflected plus absorbed plus transmitted power sums to 1.0000000000.

## Independence

No transfer-matrix or literature value is used as a target, initial guess, fixed parameter or convergence reference anywhere in steps 00 to 03b. Every error in the convergence study is measured against the model's own most-resolved solution. The transfer-matrix method enters only in step 04, after the FEM results are final.
