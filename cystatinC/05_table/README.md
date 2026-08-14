# 05 — Publication comparison table

**Code:** `run_05_table.py`

Generates the FEM against TMM comparison table in LaTeX (booktabs, `table*` environment) and markdown, straight from `12_fem_vs_tmm.csv`. Nothing is retyped, so the table cannot drift from the data.

Outputs: `Table_FEM_vs_TMM.tex`, `Table_FEM_vs_TMM.md`.

The table lists both methods on separate rows per analyte, then a final row giving the maximum relative deviation per column. That last row is what makes the table worth printing; without it a reader sees two identical rows and wonders why both are shown.

One presentation note: the Base row carries FWHM (2.2380 deg) where the original manuscript table left it blank. Both methods compute it; only S, DA, FOM and QF are genuinely undefined for the reference sample. Keep or blank it, but be consistent if both tables appear in the same paper.

```bash
PYTHONPATH=../_shared python run_05_table.py
```

Requires step 04 to have run.

---

The remaining folders are figure generators. They compute nothing new; each reads the field data written by step 02 and renders it a different way.

# 06 — Combined field figure

**Code:** `run_06_main_figure.py` — **Figure:** `Fig_MAIN_field_analysis`

Three panels, intended as the main-text FEM figure. (a) Total electric field map with the ZnS/analyte interface marked. (b) Normal profiles of abs(E) and abs(Hz) with the layer stack labelled and both maxima annotated. (c) Evanescent decay against `z = y - y_s` with the exponential fits, per-analyte decay constants compared against the analytic value from the dispersion relation, and the intensity penetration depth boxed.

Panel (c) reports the fitted and analytic alpha side by side rather than a goodness-of-fit statistic. The field there is a single exponential by construction, so a high R-squared would be circular; the analytic comparison is not.

Caches expensive solves in `figmain_cache.npz`. Delete it after any physics change.

# 07 — Mesh figure

**Code:** `run_07_mesh_figure.py` — **Figure:** `FigS_mesh`

The triangular mesh at three magnifications: whole domain, active layers, and the Ni/ZnS/analyte region. Layer names sit in a strip at the right with leader lines, so the 3 nm and 4 nm films can be labelled without text collisions.

Element size is assigned per layer according to how quickly the field varies in each medium, not according to layer thickness, so the 48 nm Cu film does not receive coarser elements than the 3 nm Ni film.

# 08 — 3D field surface

**Code:** `run_08_3d_surface.py` — **Figure:** `FigS_3D_field_surface`

Height-surface rendering. The Bloch solution stores the propagation phase separately as `E(x,y) = u(y) exp(i kx x)`, so the physical field over any lateral extent is recoverable exactly from the 4 nm computational cell without further solving.

Panel (a) plots `Re{Ey/E_inc}` over 2.5 plasmon periods, showing the travelling surface wave; the ridge spacing is the surface-plasmon wavelength, 441.5 nm. Panel (b) plots the magnitude envelope, deliberately flat along x, which together with (a) makes the point that the ripples are phase structure rather than intensity structure.

Supplementary material. It shows the same solution as step 06 in a different projection, so it would be redundant in a main-text slot.

# 09 — Layer-banded field profile

**Code:** `run_09_field_bands.py` — **Figure:** `Fig_field_profile_bands`

Field magnitude across the stack in absolute units, with hatched prism and analyte regions and solid bands for the films.

The absolute scale is fixed by stating the incident intensity rather than by picking a field value: `|E_inc| = sqrt(2 I / (c eps0 n_prism))`. At I = 1 kW/cm2 this gives `|E_inc|` = 72.4 kV/m and a peak of 401.1 kV/m at the sensing interface. The FEM problem is linear, so the whole profile scales with the excitation; change `I_INC` at the top of the script to rescale.

State the excitation in the caption. An absolute-field plot without it cannot be checked by a reader.

The step at 69 nm is the discontinuity in the interface-normal component across the ZnS/analyte boundary, not a plotting artefact.
