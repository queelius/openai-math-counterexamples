import Std.Tactic.BVDecide.LRAT.Checker
import Lean.Elab.Tactic.Decide
set_option maxRecDepth 100000
set_option maxHeartbeats 0
open Std.Sat Std.Tactic.BVDecide.LRAT
example : ((Std.HashMap.emptyWithCapacity 1 : Std.HashMap Nat Bool).insert 1 true).size = 1 := by decide +kernel
example : ((Std.HashMap.emptyWithCapacity 2 : Std.HashMap Nat Bool).getThenInsertIfNew? 0 true).2.size = 1 := by decide +kernel
example : ((Std.HashMap.emptyWithCapacity 1 : Std.HashMap Nat Bool).getThenInsertIfNew? 1 true).1 = none := by decide +kernel
set_option pp.proofs false in
#reduce ((Std.HashMap.emptyWithCapacity 1 : Std.HashMap Nat Bool).getThenInsertIfNew? 1 true).2.size
