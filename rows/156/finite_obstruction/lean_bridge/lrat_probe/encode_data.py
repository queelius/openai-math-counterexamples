"""Generate small-expression-count, untrusted Lean proof data.

Alexander Richard Towell; substantial OpenAI Codex assistance. MIT.
Base 65536 digits: signed-variable codes, a zero delimiter, positive hint IDs.
Correctness is not assumed by the Lean checker soundness theorem.
"""
import hashlib
import json
from pathlib import Path

BASE = 65536


def pack_step(clause, hints):
    if any(type(x) is not int or x == 0 or 2 * abs(x) + (x < 0) >= BASE for x in clause):
        raise ValueError("invalid packed literal")
    if any(type(x) is not int or not 0 < x < BASE for x in hints):
        raise ValueError("invalid packed hint")
    digits = [2 * abs(x) + (x < 0) for x in clause] + [0] + list(hints)
    value = 0
    for d in reversed(digits):
        value = value * BASE + d
    return len(digits), value


def unpack_step(fuel, value):
    digits = []
    for _ in range(fuel):
        if not value:
            break
        value, d = divmod(value, BASE)
        digits.append(d)
    split = digits.index(0) if 0 in digits else len(digits)
    clause = [-(d // 2) if d % 2 else d // 2 for d in digits[:split]]
    return clause, digits[split + 1:]


def main():
    root = Path(__file__).resolve().parent
    steps = json.loads((root / "hints.json").read_text())
    packed = [pack_step(c, h) for c, h in steps]
    for (c, h), pair in zip(steps, packed, strict=True):
        if unpack_step(*pair) != (c, h):
            raise ValueError("packing changed a proof step")
    lines = ["/- Generated untrusted packed data. Alexander Richard Towell; Codex assistance. MIT. -/",
             "import PackedData", "namespace Family156LRAT",
             "set_option maxRecDepth 100000", "set_option maxHeartbeats 0"]
    names = []
    for start in range(0, len(packed), 128):
        name = "packedPart" + str(start // 128)
        names.append(name)
        lines.append("def " + name + " : List (Nat × Nat) := [")
        part = packed[start:start + 128]
        for j, (fuel, value) in enumerate(part):
            lines.append(f"  ({fuel}, 0x{value:x})" + ("," if j < len(part) - 1 else ""))
        lines.append("]")
    lines += ["def packedProof : List (Nat × Nat) := " + " ++ ".join(names),
              "def rawProof := packedProof.map unpackStep",
              "def fullProof := rawProof.map decodeStep", "end Family156LRAT"]
    path = root / "lean/CertificateData.lean"
    path.write_text("\n".join(lines) + "\n")
    receipt = {"steps":len(steps), "all_roundtrips_equal":True, "base":BASE,
               "max_digits":max(f for f, _ in packed), "source_bytes":path.stat().st_size,
               "source_sha256":hashlib.sha256(path.read_bytes()).hexdigest(),
               "hints_sha256":hashlib.sha256((root / "hints.json").read_bytes()).hexdigest()}
    (root / "packing.json").write_text(json.dumps(receipt, indent=2) + "\n")
    print(json.dumps(receipt))


if __name__ == "__main__":
    main()
