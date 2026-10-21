import Std.Tactic.BVDecide.LRAT.Checker
import Lean.Elab.Tactic.Decide
set_option maxRecDepth 10000
set_option maxHeartbeats 0
open Std.Sat Std.Tactic.BVDecide.LRAT

def tinyCNF : CNF Nat := ⟨#[[(0, true)], [(0, false)]]⟩
def tinyProof : Array IntAction := #[.addEmpty 3 #[1, 2]]
#eval check tinyProof tinyCNF
#reduce tinyCNF.relabelFin
#reduce Internal.CNF.convertLRAT tinyCNF
#reduce check tinyProof tinyCNF
