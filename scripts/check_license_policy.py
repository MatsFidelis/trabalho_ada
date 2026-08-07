#!/usr/bin/env python3
"""Valida as licenças de componentes de um SBOM CycloneDX."""
import argparse
import json
import sys
from pathlib import Path

ALLOWED = {"MIT", "Apache-2.0", "BSD-2-Clause", "BSD-3-Clause", "ISC", "CC0-1.0", "Unlicense"}

parser = argparse.ArgumentParser()
parser.add_argument("--sbom", required=True)
parser.add_argument("--output", required=True)
args = parser.parse_args()
sbom = json.loads(Path(args.sbom).read_text(encoding="utf-8"))
violations = []
for component in sbom.get("components", []):
    for item in component.get("licenses", []):
        license_id = item.get("license", {}).get("id")
        if license_id not in ALLOWED:
            violations.append({"component": component.get("name", "desconhecido"), "license": license_id or "nao-informada"})
report = {"status": "passed" if not violations else "failed", "allowedLicenses": sorted(ALLOWED), "violations": violations}
output = Path(args.output)
output.parent.mkdir(parents=True, exist_ok=True)
output.write_text(json.dumps(report, indent=2), encoding="utf-8")
if violations:
    print(json.dumps(report, indent=2))
    sys.exit(1)
