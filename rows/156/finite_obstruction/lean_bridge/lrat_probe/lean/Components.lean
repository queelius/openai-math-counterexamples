import Std.Tactic.BVDecide.LRAT.Checker
import Lean.Elab.Tactic.Decide
set_option maxRecDepth 100000
set_option maxHeartbeats 0
open Std.Sat Std.Tactic.BVDecide.LRAT
example : (Std.HashMap.emptyWithCapacity 2 : Std.HashMap Nat Bool).size = 0 := by decide +kernel
example : ((Std.HashMap.emptyWithCapacity 2 : Std.HashMap Nat Bool).insert 0 true).size = 1 := by decide +kernel
example : ((Std.HashMap.emptyWithCapacity 2 : Std.HashMap Nat Bool).insert 0 true).getD 0 false = true := by decide +kernel
example : ((1 : UInt64) ^^^ 2) = 3 := by decide +kernel
#reduce hash (0 : Nat)
#reduce Internal.CNF.Clause.convertLRAT' ([(⟨1, by decide⟩, true)] : CNF.Clause (Internal.PosFin 2))
