# spr-fem-analysis

Independent finite-element analysis of a multilayer surface-plasmon-resonance (SPR) biosensor for cystatin C detection.

**Stack:** prism (Ohara S-FPL53) / Al2O3 14 nm / Cu 48 nm / Ni 3 nm / ZnS 4 nm / analyte, at lambda = 633 nm.

## What this is

A finite-element model built from the Maxwell weak form, not from any transfer-matrix result. The solver receives only the wavelength, the layer thicknesses and the refractive indices. It locates the resonance angle, minimum reflectance, linewidth and field amplitudes itself. The transfer-matrix method appears only at the final validation step.

Two independent FEM formulations are included:

| | Model A | Model B |
|---|---|---|
| Unknown | scalar Hz | vector E = (Ex, Ey) |
| Space | H1 Lagrange | Nedelec H(curl) |
| Mesh | structured quadrilateral | unstructured triangular |
| Equation | div[(1/eps) grad Hz] + (k0^2 - kx^2/eps) Hz = 0 | curl curl E - k0^2 eps E = 0 |

They share no code and each performs its own blind angular sweep. Agreement between them, and with the transfer-matrix method, is the verification argument.

## Headline results

| Quantity | Value |
|---|---|
| Resonance angle, base analyte | 84.7263 deg |
| Sensitivity, 10 mg/mL | 547.18 deg/RIU |
| Minimum reflectance range | 0.01933 to 0.05530 |
| Max abs(Hz/Hz_inc) | 5.4174, at the Ni/ZnS boundary, not the sensing surface |
| Max abs(E/E_inc) | 6.2769, on the analyte side of the sensing surface |
| abs(Ey)/abs(Ex) at the interface | 2.76 (normal component dominates) |
| Intensity penetration depth | 97.3 nm |
| Power balance R + A + T | 1.0000000000 at every angle |
| Model A vs Model B | max deviation 2.4e-5 |
| FEM vs TMM | 1.9e-8 on resonance angle, R_min, FWHM |

## Layout

```
cystatinC/          one folder per analysis step
  _shared/          solver modules used by every step
  00_schematic/     sensor schematic
  01_reflectance/   resonance, R_min, FWHM, sensitivity, FOM, QF
  02_fields/        field distribution and evanescent decay
  03_convergence/   mesh, element order and buffer convergence
  03b_cross_verification/   vector FEM vs scalar FEM
  04_validation/    FEM vs transfer-matrix method
  05_table/         publication table generation
  06_main_figure/   combined field figure
  07_mesh_figure/   mesh figure
  08_3d_surface/    3D field surface
  09_field_bands/   layer-banded field profile in kV/m
manuscript/         drafted manuscript section and tables
```

Each step folder holds its own code, data tables, figures and a README explaining what the step does and what each figure shows.

## Running it

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Dependencies: ngsolve, numpy, scipy, matplotlib.

Run a step from inside its folder, with the shared modules on the path:

```bash
cd cystatinC/01_reflectance
PYTHONPATH=../_shared python run_01_reflectance.py
```

Steps 04 and 05 read the CSV files written by step 01, so run 01 first.

## Changing the design

Every physical input lives in one block at the top of `cystatinC/_shared/fem_E.py`: wavelength, refractive indices, layer sequence and analyte indices. Add or reorder layers in `STACK` and the geometry, mesh, interface positions and figures follow automatically. Nothing downstream assumes five layers.

Discretisation settings in the same block are the converged values established by step 03. Re-run that step after any design change, and delete the cached files `convergence_state.json` and `figmain_cache.npz`.

## Caveats

The Cu and Ni optical constants have not been verified against a primary tabulation. The resonance angle is robust to them; the minimum reflectance and field-enhancement magnitudes are not.

The resonance sits between 84.7 and 85.8 degrees, close to grazing incidence. This is physically real, but the coupling feasibility deserves discussion.
