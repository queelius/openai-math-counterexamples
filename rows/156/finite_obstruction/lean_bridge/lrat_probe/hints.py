"""Untrusted RUP-to-LRAT hint generation, with a separate sequential replay.

Alexander Richard Towell; substantial OpenAI Codex assistance. MIT.
The watched-literal algorithm adapts the preceding MIT-licensed rup.py.
Lean must check every generated hint; this program is not a proof oracle.
"""
import argparse
from collections import defaultdict
import hashlib
import json
from pathlib import Path
import time


class InvalidTrace(ValueError):
    pass


def validate_clause(variables, clause):
    if not isinstance(clause, (list, tuple)):
        raise InvalidTrace("clause must be an integer sequence")
    if any(type(x) is not int or not 1 <= abs(x) <= variables for x in clause):
        raise InvalidTrace("invalid literal")
    if len(set(clause)) != len(clause) or any(-x in clause for x in clause):
        raise InvalidTrace("duplicate or complementary literals")


class HintDatabase:
    def __init__(self, variables, clauses):
        self.variables = variables
        self.clauses = []
        self.watches = defaultdict(list)
        self.units = []
        self.empty = []
        for c in clauses:
            self.add(c)

    def add(self, clause):
        validate_clause(self.variables, clause)
        index = len(self.clauses)
        self.clauses.append(list(clause))
        if not clause:
            self.empty.append(index + 1)
        elif len(clause) == 1:
            self.units.append((index + 1, clause[0]))
        else:
            self.watches[clause[0]].append(index)
            self.watches[clause[1]].append(index)

    def trace(self, clause):
        if self.empty:
            return self.empty[:1]
        values = [0] * (self.variables + 1)
        queue, hints = [], []

        def value(lit):
            return values[abs(lit)] * (1 if lit > 0 else -1)

        def enqueue(lit, reason=None):
            status = value(lit)
            if status > 0:
                return True
            if reason is not None:
                hints.append(reason)
            if status < 0:
                return False
            values[abs(lit)] = 1 if lit > 0 else -1
            queue.append(lit)
            return True

        for lit in clause:
            if not enqueue(-lit):
                raise InvalidTrace("tautological target")
        for reason, lit in self.units:
            if not enqueue(lit, reason):
                return hints
        position = 0
        while position < len(queue):
            false_lit = -queue[position]
            position += 1
            watching = self.watches[false_lit]
            i = 0
            while i < len(watching):
                index = watching[i]
                c = self.clauses[index]
                if c[0] == false_lit:
                    c[0], c[1] = c[1], c[0]
                if c[1] != false_lit:
                    raise InvalidTrace("watch invariant")
                other = c[0]
                if value(other) > 0:
                    i += 1
                    continue
                replacement = next((j for j in range(2, len(c)) if value(c[j]) >= 0), None)
                if replacement is not None:
                    c[1], c[replacement] = c[replacement], c[1]
                    watching[i] = watching[-1]
                    watching.pop()
                    self.watches[c[1]].append(index)
                    continue
                if not enqueue(other, index + 1):
                    return hints
                i += 1
        raise InvalidTrace("target is not RUP implied")


def trace_proof(variables, cnf, proof):
    if not isinstance(proof, list) or not proof or proof[-1] != []:
        raise InvalidTrace("proof must end in the empty clause")
    db = HintDatabase(variables, cnf)
    result = []
    for i, clause in enumerate(proof):
        validate_clause(variables, clause)
        if not clause and i != len(proof) - 1:
            raise InvalidTrace("early empty clause")
        hints = db.trace(clause)
        result.append((list(clause), hints))
        db.add(clause)
    return result


def replay_hints(variables, cnf, steps):
    """Simple hint-only replay, independent of watched propagation bookkeeping."""
    db = [list(c) for c in cnf]
    for c in db:
        validate_clause(variables, c)
    if not steps or steps[-1][0] != []:
        raise InvalidTrace("no final empty clause")
    for clause, hints in steps:
        validate_clause(variables, clause)
        assignment = {abs(x): x < 0 for x in clause}
        conflict = False
        for hint in hints:
            if type(hint) is not int or not 1 <= hint <= len(db):
                raise InvalidTrace("invalid hint index")
            reason = db[hint - 1]
            if any(assignment.get(abs(x)) == (x > 0) for x in reason):
                continue
            free = [x for x in reason if abs(x) not in assignment]
            if not free:
                conflict = True
                break
            if len(free) != 1:
                raise InvalidTrace("nonunit hint")
            x = free[0]
            assignment[abs(x)] = x > 0
        if not conflict:
            raise InvalidTrace("hints do not derive contradiction")
        db.append(list(clause))
    return True


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--export", type=Path, required=True)
    parser.add_argument("--certificate", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    start = time.monotonic()
    export = json.loads(args.export.read_text())
    cert = json.loads(args.certificate.read_text())
    steps = trace_proof(len(export["variables"]), export["clauses"], cert["proof"])
    replay_hints(len(export["variables"]), export["clauses"], steps)
    args.output.write_text(json.dumps(steps, separators=(",", ":")) + "\n")
    print(json.dumps({"steps":len(steps), "hints":sum(len(h) for _, h in steps),
        "elapsed_seconds":round(time.monotonic()-start,3),
        "export_sha256":hashlib.sha256(args.export.read_bytes()).hexdigest(),
        "certificate_sha256":hashlib.sha256(args.certificate.read_bytes()).hexdigest(),
        "output_sha256":hashlib.sha256(args.output.read_bytes()).hexdigest()}))


if __name__ == "__main__":
    main()
