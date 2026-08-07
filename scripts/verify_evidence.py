#!/usr/bin/env python3
"""Verifica o conjunto mínimo de evidências produzido pelo pipeline."""
import argparse
import hashlib
import json
import sys
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("--directory", default="artifacts")
args = parser.parse_args()
directory = Path(args.directory)
required = {
    "sbom.cdx.json", "sbom.spdx.json", "trivy.json", "provenance.json",
    "provenance-predicate.json", "cosign-verify.txt", "cosign-verify-attestation.txt",
    "cyclonedx-validate.txt", "cyclonedx-analyze.txt", "license-policy.json",
    "dependency-track-log.json", "release-summary.txt", "evidence-manifest.json",
}
missing = sorted(name for name in required if not (directory / name).is_file())
if missing:
    print("Evidências ausentes: " + ", ".join(missing), file=sys.stderr)
    sys.exit(1)

sbom = json.loads((directory / "sbom.cdx.json").read_text(encoding="utf-8"))
provenance = json.loads((directory / "provenance.json").read_text(encoding="utf-8"))
licenses = json.loads((directory / "license-policy.json").read_text(encoding="utf-8"))
dt_log = json.loads((directory / "dependency-track-log.json").read_text(encoding="utf-8"))
manifest = json.loads((directory / "evidence-manifest.json").read_text(encoding="utf-8"))
assert sbom.get("bomFormat") == "CycloneDX", "SBOM não é CycloneDX"
assert provenance.get("predicateType") == "https://slsa.dev/provenance/v1", "provenance SLSA ausente"
assert licenses.get("status") == "passed", "política de licenças reprovada"
assert str(dt_log.get("status")).lower() in {"accepted", "200", "201"}, "submissão ao Dependency-Track falhou"
assert manifest.get("algorithm") == "sha256", "algoritmo do manifesto inválido"
for filename, expected_hash in manifest.get("files", {}).items():
    evidence = directory / filename
    assert evidence.is_file(), f"arquivo do manifesto ausente: {filename}"
    actual_hash = hashlib.sha256(evidence.read_bytes()).hexdigest()
    assert actual_hash == expected_hash, f"integridade inválida: {filename}"
print(f"Conjunto de evidências válido: {directory}")
