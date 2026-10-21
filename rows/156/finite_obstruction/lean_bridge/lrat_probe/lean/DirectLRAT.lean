/- Copyright (c) 2026 Alexander Richard Towell. Apache-2.0.
Substantial OpenAI Codex assistance. Reuses Lean's generic LRAT soundness proof.
The source bridge retains its OpenAI attribution and Apache-2.0 license. -/
import Family156Bridge
import Std.Tactic.BVDecide.LRAT.Checker

namespace Family156LRAT
open Family156Bridge Std.Sat Std.Tactic.BVDecide.LRAT
open Std.Tactic.BVDecide.LRAT.Internal

abbrev Lit := Literal (PosFin 331)

def checkedClause (ls : List Lit) : Option (DefaultClause 331) :=
  if hn : ls.Nodup then
    if ht : ls.all (fun l => decide ((l.1, !l.2) ∉ ls)) then
      some {
        clause := ls
        nodupkey := by
          intro l
          by_cases hp : (l, true) ∈ ls
          · right
            have hh := List.all_eq_true.mp ht (l, true) hp
            simpa using hh
          · exact Or.inl hp
        nodup := hn }
    else none
  else none

theorem checkedClause_list {ls : List Lit} {d : DefaultClause 331}
    (h : checkedClause ls = some d) : d.clause = ls := by
  unfold checkedClause at h
  split at h
  · split at h
    · simp only [Option.some.injEq] at h
      exact (congrArg DefaultClause.clause h).symm
    · simp at h
  · simp at h

def decodeLiteral (l : EncodedLiteral) : Option Lit :=
  if h : 0 < l.2 ∧ l.2 < 331 then some (⟨l.2, h⟩, l.1) else none

def decodeLiterals : List EncodedLiteral → Option (List Lit)
  | [] => some []
  | x :: xs => do
    let y ← decodeLiteral x
    let ys ← decodeLiterals xs
    pure (y :: ys)

def decodeClause (c : List EncodedLiteral) : Option (DefaultClause 331) := do
  let ls ← decodeLiterals c
  checkedClause ls

theorem decodeLiteral_values {l : EncodedLiteral} {y : Lit}
    (h : decodeLiteral l = some y) : y.1.val = l.2 ∧ y.2 = l.1 := by
  unfold decodeLiteral at h
  split at h
  · simp only [Option.some.injEq] at h
    subst y
    exact ⟨rfl, rfl⟩
  · simp at h

theorem decodeLiterals_mem {c : List EncodedLiteral} {ls : List Lit}
    (h : decodeLiterals c = some ls) {l : EncodedLiteral} (hl : l ∈ c) :
    ∃ y ∈ ls, y.1.val = l.2 ∧ y.2 = l.1 := by
  induction c generalizing ls with
  | nil => simp at hl
  | cons x xs ih =>
    cases hx : decodeLiteral x with
    | none => simp [decodeLiterals, hx] at h
    | some y =>
      cases hs : decodeLiterals xs with
      | none => simp [decodeLiterals, hx, hs] at h
      | some ys =>
        have he : y :: ys = ls := by simpa [decodeLiterals, hx, hs] using h
        subst ls
        rcases List.mem_cons.mp hl with rfl | hl
        · exact ⟨y, by simp, decodeLiteral_values hx⟩
        · obtain ⟨z, hz, hv⟩ := ih hs hl
          exact ⟨z, List.mem_cons_of_mem _ hz, hv⟩

theorem decodeClause_sat (a : Nat → Prop) [DecidablePred a] {c : List EncodedLiteral}
    {d : DefaultClause 331} (h : decodeClause c = some d)
    (hc : ∃ l ∈ c, EncodedSatLiteral a l) :
    Clause.eval (fun v => decide (a v.val)) d = true := by
  classical
  unfold decodeClause at h
  cases hs : decodeLiterals c with
  | none => simp [hs] at h
  | some ls =>
    have hd : checkedClause ls = some d := by simpa [hs] using h
    obtain ⟨l, hl, hsat⟩ := hc
    obtain ⟨y, hy, hv, hp⟩ := decodeLiterals_mem hs hl
    change (d.clause.any (fun l => decide (decide (a l.1.val) = l.2))) = true
    rw [checkedClause_list hd]
    apply List.any_eq_true.mpr
    refine ⟨y, hy, ?_⟩
    cases hb : l.1 <;> simp_all [EncodedSatLiteral]

def rawClause (c : List Int) : List EncodedLiteral :=
  c.map (fun x => (decide (0 < x), x.natAbs))

abbrev RawStep := List Int × Array Nat

def decodeStep (s : RawStep) : Action (DefaultClause 331) (PosFin 331) :=
  if s.1.isEmpty then .addEmpty 0 s.2
  else match decodeClause (rawClause s.1) with
    | some c => .addRup 0 c s.2
    | none => .del #[]

def sourceFormula : DefaultFormula 331 :=
  DefaultFormula.ofArray (#[none] ++ (encodedCNF.map decodeClause).toArray)

theorem decodeStep_wellFormed (s : RawStep) : WellFormedAction (decodeStep s) := by
  unfold decodeStep
  split
  · trivial
  · split <;> trivial

theorem sourceFormula_readyRup : DefaultFormula.ReadyForRupAdd sourceFormula :=
  DefaultFormula.readyForRupAdd_ofArray _

theorem sourceFormula_readyRat : DefaultFormula.ReadyForRatAdd sourceFormula :=
  DefaultFormula.readyForRatAdd_ofArray _

noncomputable def sourceAssignment (T Q : Family) : PosFin 331 → Bool :=
  fun v => @decide (encodedModel T Q v.val) (Classical.propDecidable _)

theorem source_satisfies_formula {T Q : Family} (h : FiveFields T Q)
    (hne : ∃ S, Q S) :
    Entails.eval (sourceAssignment T Q) sourceFormula := by
  classical
  rw [DefaultFormula.formulaEntails_def]
  apply List.all_eq_true.mpr
  intro d hd
  have hd' : d ∈ (encodedCNF.map decodeClause).filterMap id := by
    simpa [sourceFormula, DefaultFormula.toList, DefaultFormula.ofArray] using hd
  obtain ⟨oc, hoc, hod⟩ := List.mem_filterMap.mp hd'
  obtain ⟨c, hc, rfl⟩ := List.mem_map.mp hoc
  have hdecode : decodeClause c = some d := hod
  rw [decide_eq_true_eq]
  change Clause.eval (sourceAssignment T Q) d = true
  unfold sourceAssignment
  exact @decodeClause_sat (encodedModel T Q) (fun _ => Classical.propDecidable _) c d hdecode
    (encoded_model_satisfies_cnf h hne c hc)

theorem checker_success_implies_no_source_model (steps : List RawStep)
    (hcheck : lratChecker sourceFormula (steps.map decodeStep) = .success) :
    ¬ ∃ T Q : Family, FiveFields T Q ∧ ∃ S, Q S := by
  classical
  have hu := lratCheckerSound sourceFormula sourceFormula_readyRup sourceFormula_readyRat
    (steps.map decodeStep) (by
      intro a ha
      obtain ⟨s, hs, rfl⟩ := List.mem_map.mp ha
      exact decodeStep_wellFormed s) hcheck
  rintro ⟨T, Q, h, hne⟩
  exact hu (sourceAssignment T Q) (source_satisfies_formula h hne)

#print axioms source_satisfies_formula
#print axioms checker_success_implies_no_source_model

end Family156LRAT
