import Lake
open Lake DSL

package «messina-nullification-framework-afm» where
  -- Lean version: leanprover/lean4:v4.24.0
  leanOptions := #[
    ⟨`pp.unicode.fun, true⟩,
    ⟨`autoImplicit, false⟩
  ]

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @
  "f897ebcf72cd16f89ab4577d0c826cd14afaafc7"

@[default_target]
lean_lib MessinaNullificationFrameworkAFM where
  roots := #[
    -- §2  Operator algebra (foundational)
    `lean_files.Batch1_Classification,
    `lean_files.Batch2_Monotonicity,
    `lean_files.Batch3_Distributivity,
    `lean_files.Batch4_YangMills,
    -- §2.1  Spectral gap enforcement (master_enforcement)
    `lean_files.Batch14_MasterEnforcement,
    -- §4  Sturm–Liouville simplicity capstone (PRIMARY contribution)
    `lean_files.SturmLiouvilleSimplicity,
    -- §5  Leveling theorem (canonical file with NorthProbe/SouthProbe)
    `lean_files.LevelingTheorem,
    -- §5  Paper-facing wrapper exposing Dev/ConjDev names (v7)
    `lean_files.LevelingTheorem_PaperFacing,
    -- §6  Minimal axiom reduction (2-axiom resolution)
    `lean_files.MinimalAxiomReduction,
    -- §6  Path D contrapositive
    `lean_files.PathD_Contrapositive,
    -- §7  xi_even (axiom reduction journey)
    `lean_files.XiEven,
    -- §7  Earlier 7-axiom capstone (kept for reduction journey)
    `lean_files.Capstone_v1_SevenAxiom,
    -- §8  Hilbert–Pólya identification context (open assumption)
    `lean_files.HPContext,
    -- App. A reference: signed resolution
    `lean_files.SignedResolution
  ]
