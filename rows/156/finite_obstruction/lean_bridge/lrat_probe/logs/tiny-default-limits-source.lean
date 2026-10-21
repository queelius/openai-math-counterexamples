import Std.Tactic.BVDecide.LRAT.Checker
import Lean.Elab.Tactic.Decide
open Std.Sat Std.Tactic.BVDecide.LRAT

def tinyCNF : CNF Nat := ⟨#[[(0, true)], [(0, false)]]⟩
def tinyProof : Array IntAction := #[.addEmpty 3 #[1, 2]]
example : check tinyProof tinyCNF = true := by decide +kernel
example : tinyCNF.Unsat := check_sound tinyProof tinyCNF (by decide +kernel)
example : check (#[] : Array IntAction) tinyCNF = false := by decide +kernel
example : check #[.addEmpty 3 #[1]] tinyCNF = false := by decide +kernel
#print axioms check_sound
