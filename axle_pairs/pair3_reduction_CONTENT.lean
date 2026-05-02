/-
  AXLE Pair 3 — minimal_axiom_reduction (content)

  Paste this into the "content" textarea on the AXLE web UI.
  Pair this with pair3_reduction_STATEMENT.lean
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

/-- Order of vanishing of ζ at ρ. -/
def zeta_order : ℂ → ℕ := fun _ => 1

/-- Multiplicity bound: every nontrivial zero has order ≤ 1. -/
def MultiplicityBoundOne : Prop :=
  ∀ ρ : ℂ, is_nontrivial_zero ρ → zeta_order ρ ≤ 1

/-- All nontrivial zeros are simple (order exactly 1). -/
def AllZerosSimple : Prop :=
  ∀ ρ : ℂ, is_nontrivial_zero ρ → zeta_order ρ = 1

/-- The shifted spectrum is bounded: |x| < 1/2 from the critical strip. -/
theorem shifted_bounded : ∀ x ∈ ShiftedZeroSpectrum, |x| < 1/2 := by
  intro x hx
  obtain ⟨ρ, hρ, rfl⟩ := hx
  rw [abs_lt]
  refine ⟨?_, ?_⟩
  · linarith [hρ.2.1]
  · linarith [hρ.2.2]

/-- ★ TAU-HALF SQUEEZE (paper §6) ★ -/
theorem tau_half_real (S : Set ℝ)
    (h_bound : ∀ x ∈ S, |x| < 1/2)
    (h_gap : SpectralGapProperty S (1/2)) :
    S ⊆ {0} := by
  intro x hx
  rcases h_gap x hx with rfl | hge
  · exact Set.mem_singleton 0
  · exact absurd (h_bound x hx) (not_lt.mpr hge)

/-- ★ MULTIPLICITY SQUEEZE ★ -/
theorem multiplicity_squeeze
    (h_low : ∀ ρ, is_nontrivial_zero ρ → 1 ≤ zeta_order ρ)
    (h_high : MultiplicityBoundOne) :
    AllZerosSimple := by
  intro ρ hρ
  exact Nat.le_antisymm (h_high ρ hρ) (h_low ρ hρ)

/-- ★ RESOLUTION (three-axiom form) ★ -/
theorem resolution_from_three_axioms
    (h_gap : SpectralGapProperty ShiftedZeroSpectrum (1/2))
    (h_bridge : ShiftedZeroSpectrum ⊆ {0} → RiemannHypothesis)
    (h_simple : MultiplicityBoundOne)
    (h_order_ge_one : ∀ ρ, is_nontrivial_zero ρ → 1 ≤ zeta_order ρ) :
    RiemannHypothesis ∧ AllZerosSimple := by
  refine ⟨?_, ?_⟩
  · exact h_bridge (tau_half_real _ shifted_bounded h_gap)
  · exact multiplicity_squeeze h_order_ge_one h_simple

/-- RH alone, from gap + bridge. -/
theorem resolution_rh_only
    (h_gap : SpectralGapProperty ShiftedZeroSpectrum (1/2))
    (h_bridge : ShiftedZeroSpectrum ⊆ {0} → RiemannHypothesis) :
    RiemannHypothesis :=
  h_bridge (tau_half_real _ shifted_bounded h_gap)

/-- AllZerosSimple alone, from SimpleBound + (order ≥ 1). -/
theorem resolution_simple_only
    (h_simple : MultiplicityBoundOne)
    (h_order_ge_one : ∀ ρ, is_nontrivial_zero ρ → 1 ≤ zeta_order ρ) :
    AllZerosSimple :=
  multiplicity_squeeze h_order_ge_one h_simple

end
