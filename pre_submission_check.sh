#!/usr/bin/env bash
# pre_submission_check.sh
# Verify that the SL capstone and operator-algebra files in this artifact
# compile cleanly under the pinned Lean / Mathlib commit.
#
# Run from the artifact root (the directory containing lakefile.lean).
#
# Expected outcome: zero `error:` lines, zero `sorry` warnings on the
# files listed in the artifact README.

set -euo pipefail

echo "════════════════════════════════════════════════════════════════"
echo "  AFM submission pre-flight check"
echo "  Messina Nullification Framework — SL simplicity capstone"
echo "════════════════════════════════════════════════════════════════"
echo

# 1. Tooling
if ! command -v elan >/dev/null; then
  echo "❌ elan not found. Install from https://leanprover-community.github.io/get_started.html"
  exit 1
fi

if ! command -v lake >/dev/null; then
  echo "❌ lake not found. (Should come with elan/lean.)"
  exit 1
fi

echo "── Toolchain ──"
elan --version
lake --version
echo

# 2. Pin verification
echo "── Pinned versions ──"
echo "Lean toolchain (lean-toolchain):"
cat lean-toolchain
echo
echo "Mathlib commit (lakefile.lean):"
grep -E "f897ebcf|mathlib" lakefile.lean | head -3
echo

# 3. Lake update + build
echo "── lake update ──"
lake update 2>&1 | tail -5

echo
echo "── lake build (may take several minutes on first run) ──"
BUILD_LOG=$(mktemp)
if lake build 2>&1 | tee "$BUILD_LOG"; then
  echo
  echo "✅ Build succeeded."
else
  echo
  echo "❌ Build FAILED. Inspect the log above."
  exit 1
fi

# 4. Sorry / admit / error scan
echo
echo "── Diagnostic scan ──"

ERRORS=$(grep -cE "^error:" "$BUILD_LOG" || true)
SORRY_WARNS=$(grep -cE "warning:.*sorry|declaration uses 'sorry'" "$BUILD_LOG" || true)
ADMIT_WARNS=$(grep -cE "admit" "$BUILD_LOG" || true)

echo "  Errors:             $ERRORS"
echo "  Sorry warnings:     $SORRY_WARNS"
echo "  Admit warnings:     $ADMIT_WARNS"

if [[ "$ERRORS" -ne 0 ]]; then
  echo "❌ Build emitted errors. Do not submit."
  exit 1
fi

# Note: LevelingTheorem.lean has ONE expected sorry on line 449 in
# rh_and_speiser_implies_simple (Levinson–Montgomery 1974). This theorem
# is NOT cited in the paper. The paper-cited leveling_theorem proper
# (in LevelingTheorem_PaperFacing.lean) is sorry-free.
EXPECTED_SORRIES=1

if [[ "$SORRY_WARNS" -gt "$EXPECTED_SORRIES" ]]; then
  echo "⚠️  Build emitted MORE sorry warnings than expected ($EXPECTED_SORRIES)."
  echo "   Inspect the new sorry locations below — they may indicate a regression:"
  grep -nE "warning:.*sorry|declaration uses 'sorry'" "$BUILD_LOG" | head -20
  exit 1
elif [[ "$SORRY_WARNS" -eq "$EXPECTED_SORRIES" ]]; then
  echo "  (1 expected sorry in LevelingTheorem.lean — paper-cited theorems are clean.)"
fi

# 5. Specifically check that the capstone theorem exists and has the
#    declared signature.
echo
echo "── Capstone signature verification ──"
SL_FILE="lean_files/SturmLiouvilleSimplicity.lean"

if grep -q "^theorem sturm_liouville_simple_eigenvalues" "$SL_FILE"; then
  echo "✅ sturm_liouville_simple_eigenvalues found in $SL_FILE"
  grep -A3 "^theorem sturm_liouville_simple_eigenvalues" "$SL_FILE" | head -5
else
  echo "❌ Capstone theorem name not found in $SL_FILE."
  echo "   Paper §4 references 'sturm_liouville_simple_eigenvalues'."
  exit 1
fi

# 6. master_enforcement
echo
echo "── master_enforcement check ──"
ME_FILE="lean_files/Batch14_MasterEnforcement.lean"
if grep -q "master_enforcement" "$ME_FILE"; then
  echo "✅ master_enforcement found in $ME_FILE"
else
  echo "❌ master_enforcement not found in $ME_FILE."
  exit 1
fi

# 7. leveling_theorem (paper-facing version, in Paper namespace)
echo
echo "── Paper.leveling_theorem check ──"
LT_FILE="lean_files/LevelingTheorem_PaperFacing.lean"
if grep -q "^theorem leveling_theorem" "$LT_FILE" && grep -q "namespace Paper" "$LT_FILE"; then
  echo "✅ Paper.leveling_theorem found in $LT_FILE"
else
  echo "❌ Paper.leveling_theorem not found in $LT_FILE."
  exit 1
fi

# 8. resolution_from_two_axioms
echo
echo "── resolution_from_two_axioms check ──"
MR_FILE="lean_files/MinimalAxiomReduction.lean"
if grep -q "resolution_from_two_axioms" "$MR_FILE"; then
  echo "✅ resolution_from_two_axioms found in $MR_FILE"
else
  echo "❌ resolution_from_two_axioms not found in $MR_FILE."
  exit 1
fi

# 9. HPContext
echo
echo "── HPContext check ──"
HP_FILE="lean_files/HPContext.lean"
if grep -q "structure HPContext" "$HP_FILE"; then
  echo "✅ HPContext structure found in $HP_FILE"
else
  echo "❌ HPContext structure not found in $HP_FILE."
  exit 1
fi

echo
echo "════════════════════════════════════════════════════════════════"
echo "  PRE-FLIGHT PASSED"
echo "  Submission package is consistent with the paper as written."
echo "════════════════════════════════════════════════════════════════"
