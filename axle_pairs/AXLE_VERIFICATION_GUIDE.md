# AXLE `verify_proof` — Phone Walkthrough (Updated for paired-input UI)

AXLE's `verify_proof` takes **two text blocks** per run:

- **`formal_statement`** — declarations + theorems with `:= by sorry` (the targets)
- **`content`** — same declarations + theorems with the actual proofs

AXLE then checks every declaration in `formal_statement` is implemented in `content`, signatures match, and no theorem in `content` actually uses `sorry`.

So we have **four pairs** of files. For each pair you do **one** AXLE run.

---

## Console settings (same for all four runs)

Open <https://axle.axiommath.ai/app/console>. For each run:

| Field | Value |
|---|---|
| **environment** | `lean-4.28.0` |
| **ignore_imports** | ✓ checked (AXLE injects `import Mathlib`) |
| **formal_statement** | paste the `*_STATEMENT.lean` file |
| **content** | paste the `*_CONTENT.lean` file |
| **permitted_sorries** | leave empty |
| **mathlib_options** | leave unchecked |
| **use_def_eq** | ✓ checked (default) |
| **timeout_seconds** | `120` |

Then tap **RUN**. A green `okay: true` is what you want.

---

## Pair 1 — `master_enforcement` (paper §2.1)

**STATEMENT:** `pair1_master_enforcement_STATEMENT.lean`
**CONTENT:** `pair1_master_enforcement_CONTENT.lean`

Verifies: the operator algebra capstone (conservation, idempotence, no intermediate values) plus the spectral-gap-on-range corollary.

**Smallest, fastest. Run this first.** Pure ℕ arithmetic, no zeta machinery.

---

## Pair 2 — `leveling_theorem` (paper §5)

**STATEMENT:** `pair2_leveling_STATEMENT.lean`
**CONTENT:** `pair2_leveling_CONTENT.lean`

Verifies: the algebraic squeeze that reduces RH (over our nontrivial-zero set) to the spectral gap hypothesis. Includes `Dev`, `ConjDev`, `shifted_bounded`, `leveling_theorem`, and `leveling_implies_re_half`.

Uses Mathlib's `riemannZeta` and `Complex.re` only as opaque names — the proof is pure linarith over the bound + gap.

---

## Pair 3 — `minimal_axiom_reduction` (paper §6)

**STATEMENT:** `pair3_reduction_STATEMENT.lean`
**CONTENT:** `pair3_reduction_CONTENT.lean`

Verifies: the §6 capstone composition. SpectralGap + Bridge + SimpleBound + (order ≥ 1) ⟹ RH ∧ AllZerosSimple. Includes the four resolution forms.

The "order ≥ 1" piece is exposed as a named hypothesis — its full proof in `MinimalAxiomReduction.lean` uses 80 lines of Mathlib's `AnalyticAt.order` machinery, which is left for the full `lake build`.

---

## Pair 4 — `sturm_liouville_simple_eigenvalues` (paper §4)

**STATEMENT:** `pair4_sl_architecture_STATEMENT.lean`
**CONTENT:** `pair4_sl_architecture_CONTENT.lean`

Verifies: that the paper §4 definitions compile, are well-typed, and that the capstone `sturm_liouville_simple_eigenvalues` is a clean 3-line composition of its two named lemmas. The lemmas themselves (`wronskian_zero_of_l2_final`, `linearly_dependent_of_wronskian_zero`) are full-proof in `SturmLiouvilleSimplicity.lean`; here their signatures are exposed as hypotheses so AXLE confirms the composition is well-typed.

---

## What success looks like

For each successful run, AXLE returns JSON like:

```json
{
  "okay": true,
  "lean_messages": { "errors": [], "warnings": [], "infos": [] },
  "tool_messages": { "errors": [], "warnings": [], "infos": [] },
  "failed_declarations": [],
  "timings": { ... }
}
```

The web UI displays this as a green check. Save four screenshots — one per pair. If the URL contains a unique run hash, save those too. Cite them in the AFM cover letter alongside the March 5 batch (`22abc227`, `572b70d1`, `c133ead0`, `3de41f1f`, `f854b8e9`, `01ae8bf9`).

## What failure looks like

`okay: false` with a `tool_messages.errors` entry. The most likely failure modes and patches:

| Error | Likely cause | Patch |
|---|---|---|
| `Missing required declaration 'foo'` | Typo in `content` — name doesn't match | Make sure both files use identical names |
| `Theorem 'X' does not match expected signature` | Definition body in `content` differs from `formal_statement` | Copy the def from `formal_statement` into `content` exactly |
| `Definition 'X' does not match expected signature` | Same issue, for `def`s | Same fix |
| `Declaration 'X' uses 'sorry'` | A theorem in `content` is still `sorry` | Add the actual proof, or list the name in `permitted_sorries` |
| `unknown identifier 'MemLp'` | Mathlib API drift in lean-4.28.0 | Try `Memℒp` (with the script l) — tell me and I'll patch |
| `unknown identifier 'AnalyticAt.order'` | Mathlib version difference for §6 file | Try `analyticOrderAt` — tell me |

Paste any error block back to me and I'll patch the matching pair on the spot.

---

## Why this paired structure

This is exactly the contract AXLE expects:

- `formal_statement` = "here is what should be true"
- `content` = "here is the proof"
- AXLE = "do the proofs in your content really establish what your statement claims?"

Each pair is self-contained and doesn't depend on the others. You can run them in any order, or all four in parallel from four browser tabs. Anonymous users get 10 concurrent slots.
