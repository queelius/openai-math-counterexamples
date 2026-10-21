"""Tests of the untrusted LRAT hint generator; not a soundness proof.

Alexander Richard Towell; substantial OpenAI Codex assistance. MIT.
"""
import unittest

from hints import InvalidTrace, trace_proof, replay_hints


class HintTests(unittest.TestCase):
    def test_two_unit_contradiction(self):
        steps = trace_proof(1, [[1], [-1]], [[]])
        self.assertTrue(replay_hints(1, [[1], [-1]], steps))
        self.assertEqual(steps[0][0], [])

    def test_nonunit_refutation(self):
        cnf = [[1, 2], [-1, 2], [1, -2], [-1, -2]]
        steps = trace_proof(2, cnf, [[1], []])
        self.assertTrue(replay_hints(2, cnf, steps))
        self.assertGreaterEqual(len(steps[0][1]), 2)

    def test_damaged_hint(self):
        steps = trace_proof(1, [[1], [-1]], [[]])
        damaged = [(steps[0][0], steps[0][1][:-1])]
        with self.assertRaises(InvalidTrace):
            replay_hints(1, [[1], [-1]], damaged)

    def test_out_of_range_hint(self):
        with self.assertRaises(InvalidTrace):
            replay_hints(1, [[1], [-1]], [([], [3])])

    def test_satisfiable_formula(self):
        with self.assertRaises(InvalidTrace):
            trace_proof(2, [[1, 2]], [[]])

    def test_not_a_refutation(self):
        with self.assertRaises(InvalidTrace):
            trace_proof(2, [[1, 2]], [[1, 2]])

    def test_invalid_literals(self):
        for clause in [[0], [3], [True], [1, 1], [1, -1]]:
            with self.subTest(clause=clause), self.assertRaises(InvalidTrace):
                trace_proof(2, [clause], [[]])

    def test_repeated_calls_and_initial_empty(self):
        for _ in range(2):
            steps = trace_proof(1, [[]], [[]])
            self.assertTrue(replay_hints(1, [[]], steps))


if __name__ == "__main__":
    unittest.main()
