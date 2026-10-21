/- Alternate proof-producing evaluation, not native_decide. Unsuccessful builds establish no theorem. -/
import CertificateData
import Lean.Elab.Tactic.Cbv
open Family156LRAT Std.Tactic.BVDecide.LRAT.Internal
set_option maxRecDepth 1000000
set_option maxHeartbeats 0
set_option cbv.warning false

theorem concrete_checker_success_cbv : lratChecker sourceFormula fullProof = .success := by
  decide_cbv
#print axioms concrete_checker_success_cbv
