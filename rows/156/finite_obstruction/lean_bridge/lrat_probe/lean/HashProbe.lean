import Std.Tactic.BVDecide.LRAT.Checker
import Lean.Elab.Tactic.Decide
set_option maxRecDepth 100000
set_option maxHeartbeats 0
open Std.Sat Std.Tactic.BVDecide.LRAT
example : ((Std.HashMap.emptyWithCapacity 2 : Std.HashMap Nat Bool).insert 0 true).toList = [(0,true)] := by decide +kernel
example : (Internal.DefaultClause.ofArray (#[(⟨1, by decide⟩, true)] : Array (Literal (Internal.PosFin 2)))).isSome = true := by decide +kernel
example : ((Internal.DefaultClause.ofArray (#[(⟨1, by decide⟩, true)] : Array (Literal (Internal.PosFin 2)))).map (fun c => c.clause.length)) = some 1 := by decide +kernel
#print Internal.DefaultClause.ofArray
#print Internal.DefaultClause.ofArray.folder
