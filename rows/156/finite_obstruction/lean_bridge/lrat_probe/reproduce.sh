#!/usr/bin/env bash
# Alexander Richard Towell; substantial OpenAI Codex assistance. MIT.
# Requires the pinned Lean toolchain and cached dependencies; writes local build outputs.
set -euo pipefail
task_packet_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
cd "$task_packet_dir"
python3 -m unittest -v test_hints test_packing test_workflows
python3 -O -m unittest -v test_hints test_packing test_workflows
cd lean
export LEAN_PATH=".:${LEAN_PATH:-}"
lake env lean -o Family156Bridge.olean Family156Bridge.lean
lake env lean -o DirectLRAT.olean DirectLRAT.lean
lake env lean Consumers.lean
lake env lean -o PackedData.olean PackedData.lean
lake env lean -M 8192 -j 2 -o CertificateData.olean CertificateData.lean
lake env lean -M 8192 -j 2 --run NativeProbe.lean
set +e
lake env lean -M 8192 -j 2 --run NativeProbe.lean --negative-control
task_negative_status=$?
set -e
if [[ "$task_negative_status" -ne 1 ]]; then
    echo "RESULT: FAIL: damaged native replay must exit 1" >&2
    exit 1
fi
echo "RESULT: partial formalization and native verification reproduced; no unconditional kernel theorem"
