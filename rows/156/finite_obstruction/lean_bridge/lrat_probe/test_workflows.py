"""Small end-to-end artifact workflows, without modifying frozen evidence.

Alexander Richard Towell; substantial OpenAI Codex assistance. MIT.
"""
from contextlib import redirect_stdout
import io
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

import encode_data
import hints


class WorkflowTests(unittest.TestCase):
    def test_hint_cli_and_data_emitter(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "lean").mkdir()
            export = root / "export.json"
            certificate = root / "certificate.json"
            output = root / "hints.json"
            export.write_text(json.dumps({"variables":[{}, {}],
                "clauses":[[1,2],[-1,2],[1,-2],[-1,-2]]}))
            certificate.write_text(json.dumps({"proof":[[1], []]}))
            with patch("sys.argv", ["hints.py", "--export", str(export),
                       "--certificate", str(certificate), "--output", str(output)]):
                with redirect_stdout(io.StringIO()) as printed:
                    hints.main()
            receipt = json.loads(printed.getvalue())
            self.assertEqual(receipt["steps"], 2)
            steps = json.loads(output.read_text())
            self.assertTrue(hints.replay_hints(2,
                [[1,2],[-1,2],[1,-2],[-1,-2]], steps))
            with patch.object(encode_data, "__file__", str(root / "encode_data.py")):
                with redirect_stdout(io.StringIO()):
                    encode_data.main()
            packed = json.loads((root / "packing.json").read_text())
            self.assertTrue(packed["all_roundtrips_equal"])
            self.assertEqual(packed["steps"], 2)
            text = (root / "lean/CertificateData.lean").read_text()
            self.assertIn("packedProof.map unpackStep", text)
            self.assertIn("rawProof.map decodeStep", text)

    def test_early_empty_clause_reject(self):
        with self.assertRaises(hints.InvalidTrace):
            hints.trace_proof(1, [[1],[-1]], [[], []])

    def test_nonunit_and_invalid_hint_reject(self):
        with self.assertRaises(hints.InvalidTrace):
            hints.replay_hints(2, [[1,2]], [([], [1])])
        with self.assertRaises(hints.InvalidTrace):
            hints.replay_hints(1, [[1],[-1]], [([], [True])])


if __name__ == "__main__":
    unittest.main()
