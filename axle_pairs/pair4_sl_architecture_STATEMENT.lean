/-
  AXLE Pair 4 — sturm_liouville_architecture (formal_statement)

  Paste this into the "formal_statement" textarea on the AXLE web UI.
  Settings:
    environment       : lean-4.28.0
    ignore_imports    : ✓ checked  (AXLE will inject `import Mathlib`)
    use_def_eq        : ✓ checked
    mathlib_options   : leave unchecked
    permitted_sorries : (leave empty)
    timeout_seconds   : 120
-/

set_option autoImplicit false

open Filter MeasureTheory

noncomputable section

/-- A potential V is confining: continuous and V(x) → +∞ as |x| → ∞. -/
def IsConfiningPotential (V : ℝ → ℝ) : Prop :=
  Continuous V ∧ Tendsto V (Filter.cocompact ℝ) atTop

/-- u is an eigenfunction of -d²/dx² + V with eigenvalue eigval,
    nonzero, and square-integrable. -/
def IsSturmLiouvilleEigenfunction
    (V : ℝ → ℝ) (eigval : ℝ) (u : ℝ → ℝ) : Prop :=
  Differentiable ℝ u ∧
  Differentiable ℝ (deriv u) ∧
  (∀ x, -(deriv (deriv u) x) + V x * u x = eigval * u x) ∧
  u ≠ 0 ∧
  MemLp u 2 volume

/-- The Wronskian of two functions u, v at a point x. -/
def wronskian (u v : ℝ → ℝ) (x : ℝ) : ℝ :=
  u x * deriv v x - v x * deriv u x

/-- An eigenvalue is simple if every two eigenfunctions for it
    are scalar multiples of each other. -/
def IsSimpleEigenvalue (V : ℝ → ℝ) (eigval : ℝ) : Prop :=
  ∀ u v : ℝ → ℝ,
    IsSturmLiouvilleEigenfunction V eigval u →
    IsSturmLiouvilleEigenfunction V eigval v →
    ∃ c : ℝ, ∀ x, v x = c * u x

/-- ★ STURM-LIOUVILLE SIMPLICITY (paper §4, Theorem 4.1) ★

    Every eigenvalue of -d²/dx² + V with confining V admitting a
    square-integrable eigenfunction is simple. -/
theorem sturm_liouville_simple_eigenvalues
    (h_wronskian_zero :
      ∀ (V : ℝ → ℝ) (eigval : ℝ) (u v : ℝ → ℝ),
        IsConfiningPotential V →
        IsSturmLiouvilleEigenfunction V eigval u →
        IsSturmLiouvilleEigenfunction V eigval v →
        ∀ x, wronskian u v x = 0)
    (h_lindep :
      ∀ (V : ℝ → ℝ) (eigval : ℝ) (u v : ℝ → ℝ),
        Continuous V →
        IsSturmLiouvilleEigenfunction V eigval u →
        IsSturmLiouvilleEigenfunction V eigval v →
        (∀ x, wronskian u v x = 0) →
        ∃ c : ℝ, ∀ x, v x = c * u x)
    (V : ℝ → ℝ) (hV : IsConfiningPotential V) (eigval : ℝ) :
    IsSimpleEigenvalue V eigval := by sorry

end
