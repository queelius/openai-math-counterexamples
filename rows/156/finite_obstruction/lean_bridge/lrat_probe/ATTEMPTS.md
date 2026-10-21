# Bounded attempt record

Start 09:56:05 UTC, October 21, 2026. Final deadline 10:56:05 UTC; implementation
stopped by 10:34. No new research cycle was started. Exact commands, limits and
observations are in attempts.json and logs/.

1. The public `LRAT.check` soundness theorem is available in the pinned standard
   library. Native evaluation of a tiny contradiction succeeds, but the attempted
   kernel reduction fails. Hash-map/USize operations occur on the failing path;
   this is not a proved diagnosis of the root cause or a claim about every use of
   the public checker. Raising recursion limits did not settle the issue.
2. The first proposed negative control removed one hint from contradictory unit
   clauses. It was not a meaningful rejection test, because those units already
   initialize a contradiction. It was replaced with a satisfiable input and a
   four-clause nonunit contradiction. Direct typed clauses pass those controls
   under kernel checking. No bad control is counted as a passing test.
3. The one structural pivot constructs typed clauses without the hash-map parser
   and uses the generic LRAT soundness theorem. The source-model implication,
   including decoder rejection, is proved in Lean with standard axioms. One
   separate reviewer rebuilt it and found no soundness blocker.
4. Watched propagation emitted 1,317,865 hints for all 18,302 existing proof steps;
   a separate sequential replay accepted them. Fourteen focused unit/workflow
   tests pass normally and under optimized Python. All packed roundtrips match.
5. One data build was mistakenly launched before the imported core compiled;
   the unknown-module failure is preserved as a setup error, with no mathematical
   conclusion. An 8 GiB address-space cap then blocked mapped dependency imports.
   A 4 GB Lean allocation cap also failed on both data formats and a one-numeral
   baseline. Neither failure establishes a certificate representation limit.
6. Packed constants compiled under an 8 GB Lean allocation cap. The failed
   explicit representation is preserved compressed in logs/. The improvement
   is fewer syntactic numeral nodes; no measured speed or memory improvement
   over the explicit format is claimed because the 4 GB baseline already fails.
7. Full native execution succeeds on the actual Lean-generated formula. It
   rejects the truncated trace, missing first-step hints, and the weakened input
   without nonemptiness. The strict damaged-input command exits 1.
8. Full `decide +kernel` fails reduction. Components expose failed subset and
   CNF reductions and an allocation failure for packed proof length. The precise
   root cause remains unknown. A bounded read-only source inspection found no
   sufficient opacity explanation; well-founded fuel supports closed reduction.
9. `decide_cbv` hits its default 100,000-step limit. One informed larger limit of
   100,000,000 steps, under the same 180-second timeout, produces no completed
   verdict. No successful concrete kernel theorem is reported.

The campaign stops with a completed generic interface proof and reproducible
native evidence, but an inconclusive unconditional-proof target. A future visit
must propose a concrete checked normalization/decomposition strategy instead of
replaying the same resource escalation.
