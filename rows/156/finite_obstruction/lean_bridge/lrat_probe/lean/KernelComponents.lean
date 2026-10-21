import CertificateData
open Family156LRAT Family156Bridge Std.Tactic.BVDecide.LRAT.Internal
set_option maxRecDepth 1000000
set_option maxHeartbeats 0
example : (subsets 3).length = 120 := by decide +kernel
example : variableTable.length = 330 := by decide +kernel
example : rawProof.length = 18302 := by decide +kernel
example : encodedCNF.length = 30361 := by decide +kernel
example : encodedCNF.head!.head! = (false, 1) := by decide +kernel
#print axioms Family156Bridge.encodedCNF
