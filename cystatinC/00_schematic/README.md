# 00 — Sensor schematic

**Code:** `run_00_schematic.py`

## What this step does

Draws the sensor in the Kretschmann configuration as a vector figure. Nothing is computed here; the script reads the layer sequence and thicknesses from `_shared/fem_E.py`, so the drawing cannot drift out of step with the model.

The stack is drawn in oblique projection: a truncated prism wedge below, the four films above it, the sensing medium on top with analyte molecules on its face, and callouts for the laser source and photodetector.

## Figures

**`figures/Fig1_sensor_schematic`** — prism (Ohara S-FPL53) / Al2O3 14 nm / Cu 48 nm / Ni 3 nm / ZnS 4 nm / sensing medium. Film thicknesses are annotated on leader lines at the right.

Two deliberate departures from scale, both of which belong in the caption:

1. **Layer thicknesses are schematic.** Cu is 16 times thicker than Ni in reality but is drawn about 1.7 times thicker. Drawn to scale, Ni and ZnS would be invisible lines.
2. **The incidence angle is drawn near 62 degrees.** The computed resonance is 84.7 to 85.8 degrees, which would be almost grazing and unreadable as a drawing.

## Implementation notes

Text placement is measured rather than positioned by hand. `prism_half(y)` returns the horizontal extent of the wedge at any height, and the prism labels shrink to a common size until both bounding boxes fit inside it with a margin. The callout boxes size themselves to their label length. This means the figure survives renaming the glass, changing the font, or resizing without labels escaping their shapes.

Layer band heights are in one list near the top of the script if the visual balance needs tuning:

```python
STACK = [
    (r"Al$_2$O$_3$",   1.35, "#bcd9f2", "14 nm"),
    ("Cu",             2.00, "#d97c3f", "48 nm"),
    ("Ni",             1.15, "#9aa0a6", "3 nm"),
    ("ZnS",            1.25, "#f0d97a", "4 nm"),
    ("Sensing Medium", 1.90, "#c9c6e6", ""),
]
```

## Suggested caption

> Schematic of the proposed SPR biosensor in the Kretschmann configuration. A p-polarised beam from the laser source enters the S-FPL53 prism at incidence angle theta_i and is reflected toward the photodetector. Analyte molecules bind at the ZnS/sensing-medium interface. Layer thicknesses and the incidence angle are drawn schematically and not to scale; actual thicknesses are annotated.

## Reproduce

```bash
PYTHONPATH=../_shared python run_00_schematic.py
```
