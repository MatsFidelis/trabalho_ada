#!/usr/bin/env python3
"""Cria um manifesto SHA-256 para tornar o bundle de evidências auditável."""
import argparse
import hashlib
import json
from pathlib import Path

FILES = (
    "sbom.cdx.json", "sbom.spdx.json", "trivy.json", "provenance.json",
    "provenance-predicate.json", "cosign-verify.txt", "cosign-verify-attestation.txt",
    "cyclonedx-validate.txt", "cyclonedx-analyze.txt", "license-policy.json",
    "dependency-track-log.json", "release-summary.txt",
)

parser = argparse.ArgumentParser()
parser.add_argument("--directory", default="artifacts")
args = parser.parse_args()
directory = Path(args.directory)
missing = [name for name in FILES if not (directory / name).is_file()]
if missing:
    raise SystemExit("Não é possível criar manifesto; arquivos ausentes: " + ", ".join(missing))

manifest = {
    "schemaVersion": 1,
    "algorithm": "sha256",
    "files": {
        name: hashlib.sha256((directory / name).read_bytes()).hexdigest()
        for name in FILES
    },
}
(directory / "evidence-manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
print(f"Manifesto gerado: {directory / 'evidence-manifest.json'}")
