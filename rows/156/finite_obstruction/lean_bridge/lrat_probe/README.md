# Family 156: generic LRAT bridge and native replay

**Outcome, 2026-10-21:** Lean verifies that successful LRAT checking of a formula
constructed directly from the existing Lean CNF excludes the five-field source
model. Native execution checks the full 18,302-step trace against that formula
and rejects damaged inputs. The concrete checker equality was **not proved in
the kernel** during this bounded visit. The unconditional formalization target
therefore remains unresolved.

This extends the forward reduction in
[PR12](https://github.com/piiiico/openai-math-counterexamples/pull/12), not its
mathematical claim: exactly ten labels, arbitrary subset families T,Q,
`tetra_card`, `pure`, `no_boundary`, `complementary`, `pair_count`, and nonempty Q.
Only `down` is omitted. Pico's earlier omission observation retains its credit.

## What is established

`lean/DirectLRAT.lean` proves:

```lean
checker_success_implies_no_source_model (steps : List RawStep)
    (hcheck : lratChecker sourceFormula (steps.map decodeStep) = .success) :
    ¬ ∃ T Q : Family, FiveFields T Q ∧ ∃ S, Q S
```

The input formula is constructed from `Family156Bridge.encodedCNF` inside Lean.
The theorem does not assume a Python export is faithful. It uses the standard
generic `lratCheckerSound`, with readiness and action well-formedness proved.
The Bool/Prop assignment, variable numbers, and polarities are formally related.
Rejected input clauses weaken the formula, so successful refutation still
excludes every source model. Native execution confirms all **30,361 clauses**
are retained in this particular instance.

The interface theorem's only axioms are `propext`, `Classical.choice`, and
`Quot.sound`. Ten kernel-checked consumer controls cover valid checking,
missing hints, a satisfiable formula, truncation, invalid/zero variables,
duplicates, tautologies, invalid steps, and empty hints. Empty Q is explicitly
shown to satisfy the five fields, preserving the need for nonemptiness.

The full native replay reports success, and independently reports rejection for
truncation, deleted first-step hints, and deletion of the nonempty clause.
The strict entry point exits 1 when the damaged trace is selected. This is
execution of a checker with a formal soundness theorem; the executed result is
still external computational evidence, not a proof of its concrete equality.

## Reproduce

`bash reproduce.sh` runs the accepted builds, both Python test modes, the native
replay and its strict rejection control. Expected exit 0 and a final
`RESULT: partial formalization and native verification reproduced; no unconditional kernel theorem`.
It deliberately excludes the failed diagnostic and `Kernel*.lean` experiments.

Use the pinned Lean `v4.33.1` and Mathlib
`0df444a360eaa60ab8c11dca51a86af692955474`; all transitive pins are in
`lean/lake-manifest.json`. Obtain the pinned Mathlib cache with
`cd lean && lake exe cache get`; do not update dependencies. From `lean/`:

```sh
LEAN_PATH=. lake env lean -o Family156Bridge.olean Family156Bridge.lean
LEAN_PATH=. lake env lean -o DirectLRAT.olean DirectLRAT.lean
LEAN_PATH=. lake env lean Consumers.lean
LEAN_PATH=. lake env lean -o PackedData.olean PackedData.lean
LEAN_PATH=. lake env lean -M 8192 -j 2 -o CertificateData.olean CertificateData.lean
LEAN_PATH=. lake env lean -M 8192 -j 2 --run NativeProbe.lean
```

Expected: builds and consumers exit 0 with the documented standard axiom lists;
the final command prints
`RESULT: native LRAT replay and controls verified; concrete kernel proof remains separate`.
Append `--negative-control` to that final command for expected exit **1**.
The full native input has 330 variables, 30,361 retained clauses, and 18,302 steps.
The measured packed-data build took 39.806 seconds, with peak RSS about 7.33 GiB;
native runs took 25–47 seconds in this shared environment. These are observed
configurations, not a performance comparison or universal resource requirement.

From this packet directory:

```sh
python3 -m unittest -v test_hints test_packing test_workflows
python3 -O -m unittest -v test_hints test_packing test_workflows
```

Expected: **14 tests pass** in each mode. Combined statement/branch coverage is 90%
with coverage 7.10.7; unexercised branches are recorded in
`logs/python-coverage.json`. The actual full trace also passed a distinct simple
hint replay. All 18,302 packing roundtrips are checked by `python3 encode_data.py`;
that command regenerates `lean/CertificateData.lean` from `hints.json`.
Packing and hint emission are untrusted by the formal implication.

## Bounded failures and continuation

The ordinary full `decide +kernel` attempt failed to reduce after 13.090 seconds.
Component probes also failed on subset enumeration and the generated CNF; the
packed proof-length kernel check exceeded the allocation limit. The exact cause
of the generator non-reduction remains **unknown**, including after scoped review.
The default 100,000-step `decide_cbv` limit was exhausted. One larger
100,000,000-step attempt was stopped after 180 seconds without a verdict.
These observations do not establish impossibility or a general lower bound.

`lean/Kernel*.lean`, `SmallProbe.lean`, and the diagnostic files preserve failed
experiments. They are **not passing modules**, and declarations printed with
`sorryAx` after a failed tactic are **not accepted proofs**. See
[attempts.json](attempts.json), [attempt log](ATTEMPTS.md), and
[scoped AI review](REVIEW.md). Earlier memory failures are not attributable solely
to certificate size: the 4 GB allocation cap also rejected a one-numeral import
baseline. The old tiny one-hint control was corrected because preloaded
contradictory units already suffice; the accepted controls use satisfiable and
nonunit examples.

The precise remaining obligation is a standard-axiom proof of
`lratChecker sourceFormula fullProof = .success`. Reopen only with a concrete
normalization strategy, proved preprocessing, or checked decomposition that
addresses the measured failures. Raising limits alone is not a continuation.
This visit ends here; rotate to another problem before returning.

## Provenance, publication, and credit

[Source pins](source-pins.json) retain workspace base, OpenAI source, public bridge
head, certificate predecessor, hashes, toolchain and Mathlib revisions. The copied
bridge and original `source/Labels.lean` retain their predecessor bytes. The
published [version 1.1.0](https://doi.org/10.5281/zenodo.23530387) remains unchanged.
This follow-up is suitable as a partial formalization/native verification record;
the intended unconditional proof is not ready. No new DOI is minted for this
inconclusive visit, and no duplicate external PR is opened while PR12 awaits review.

Alexander Richard Towell (ORCID 0000-0001-6443-9897), with substantial OpenAI Codex
assistance in proof, code, checking, writing and one separately tasked AI review.
Credit OpenAI's source definition/finite lemmas; Pico/Håkon Åmdal's prior observation
and reproductions; the preceding certificate/bridge; Lean/Mathlib; and the LRAT
implementation and soundness authors Josh Clune, Henrik Böving and contributors.
AI review is not human peer review. The new Lean interface and adapted source
are Apache-2.0; original Python, packed data and decoder are MIT. Full notices are
retained in `LICENSE`, `LICENSE-MIT`, and `source/LICENSE`.
