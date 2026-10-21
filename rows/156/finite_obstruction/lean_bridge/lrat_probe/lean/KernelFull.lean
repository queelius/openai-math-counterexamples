/- Concrete full-certificate kernel attempt. A build failure or timeout is
not a proof. Alexander Richard Towell; substantial OpenAI Codex assistance. Apache-2.0. -/
import CertificateData
open Family156LRAT Std.Tactic.BVDecide.LRAT.Internal
set_option maxRecDepth 1000000
set_option maxHeartbeats 0

theorem concrete_checker_success : lratChecker sourceFormula fullProof = .success := by
  decide +kernel

theorem no_five_field_ten_label_model :
    ¬ ∃ T Q : Family156Bridge.Family, Family156Bridge.FiveFields T Q ∧ ∃ S, Q S :=
  checker_success_implies_no_source_model rawProof concrete_checker_success

#print axioms concrete_checker_success
#print axioms no_five_field_ten_label_model
