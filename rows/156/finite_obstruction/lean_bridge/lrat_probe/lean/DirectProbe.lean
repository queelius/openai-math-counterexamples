import Std.Tactic.BVDecide.LRAT.Checker
import Lean.Elab.Tactic.Decide
set_option maxRecDepth 10000
set_option maxHeartbeats 0
open Std.Sat Std.Tactic.BVDecide.LRAT Std.Tactic.BVDecide.LRAT.Internal

def lit1 : Literal (PosFin 2) := (⟨1, by decide⟩, true)
def directPositive : DefaultClause 2 := { clause := [lit1], nodupkey := by intro l; right; simp [lit1], nodup := by simp }
def directNegative : DefaultClause 2 := { clause := [(lit1.1, false)], nodupkey := by intro l; left; simp [lit1], nodup := by simp }
def directFormula : DefaultFormula 2 := DefaultFormula.ofArray #[none, some directPositive, some directNegative]
def directProof : List (Action (DefaultClause 2) (PosFin 2)) := [.addEmpty 3 #[1,2]]
theorem direct_check : lratChecker directFormula directProof = .success := by decide +kernel
theorem direct_bad : lratChecker (DefaultFormula.ofArray #[none, some directPositive]) [.addEmpty 2 #[1]] = .rupFailure := by decide +kernel
#print axioms direct_check
#print axioms direct_bad
