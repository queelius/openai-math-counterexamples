import Std.Tactic.BVDecide.LRAT.Checker
import Lean.Elab.Tactic.Decide
set_option maxRecDepth 100000
set_option maxHeartbeats 0
open Std.Sat Std.Tactic.BVDecide.LRAT
@[irreducible] def simpleOpaque : Nat := 1
example : simpleOpaque = 1 := by decide +kernel
attribute [local semireducible] Internal.DefaultClause.ofArray.folder
example : (Internal.DefaultClause.ofArray (#[(⟨1, by decide⟩, true)] : Array (Literal (Internal.PosFin 2)))).isSome = true := by decide +kernel
example : ((Std.HashMap.emptyWithCapacity 1 : Std.HashMap (Internal.PosFin 2) Bool).getThenInsertIfNew? ⟨1, by decide⟩ true).2.size = 1 := by decide +kernel
example : ((Std.HashMap.emptyWithCapacity 1 : Std.HashMap Nat Bool).getThenInsertIfNew? 1 true).2.size = 1 := by decide +kernel
