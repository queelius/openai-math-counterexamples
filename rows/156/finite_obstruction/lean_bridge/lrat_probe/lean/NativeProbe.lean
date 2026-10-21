/- Native execution only; this file asserts no formal theorem.
Alexander Richard Towell; substantial OpenAI Codex assistance. MIT. -/
import CertificateData
open Family156LRAT Std.Tactic.BVDecide.LRAT.Internal

def main (args : List String) : IO Unit := do
  let f := sourceFormula
  let p := fullProof
  IO.println s!"clauses={f.clauses.size - 1}; retained={(f.clauses.filterMap id).size}; steps={p.length}"
  let damaged := match rawProof with
    | [] => []
    | (c, _) :: tail => (c, #[]) :: tail
  let actualProof := if args.contains "--negative-control" then damaged.map decodeStep else p
  let complete := lratChecker f actualProof
  let truncated := lratChecker f p.dropLast
  let missingHints := lratChecker f (damaged.map decodeStep)
  let weakened := DefaultFormula.ofArray (f.clauses.set! (f.clauses.size - 1) none)
  let withoutNonempty := lratChecker weakened p
  IO.println s!"complete={complete}"
  IO.println s!"truncated={truncated}"
  IO.println s!"missing-first-hints={missingHints}"
  IO.println s!"nonempty-clause-deleted={withoutNonempty}"
  unless f.clauses.size = 30362 && (f.clauses.filterMap id).size = 30361 && p.length = 18302 do
    throw <| IO.userError "Unexpected formula or certificate dimensions"
  unless complete = .success && truncated = .outOfProof && missingHints = .rupFailure &&
      withoutNonempty = .rupFailure do
    throw <| IO.userError "Native verification or rejection control failed"
  IO.println "RESULT: native LRAT replay and controls verified; concrete kernel proof remains separate"
