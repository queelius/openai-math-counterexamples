/- Copyright (c) 2026 Alexander Richard Towell. Apache-2.0.
Substantial OpenAI Codex assistance. Boundary and failure controls, kernel checked. -/
import DirectLRAT

open Family156LRAT Family156Bridge Std.Tactic.BVDecide.LRAT
open Std.Tactic.BVDecide.LRAT.Internal
set_option maxRecDepth 100000
set_option maxHeartbeats 0

namespace Family156LRAT.Controls

def ofRaw (xs : List (List Int)) : DefaultFormula 331 :=
  DefaultFormula.ofArray (#[none] ++ (xs.map (fun c => decodeClause (rawClause c))).toArray)

def four : DefaultFormula 331 := ofRaw [[1,2],[-1,2],[1,-2],[-1,-2]]
def twoSteps : List RawStep := [([1], #[1,3]), ([], #[2,4])]

theorem valid_four : lratChecker four (twoSteps.map decodeStep) = .success := by decide +kernel
theorem missing_hint :
    lratChecker four ([([1], #[1]), ([], #[2,4])].map decodeStep) = .rupFailure := by decide +kernel
theorem satisfiable_reject :
    lratChecker (ofRaw [[1,2]]) ([([], #[1])].map decodeStep) = .rupFailure := by decide +kernel
theorem truncated_reject :
    lratChecker four ([([1], #[1,3])].map decodeStep) = .outOfProof := by decide +kernel
theorem invalid_variable :
    decodeClause [(true, 331)] = none := by decide +kernel
theorem zero_variable :
    decodeClause [(true, 0)] = none := by decide +kernel
theorem duplicate_reject :
    decodeClause [(true, 1), (true, 1)] = none := by decide +kernel
theorem tautology_reject :
    decodeClause [(true, 1), (false, 1)] = none := by decide +kernel
theorem invalid_step_skips :
    lratChecker (ofRaw [[1,2]]) ([([331], #[]),([], #[1])].map decodeStep) = .rupFailure := by decide +kernel
theorem empty_no_hints_reject :
    lratChecker (ofRaw [[1,2]]) ([([], #[])].map decodeStep) = .rupFailure := by decide +kernel

-- Nonempty Q is essential: the five retained source fields alone admit empty families.
example : FiveFields (fun _ => False) (fun _ => False) := by
  constructor <;> simp

#print axioms valid_four
#print axioms missing_hint
#print axioms satisfiable_reject
#print axioms truncated_reject
#print axioms invalid_step_skips

end Family156LRAT.Controls
