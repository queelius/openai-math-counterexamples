"""Packed certificate data controls; Alexander Richard Towell, Codex assistance. MIT."""
import unittest
from encode_data import pack_step, unpack_step


class PackingTests(unittest.TestCase):
    def test_roundtrip(self):
        for c, h in [([], []), ([], [1, 65535]), ([1, -330], [2, 500]), ([1], [])]:
            with self.subTest(clause=c, hints=h):
                self.assertEqual(unpack_step(*pack_step(c, h)), (c, h))

    def test_invalid_digits(self):
        for c, h in [([0], [1]), ([1], [0]), ([1], [65536]), ([True], [1])]:
            with self.subTest(clause=c, hints=h), self.assertRaises(ValueError):
                pack_step(c, h)

    def test_truncated_fuel_changes_trace(self):
        fuel, value = pack_step([1, -2], [3, 4])
        self.assertNotEqual(unpack_step(fuel - 1, value), ([1, -2], [3, 4]))


if __name__ == "__main__":
    unittest.main()
