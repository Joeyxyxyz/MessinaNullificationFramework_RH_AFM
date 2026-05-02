/-
  AXLE Pair 1 — master_enforcement (content)

  Paste this into the "content" textarea on the AXLE web UI.
  Pair this with pair1_master_enforcement_STATEMENT.lean
  in the "formal_statement" textarea.
-/

set_option autoImplicit false

/-- The nullification operator on ℕ. -/
def N (Δ x : ℕ) : ℕ := if x ≥ Δ then x else 0

/-- The remainder (reservoir) operator: companion to N. -/
def R (Δ x : ℕ) : ℕ := if x ≥ Δ then 0 else x

/-- Spectral gap property at threshold Δ. -/
def SpectralGapProperty (S : Set ℕ) (Δ : ℕ) : Prop :=
  ∀ x ∈ S, x = 0 ∨ x ≥ Δ

/-- N is idempotent (helper). -/
private theorem nullification_idempotent (Δ : ℕ) (x : ℕ) :
    N Δ (N Δ x) = N Δ x := by
  by_cases h : x ≥ Δ
  · -- Case x ≥ Δ: N Δ x = x. Both N Δ (N Δ x) and N Δ x reduce to x.
    have h1 : N Δ x = x := by
      show (if x ≥ Δ then x else 0) = x
      exact if_pos h
    rw [h1]
    -- Goal: N Δ x = x.
    exact h1
  · -- Case x < Δ: N Δ x = 0. Both sides reduce to 0.
    have h1 : N Δ x = 0 := by
      show (if x ≥ Δ then x else 0) = 0
      exact if_neg h
    rw [h1]
    -- Goal: N Δ 0 = 0.
    show (if (0 : ℕ) ≥ Δ then (0 : ℕ) else 0) = 0
    split_ifs <;> rfl

/-- ★ MASTER ENFORCEMENT (paper §2.1) ★ -/
theorem master_enforcement (Δ : ℕ) (hΔ : Δ > 0) :
    (∀ x, N Δ x + R Δ x = x) ∧
    (∀ x, N Δ (N Δ x) = N Δ x) ∧
    (∀ x, N Δ x = 0 ∨ N Δ x ≥ Δ) := by
  refine ⟨?_, ?_, ?_⟩
  · -- Conservation
    intro x
    simp only [N, R]
    split_ifs <;> omega
  · -- Idempotence
    exact nullification_idempotent Δ
  · -- No intermediate values
    intro x
    simp only [N]
    split_ifs with h
    · right; exact h
    · left; rfl

/-- Direct corollary: the range of N satisfies the spectral gap property. -/
theorem spectral_gap_on_range (Δ : ℕ) (hΔ : Δ > 0) :
    SpectralGapProperty (Set.range (N Δ)) Δ := by
  intro x hx
  obtain ⟨y, rfl⟩ := hx
  rcases (master_enforcement Δ hΔ).2.2 y with h0 | hge
  · left; exact h0
  · right; exact hge
