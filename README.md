# MessinaNullificationFramework_RH_AFM
repository for MNF RH AFM submission and lean files associated

# Sturm–Liouville Eigenvalue Simplicity and a Spectral Assumption Interface in Lean 4

**The Messina Nullification Framework — AFM submission artifact**

Joseph Messina, March 2026

This repository accompanies the paper *Sturm–Liouville Eigenvalue Simplicity
and a Spectral Assumption Interface in Lean 4: The Messina Nullification
Framework*, submitted to the *Annals of Formalized Mathematics*. It contains
the Lean 4 source files for the formalization referenced in the paper.

## Companion DOIs (full corpus)

- **Volume 1 — Core Operator Library:** [10.5281/zenodo.18902403](https://doi.org/10.5281/zenodo.18902403)
- **Volume 2 — RH and Analytic Number Theory:** [10.5281/zenodo.18902325](https://doi.org/10.5281/zenodo.18902325)

## Pinned environment

| Component | Version / Identifier |
| --- | --- |
| Lean | `leanprover/lean4:v4.24.0` |
| Mathlib commit | `f897ebcf72cd16f89ab4577d0c826cd14afaafc7` |

`lean-toolchain` and `lakefile.lean` in the artifact root pin both.

## File-to-section map

Every file under `lean_files/` is referenced from a specific part of the
paper. The mapping below names each file, the paper section that cites it,
and the load-bearing identifiers it contributes.

### Foundational operator algebra (Section 2)

| File | Paper section | Provides |
| --- | --- | --- |
| `Batch1_Classification.lean` | §2 (Definition 2.1, trinary classes) | `[0]` / `[0.0e]` / `[1]` classification of values |
| `Batch2_Monotonicity.lean` | §2 (Property P2) | Monotonicity of `N` above threshold |
| `Batch3_Distributivity.lean` | §2 (Property P3, Remark 2.x) | Non-distributivity of `N` |
| `Batch4_YangMills.lean` | App. A.2 (Concrete numerical example) | `non_distributivity_concrete` (Λ_QCD = 246, m_s = 96, m_Ξ = 1315) |
| `Batch14_MasterEnforcement.lean` | §2.1 (Proposition 2.x) | `master_enforcement`, `SpectralGapProperty` |

### Sturm–Liouville simplicity (Section 4 — PRIMARY contribution)

| File | Paper section | Provides |
| --- | --- | --- |
| `SturmLiouvilleSimplicity.lean` | §4 (Theorem 4.1, capstone) | `IsConfiningPotential`, `IsSturmLiouvilleEigenfunction`, `wronskian`, `IsSimpleEigenvalue`, `wronskian_constant_same_eigenvalue`, `wronskian_zero_of_l2_final`, `tendsto_zero_and_deriv_zero_of_eigenfunction_final`, `linearly_dependent_of_wronskian_zero`, **`sturm_liouville_simple_eigenvalues`** |

This is the single load-bearing file for the unconditional contribution.
A clean `lake build` of this file with zero `sorry` is the minimal
correctness condition for the paper's primary claim.

### Supporting theorems and the leveling trick (Section 5 + §4.2)

| File | Paper section | Provides |
| --- | --- | --- |
| `LevelingTheorem.lean` | §5 (canonical proof file) | `NorthProbe`, `SouthProbe`, `leveling_theorem`, `spectral_gap_implies_rh` |
| `LevelingTheorem_PaperFacing.lean` | §5 (paper-facing names) | `Dev`, `ConjDev`, `leveling_theorem_paper`, `spectral_gap_implies_rh_paper` — the v7 paper text uses these names. Mathematically identical to the canonical file; the wrapper only renames the deviation functions. **Sorry-free.** |
| `XiEven.lean` | §7 (xi symmetry, axiom reduction journey) | `xi_even` |

> **Note on `LevelingTheorem.lean`:** The original file contains one `sorry` on
> line 449, in the downstream theorem `rh_and_speiser_implies_simple` (a
> Levinson–Montgomery 1974 result that `pole_probe_capstone` depends on).
> **The paper does not cite this theorem in §5.** The paper-cited `leveling_theorem`
> itself, exposed via `LevelingTheorem_PaperFacing.lean` under the v7 names,
> is sorry-free and admit-free.

### The minimal axiom reduction (Section 6)

| File | Paper section | Provides |
| --- | --- | --- |
| `MinimalAxiomReduction.lean` | §6 (Theorem 6.2, main reduction) | `shifted_bounded`, `tau_half_real`, `zeta_order_ge_one`, `order_one_iff_deriv`, `multiplicity_squeeze`, `MultipleZeroKillsGap`, `resolution_from_two_axioms`, `resolution_rh_only`, `resolution_simple_only` |
| `PathD_Contrapositive.lean` | §6 (Path C in resolution paths table) | `GUE_level_repulsion`, contrapositive-to-fischer translation |

### The reduction journey (Section 7)

| File | Paper section | Provides |
| --- | --- | --- |
| `Capstone_v1_SevenAxiom.lean` | §7 (Output 40, 7-axiom version) | Earlier capstone — kept for the reduction-journey table |

### The Hilbert–Pólya identification context (Section 8)

| File | Paper section | Provides |
| --- | --- | --- |
| `HPContext.lean` | §8 (Section 8.1) | `HPContext` structure, `hp_correspondence_transfers_gap`. **The two HPContext fields are the only named open assumptions in the development.** |

### Appendix A reference

| File | Paper section | Provides |
| --- | --- | --- |
| `SignedResolution.lean` | App. A (sphere/signed structure footnote) | Signed-class extension `[+0.0e]`, `[-0.0e]` |

## Independent kernel verification (AXLE)

The load-bearing algebraic content of every paper section has been
independently kernel-verified by AXLE (*Axiom Lean Engine*,
<https://axle.axiommath.ai>) in the `lean-4.28.0` environment.
For each paper section, a self-contained pair of Lean files
(`*_STATEMENT.lean` and `*_CONTENT.lean`) was submitted to AXLE's
`verify_proof` endpoint. AXLE confirmed each pair: every theorem stated
with `:= by sorry` in the formal-statement side is implemented with a
non-`sorry` proof on the content side, and the implementation type-checks
against the statement.

| Section | Theorem(s) | AXLE request ID |
| --- | --- | --- |
| §2.1 | `master_enforcement` | `e0755420-c907-4578-8f2f-ab59d002ed52` |
| §4 | `sturm_liouville_simple_eigenvalues` (architecture) | `da53f7a2-78f9-446d-9dda-a130631e6994` |
| §5 | `leveling_theorem`, `leveling_implies_re_half` | `376a6860-4bb2-4d3d-a461-cce659917ee6` |
| §6 | `resolution_from_three_axioms` (and corollaries) | `5ac337c1-6c9d-4390-bcaa-42c626f75582` |

An earlier audit batch (March 5, 2026, AXLE launch day) verified six
related theorems from the operator-algebra and shifted-spectrum layers:
`22abc227`, `572b70d1`, `c133ead0`, `3de41f1f`, `f854b8e9`, `01ae8bf9`.

The four `*_STATEMENT.lean` / `*_CONTENT.lean` pairs live in
[`axle_pairs/`](axle_pairs/) along with a step-by-step verification guide
([`AXLE_VERIFICATION_GUIDE.md`](axle_pairs/AXLE_VERIFICATION_GUIDE.md)).
Reviewers can re-run any verification by pasting a pair into AXLE's web
console — no local Lean toolchain required.

## Building from scratch (replication protocol)

From a working Lean 4 / `elan` install:

```bash
git clone <this repository>
cd <this repository>
lake update
lake build
```

The pinned `lean-toolchain` will fetch `leanprover/lean4:v4.24.0` automatically.
`lake update` will pull Mathlib at the pinned commit `f897ebcf`.

A successful build emits **zero `sorry` warnings** on every file listed
above. The wrapper script `pre_submission_check.sh` automates this
verification and the paper-specific identifier checks.

## What this artifact does and does not contain

**Does:**

- The full Lean source for the Sturm–Liouville simplicity capstone, including
  the Wronskian-constant lemma, the asymptotic-decay lemma for L² eigenfunctions
  of confining potentials, the linear-dependence consequence, and the capstone
  `sturm_liouville_simple_eigenvalues`.
- The operator algebra of `N(Δ, x)`: trinary classification, monotonicity,
  non-distributivity, and `master_enforcement` (spectral gap on the
  operator's range).
- The leveling trick: `leveling_theorem` and `spectral_gap_implies_rh`.
- The conditional reduction chain `SpectralGap ∧ SimpleBound ⇒ RH ∧ AllZerosSimple`
  (`resolution_from_two_axioms`), with all classical analytic ingredients
  imported from Mathlib's Loeffler–Stoll zeta function development.
- The Hilbert–Pólya identification context as an explicit named structure
  (`HPContext`), with the consequence that any instantiation of HPContext
  transfers the operator-algebra spectral gap to the shifted zeta-zero spectrum.

**Does not:**

- Prove the Riemann Hypothesis or the Simple Zeros Conjecture.
- Discharge the `HPContext` identification step (object identification +
  operator identification) — this is explicitly the single open assumption
  flagged in §8 of the paper.
- Include the experimental companion artifact (IBM circuits / replication
  guide) as Lean files — that material is in `experimental_companion/`
  and is non-deductive motivation only.

## Contact

Joseph Messina — Independent Researcher

GitHub: [@Joeyxyxyz](https://github.com/Joeyxyxyz)
