/-
  AXLE Pair 2 — leveling_theorem (content)

  Paste this into the "content" textarea on the AXLE web UI.
  Pair this with pair2_leveling_STATEMENT.lean
  in the "formal_statement" textarea.
-/

set_option autoImplicit false

open Complex

noncomputable section

/-- A nontrivial zero of ζ: in the critical strip 0 < Re(s) < 1. -/
def is_nontrivial_zero (ρ : ℂ) : Prop :=
  riemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1

/-- The set of nontrivial zeros. -/
def RiemannZeros : Set ℂ := {ρ | is_nontrivial_zero ρ}

/-- Shifted zero spectrum: {Re(ρ) - 1/2 : ρ nontrivial zero}. -/
def ShiftedZeroSpectrum : Set ℝ :=
  {x | ∃ ρ ∈ RiemannZeros, x = ρ.re - 1/2}

/-- Spectral gap property at threshold Δ on a real spectrum. -/
def SpectralGapProperty (S : Set ℝ) (Δ : ℝ) : Prop :=
  ∀ x ∈ S, x = 0 ∨ |x| ≥ Δ

/-- Signed deviation: Dev(ρ) := Re(ρ) - 1/2. -/
def Dev (ρ : ℂ) : ℝ := ρ.re - 1/2

/-- Conjugate signed deviation. -/
def ConjDev (ρ : ℂ) : ℝ := -(ρ.re - 1/2)

/-- The shifted spectrum is bounded: |x| < 1/2 from the critical strip. -/
theorem shifted_bounded : ∀ x ∈ ShiftedZeroSpectrum, |x| < 1/2 := by
  intro x hx
  obtain ⟨ρ, hρ, rfl⟩ := hx
  rw [abs_lt]
  refine ⟨?_, ?_⟩
  · linarith [hρ.2.1]
  · linarith [hρ.2.2]

/-- ★ LEVELING THEOREM (paper §5, Theorem 5.2) ★ -/
theorem leveling_theorem
    (h_gap : SpectralGapProperty ShiftedZeroSpectrum (1/2))
    (ρ : ℂ) (hρ : is_nontrivial_zero ρ) :
    Dev ρ = 0 := by
  have h_mem : Dev ρ ∈ ShiftedZeroSpectrum := ⟨ρ, hρ, rfl⟩
  rcases h_gap (Dev ρ) h_mem with h0 | hge
  · exact h0
  · exfalso
    have hb : |Dev ρ| < 1/2 := shifted_bounded (Dev ρ) h_mem
    linarith

/-- Immediate corollary: spectral gap forces Re(ρ) = 1/2. -/
theorem leveling_implies_re_half
    (h_gap : SpectralGapProperty ShiftedZeroSpectrum (1/2))
    (ρ : ℂ) (hρ : is_nontrivial_zero ρ) :
    ρ.re = 1/2 := by
  have h_dev : Dev ρ = 0 := leveling_theorem h_gap ρ hρ
  unfold Dev at h_dev
  linarith

end
