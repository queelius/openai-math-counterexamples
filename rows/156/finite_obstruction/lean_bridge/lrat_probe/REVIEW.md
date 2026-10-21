# Scoped separate AI review

Reviewer: separately tasked OpenAI Codex agent, 2026-10-21. This is AI source
review, not human peer review or an independent certificate implementation.
Scope: DirectLRAT.lean and inherited forward bridge; no full trace evaluation.

No mathematical soundness defect found. The successful-check implication
excludes arbitrary T,Q on all subsets of Fin10, with exactly FiveFields and
nonempty Q. It adds no down, fixed facet, symmetry reduction, or source premise.
The copied source bridge matches the predecessor byte for byte.

Decoder rejection weakens sourceFormula. source_satisfies_formula proves that
all surviving decoded clauses are satisfied by the source model, so lossless
parsing is unnecessary for the contradiction direction. decodeLiteral_values,
decodeLiterals_mem and decodeClause_sat preserve variable and polarity;
PosFin331 is exactly variables1 through330. The classical Bool model does not
restrict admissible Prop-valued source families.

Readiness follows from standard ofArray results. Every emitted action is
well formed; no RAT action is emitted. Addition IDs are ignored by this generic
checker and insertion appends; the informational ID0 does not affect soundness.
Invalid nonempty steps become empty deletions and cannot create a contradiction.

The checked formula comes directly from Lean encodedCNF. The external export,
hint generator and data emitter are untrusted inputs; errors can prevent the
checker succeeding but are not assumed by the formal implication.

The concrete equality lratChecker sourceFormula (steps.map decodeStep)=success
was not established by the reviewer and remains the decisive obligation.
Native execution is only a performance probe; final unconditional theorem and
axioms would require fresh inspection after this equality is discharged.

Independent builds completed: DirectLRAT.lean and Family156Bridge.lean, both
exit0. The two printed theorem axioms are exactly propext, Classical.choice,
Quot.sound. Eight hint tests passed under normal and optimized Python.
No files were edited; no full-certificate or large-data build was run.

## Same-reviewer packing follow-up

PackedData.lean and encode_data.py agree on least-significant base65536 digits,
a zero delimiter, parity-coded signed literals, and fuel bounds, including
empty clauses and omitted trailing zero delimiters. The generic theorem accepts
any List RawStep; packing fidelity is therefore not a theorem assumption.
Successful checking of whatever the decoder actually produces still gives the
source-model exclusion. Full data compilation and Python roundtrips do not prove
concrete checker success. The reviewer independently compiled PackedData.lean
(exit0; tiny_unpack axioms propext/Quot.sound) and ran three packing tests under
normal and optimized Python. The 4GB baseline failure prevents attributing the
earlier memory failures solely to the explicit representation. No files edited.

## Final bounded diagnosis

The same reviewer inspected the generator's reduction chain. The exact cause
of the subset-count kernel non-reduction remains unknown. List.mergeSort is
irreducible and delegates to a well-founded implementation, but the pinned
WellFounded.Nat.fix uses explicit fuel for closed reduction. That annotation
and generic opaque-accessibility concerns are insufficient to establish the
cause here. Finset.sort delegates through Multiset.sort and Quot.liftOn;
sublistsLen is recursive. No general non-normalizability result is claimed.
