#!/usr/bin/env bash
# Build the cystatinC/ tree from the SPR_FEM_deliverables bundle and push it.
#
# Usage:
#   1. unzip SPR_FEM_deliverables.zip
#   2. git clone https://github.com/Masiath/spr-fem-analysis.git
#   3. cp populate_repo.sh <somewhere>   (or use the copy already in the repo)
#   4. ./populate_repo.sh /path/to/SPR_FEM_deliverables /path/to/spr-fem-analysis
#
# The script only copies files and commits. It never deletes anything.

set -euo pipefail

BUNDLE="${1:?usage: populate_repo.sh <bundle-dir> <repo-dir>}"
REPO="${2:?usage: populate_repo.sh <bundle-dir> <repo-dir>}"
C="$REPO/cystatinC"

for d in code data figures manuscript; do
  [ -d "$BUNDLE/$d" ] || { echo "missing $BUNDLE/$d"; exit 1; }
done

mkdir -p "$C/_shared" "$REPO/manuscript"

# shared solver modules, used by every step
cp "$BUNDLE/code/fem_E.py"      "$C/_shared/"
cp "$BUNDLE/code/fem_H.py"      "$C/_shared/"
cp "$BUNDLE/code/tmm_ref.py"    "$C/_shared/"
cp "$BUNDLE/code/figkit.py"     "$C/_shared/"
cp "$BUNDLE/code/paths.py"      "$C/_shared/"
cp "$BUNDLE/code/_p3_common.py" "$C/_shared/"
cp "$BUNDLE/code/requirements.txt" "$REPO/"

# step folder: name | script | data files | figure files
step () {
  local dir="$1" script="$2" data="$3" figs="$4"
  mkdir -p "$C/$dir/data" "$C/$dir/figures"
  [ -n "$script" ] && cp "$BUNDLE/code/$script" "$C/$dir/"
  for f in $data; do [ -f "$BUNDLE/data/$f" ] && cp "$BUNDLE/data/$f" "$C/$dir/data/"; done
  for f in $figs; do
    for ext in png pdf; do
      [ -f "$BUNDLE/figures/$f.$ext" ] && cp "$BUNDLE/figures/$f.$ext" "$C/$dir/figures/"
    done
  done
  rmdir "$C/$dir/data" 2>/dev/null || true
  rmdir "$C/$dir/figures" 2>/dev/null || true
}

step 00_schematic  run_00_schematic.py          ""  "Fig1_sensor_schematic"
step 01_reflectance run_01_reflectance.py       "01_performance_metrics.csv 02_reflectance_curves.csv" "FigS_reflectance"
step 02_fields     run_02_fields.py             "03_field_analysis.csv 04_normal_profiles.csv" "FigS_field_2d FigS_interface_zoom FigS_evanescent_decay"
step 03_convergence run_03_convergence.py       "05_convergence_mesh.csv 06_convergence_cu_order1.csv 07_convergence_cu_order3.csv 08_convergence_order.csv 09_buffer_prism.csv 10_buffer_analyte.csv" "FigS_mesh_convergence FigS_order_buffer"
step 03b_cross_verification run_03b_cross_verification.py "11_cross_verification.csv" "FigS_cross_verification"
step 04_validation run_04_validation.py         "12_fem_vs_tmm.csv" "Fig_FEM_vs_TMM"
step 05_table      run_05_table.py              "12_fem_vs_tmm.csv" ""
step 06_main_figure run_06_main_figure.py       ""  "Fig_MAIN_field_analysis"
step 07_mesh_figure run_07_mesh_figure.py       ""  "FigS_mesh"
step 08_3d_surface run_08_3d_surface.py         ""  "FigS_3D_field_surface"
step 09_field_bands run_09_field_bands.py       ""  "Fig_field_profile_bands"

# manuscript
cp "$BUNDLE/manuscript/"* "$REPO/manuscript/" 2>/dev/null || true

# tables belong with step 05 as well
cp "$BUNDLE/manuscript/Table_FEM_vs_TMM.tex" "$C/05_table/" 2>/dev/null || true
cp "$BUNDLE/manuscript/Table_FEM_vs_TMM.md"  "$C/05_table/" 2>/dev/null || true

cat > "$REPO/.gitignore" <<'EOF'
__pycache__/
*.pyc
.venv/
results/
convergence_state.json
figmain_cache.npz
fig3d_cache.npz
EOF

cd "$REPO"
git add -A
git commit -m "Add cystatinC analysis tree: code, data tables and figures per step"
git push

echo
echo "done. pushed to $(git remote get-url origin)"
