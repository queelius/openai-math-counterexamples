/- Alexander Richard Towell; substantial OpenAI Codex assistance. MIT.
This decoder handles untrusted proof hints; no semantic serialization theorem
is assumed by checker_success_implies_no_source_model. -/
import DirectLRAT
namespace Family156LRAT

def unpackDigits : Nat → Nat → List Nat
  | 0, _ => []
  | fuel + 1, value =>
    if value = 0 then [] else value % 65536 :: unpackDigits fuel (value / 65536)

def unpackStep (s : Nat × Nat) : RawStep :=
  let digits := unpackDigits s.1 s.2
  let parts := digits.span (· != 0)
  let clause := parts.1.map (fun d =>
    if d % 2 = 0 then (Int.ofNat (d / 2)) else -(Int.ofNat (d / 2)))
  (clause, parts.2.drop 1 |>.toArray)

theorem tiny_unpack : unpackStep (4, 0x0003000100000002) = ([1], #[1,3]) := by
  decide +kernel

#print axioms tiny_unpack
end Family156LRAT
