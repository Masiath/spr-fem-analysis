# 02 — Field distribution and evanescent decay

**Code:** `run_02_fields.py`

## What this step does

Re-locates the resonance on a refined mesh (2046 triangles, 29552 degrees of freedom), then evaluates the field. Because the vector formulation solves for E directly, `Ex` and `Ey` are primary unknowns rather than derivatives of `Hz`, so the interface-normal component that carries the sensing signal is available without differentiation.

Normalisation: with `hz` normalised to unity, a p-polarised plane wave in the prism has `|E_inc| = 1/n1`, so the plotted ratio is `|E|/|E_inc| = n1 |E|`. The quantity is the total magnitude, not a single component.

## Results

| Quantity | Base (84.7263 deg) | 10 mg/mL (85.7386 deg) |
|---|---|---|
| max abs(Hz/Hz_inc) | 5.417 | 4.788 |
| position of magnetic maximum | y = 65.00 nm (Ni/ZnS) | y = 65.00 nm (Ni/ZnS) |
| abs(Hz/Hz_inc) at sensing surface | 5.109 | 4.515 |
| max abs(E/E_inc) | 6.277 | 5.541 |
| position of electric maximum | y = 69.0 nm (analyte side) | y = 69.0 nm |
| abs(E/E_inc) on the ZnS side | 2.871 | 2.538 |
| discontinuity across the interface | 2.186 | 2.183 |
| abs(Ey)/abs(Ex) at the interface | 2.765 | 2.764 |
| alpha (1/nm) | 0.005139 | 0.005149 |
| amplitude decay length 1/alpha | 194.6 nm | 194.2 nm |
| intensity penetration depth 1/2alpha | 97.3 nm | 97.1 nm |
| lateral field variation across the cell | 4.6e-10 | 5.6e-10 |

## Two results that are easy to conflate

The **magnetic** maximum is at the Ni/ZnS boundary, 4 nm inside the stack, not at the sensing surface. The **electric** maximum is on the analyte side of the sensing surface and jumps by a factor 2.19 across it. The jump is carried by the interface-normal component alone: continuity of the normal displacement forces `Ey` to scale as `eps_ZnS / eps_analyte` while `Ex` stays continuous. At the interface `|Ey|` exceeds `|Ex|` by 2.76 times, so the normal component dominates the field molecules in the analyte experience.

The lateral variation entry is a consistency check on the Floquet implementation. A laterally uniform stack must give a field independent of x, and the computed variation is at round-off level.

## On the decay fit

The field in the analyte is a single exponential by construction, because the medium is homogeneous and the Dirichlet-to-Neumann condition admits only the outgoing evanescent wave. A high fit quality therefore verifies nothing. The fitted `alpha` is instead compared against the dispersion relation `alpha = |Im sqrt(k0^2 eps_N - kx^2)|`, computed from the layer indices and the resonance angle rather than from the field data. The two agree to 8.8e-9 (base) and 1.1e-8 (10 mg/mL).

Changing the analyte from base to 10 mg/mL moves `alpha` by 0.2 percent, because it depends on the analyte index only through that square root and the index changes by 0.0019 RIU. The probe depth is effectively fixed across the working range while the resonance angle shifts by 1.01 degrees. Sensing relies on the angular shift, not on a change in probe volume.

## Data

| File | Contents |
|---|---|
| `data/03_field_analysis.csv` | field maxima, interface values, Ex and Ey, decay constants, power balance |
| `data/04_normal_profiles.csv` | abs(E) and abs(Hz) sampled along the layer normal |

## Figures

**`figures/FigS_field_2d`** — field map over the full domain with the normal profiles alongside. Shows the mode bound to the sensing surface and decaying into the analyte.

**`figures/FigS_interface_zoom`** — the same at the Ni/ZnS/analyte region, where the step in abs(E) across the sensing surface is visible.

**`figures/FigS_evanescent_decay`** — abs(Hz) into the analyte on a log axis for base and 10 mg/mL, with the exponential fits. The two curves are nearly parallel, which is the concentration-independence of the probe depth described above.

## Reproduce

```bash
PYTHONPATH=../_shared python run_02_fields.py
```

Steps 06, 08 and 09 read the field data this step writes.
