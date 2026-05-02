/-
  LevelingTheorem_PaperFacing.lean — v7 paper-name exposure
  ════════════════════════════════════════════════════════════════════

  Section 5 of the AFM v7 paper uses the names:
    Dev      ρ := Re(ρ) - 1/2
    ConjDev  ρ := -(Re(ρ) - 1/2)
    leveling_theorem : SpectralGap ShiftedZeroSpectrum 1/2 → ∀ ρ, Dev ρ = 0

  The original Lean file (LevelingTheorem.lean) was developed under the
  earlier v6 naming convention (NorthProbe, SouthProbe). This file
  re-states the leveling theorem and its corollary in a `Paper` namespace
  using the v7 names so that the paper text matches the code identifier
  for identifier (e.g. `Paper.leveling_theorem` reproduces what the paper
  calls `leveling_theorem`).

  Mathematically identical; only naming differs.

  Lean version:   leanprover/lean4:v4.24.0
  Mathlib commit: f897ebcf72cd16f89ab4577d0c826cd14afaafc7
-/

import Mathlib
import lean_files.LevelingTheorem

set_option linter.mathlibStandardSet false
set_option maxHeartbeats 400000
set_option maxRecDepth 4000

open scoped BigOperators Real Nat Classical

noncomputable section

namespace Paper

-- ════════════════════════════════════════════════════════════════
-- §1  Paper-facing names (Dev / ConjDev)
-- ════════════════════════════════════════════════════════════════

/-- Signed deviation of a complex point from the critical line.
    Paper §5: Dev(ρ) := Re(ρ) - 1/2. -/
def Dev (ρ : ℂ) : ℝ := ρ.re - 1/2

/-- Conjugate signed deviation. Paper §5: ConjDev(ρ) := -(Re(ρ) - 1/2). -/
def ConjDev (ρ : ℂ) : ℝ := -(ρ.re - 1/2)

/-- Antisymmetry: Dev + ConjDev = 0 identically. -/
theorem dev_plus_conjdev_zero (ρ : ℂ) : Dev ρ + ConjDev ρ = 0 := by
  simp [Dev, ConjDev]

/-- ConjDev is the negation of Dev. -/
theorem conjdev_eq_neg_dev (ρ : ℂ) : ConjDev ρ = -(Dev ρ) := by
  simp [Dev, ConjDev]

-- ════════════════════════════════════════════════════════════════
-- §2  Functional-equation balance
-- ════════════════════════════════════════════════════════════════

/-- Paper §5.2: Dev of the functional-equation partner is the negation. -/
theorem dev_func_eq_partner (ρ : ℂ) :
    Dev (1 - ρ) = -(Dev ρ) := by
  simp [Dev, Complex.sub_re, Complex.one_re]
  ring

-- ════════════════════════════════════════════════════════════════
-- §3  Leveling theorem under v7 paper names
-- ════════════════════════════════════════════════════════════════

/-- ★ LEVELING THEOREM (paper §5, Theorem 5.2) ★

    Under the spectral gap property at Δ = 1/2, every nontrivial zero
    of ζ has Dev = 0, i.e., Re(ρ) = 1/2.

    Proof: the deviation lies in ShiftedZeroSpectrum and is bounded
    in absolute value by 1/2 from the critical strip; the gap forces
    it to be either 0 or ≥ 1/2; the bound rules out the second case. -/
theorem leveling_theorem
    (h_gap : SpectralGapProperty ShiftedZeroSpectrum (1/2))
    (ρ : ℂ) (hρ : is_nontrivial_zero ρ) :
    Dev ρ = 0 := by
  -- Dev ρ ∈ ShiftedZeroSpectrum
  have h_mem : Dev ρ ∈ ShiftedZeroSpectrum := ⟨ρ, hρ, rfl⟩
  -- Apply the spectral gap property
  rcases h_gap (Dev ρ) h_mem with h0 | hge
  · exact h0
  · exfalso
    -- |Dev ρ| < 1/2 from the critical strip 0 < Re(ρ) < 1
    have h_strict : |Dev ρ| < 1/2 := by
      rw [Dev, abs_lt]
      constructor <;> linarith [hρ.2.1, hρ.2.2]
    linarith

/-- Corollary: SpectralGap on ShiftedZeroSpectrum at 1/2 implies RH. -/
theorem spectral_gap_implies_rh
    (h_gap : SpectralGapProperty ShiftedZeroSpectrum (1/2)) :
    RiemannHypothesis := by
  intro ρ hρ
  have hDev : Dev ρ = 0 := leveling_theorem h_gap ρ hρ
  -- Dev ρ = 0 ↔ Re ρ = 1/2
  unfold Dev at hDev
  linarith

#check @leveling_theorem
#check @spectral_gap_implies_rh
#check @Dev
#check @ConjDev

end Paper

end
