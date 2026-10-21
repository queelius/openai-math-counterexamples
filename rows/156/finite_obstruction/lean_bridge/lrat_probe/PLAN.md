# Family 156 LRAT follow-up

Start: 2026-10-21T09:56:05Z. Feasibility deadline: 10:06:05Z.
Implementation stops: 10:36:05Z. Final deadline: 10:56:05Z.
At most one short extension only for a concrete checkable milestone; no new cycle.
Base: 5c85efc2b2409eb3a39c33da6047b8473868ed81.
Branch: research/family156-lrat-20261021, existing isolated worktree reused.

## Approved question and success

Prove the generated no-down CNF UNSAT using the pinned standard LRAT soundness
theorem, and combine it with the existing forward reduction. Exact source fields,
arbitrary T,Q and nonempty Q are preserved. No assumed UNSAT, sorry, or
Lean.ofReduceBool/native-evaluation axiom qualifies as closing the kernel gap.
A failed bounded attempt must retain actual evidence and an exact continuation.

Source bridge head d3461179d6d7161ba3ae6241f09f1b160179b70a; certificate predecessor
c714c0a27e1cb668d63c6aa7a8c373aab0f2f9d9; OpenAI source
1581d4cbdd69a0faf34b2089614fe2a814316a6a. Lean v4.33.1;
Mathlib 0df444a360eaa60ab8c11dca51a86af692955474; transitive manifest copied.
Existing frozen packets and published archive are never edited.

## Method and stopping rule

- [x] Compile a tiny kernel-evaluated LRAT success and explicit invalid controls.
- [x] Write and fail tests for a RUP-to-LRAT hint emitter; implement and test it.
- [x] Generate hints against the Lean CNF order, preserving every existing RUP step.
- [x] Attempt complete native execution as a performance probe, then kernel evaluation.
- [x] Prove the Bool/Prop CNF bridge and conditional final theorem; discharge only
  obligations actually checked. Inspect all final axioms.
- [x] Verify controls, use one focused independent reviewer, record costs/limits,
  commit clean evidence and update queue. Publish only a complete useful result
  after refreshing destination requirements; otherwise leave a local packet.

The native probe measures computation only and is not a formal proof. Abort an
individual kernel attempt after a recorded timeout; no repeated blind retries.
The one allowed pivot is a smaller kernel-checked component or a precise
performance blocker, not another mathematical problem.

Alexander Richard Towell; substantial OpenAI Codex assistance. Credit OpenAI,
Pico/Håkon Åmdal, the preceding certificate/bridge, and Lean/Mathlib/LRAT authors.

Evidence-driven pivot at 10:05 UTC: the public IntAction checker path failed
our kernel-reduction probe. Hash-map/USize conversion lies on that path, but
the exact cause was not established. A direct typed
DefaultClause/DefaultFormula probe succeeds and rejects a satisfiable control,
with only propext/Classical.choice/Quot.sound. Reuse the generic lratCheckerSound;
use a proved list-based clause parser, not the hash-map converter.

Implementation stopped at 10:34 UTC. Outcome: generic implication proved,
full native replay and controls accepted, concrete kernel equality unresolved.
Default decide_cbv reached100000steps; larger bounded run timed out180s.
No new proof oracle is accepted. Final verification/publication handoff follows.

Final reproduction: bash reproduce.sh exited0 in114.984seconds. All accepted
modules/controls and native checks pass; experimental Kernel*.lean files remain
failed/inconclusive. Public handoff uses a research branch, not a duplicate PR
or new DOI. The queue parks the underlying kernel-normalization obligation.
