#!/usr/bin/env python3
"""Gera uma evidência HTML simples com KPIs de compliance."""
import argparse
import csv
import json
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("--csv", required=True)
parser.add_argument("--dt-log", required=True)
parser.add_argument("--trivy-log", required=True)
parser.add_argument("--output", required=True)
args = parser.parse_args()
rows = list(csv.DictReader(Path(args.csv).open(encoding="utf-8")))
dt = json.loads(Path(args.dt_log).read_text(encoding="utf-8"))
trivy = json.loads(Path(args.trivy_log).read_text(encoding="utf-8"))
findings = sum(len(result.get("Vulnerabilities", [])) for result in trivy.get("Results", []))
metrics = {"Releases avaliadas": len(rows), "Assinaturas validas": sum(r.get("assinatura_ok") == "sim" for r in rows), "Provenance valida": sum(r.get("provenance_ok") == "sim" for r in rows), "Dependency-Track": 1 if str(dt.get("status")).lower() in {"accepted", "200", "201"} else 0, "Vulnerabilidades criticas/altas": findings}
cards = "".join(f"<section><h2>{name}</h2><p>{value}</p></section>" for name, value in metrics.items())
html = f"<!doctype html><html lang='pt-BR'><meta charset='utf-8'><title>Compliance</title><style>body{{font-family:sans-serif;margin:3rem;background:#f5f7fa}}main{{max-width:1000px;margin:auto}}section{{display:inline-block;vertical-align:top;background:white;margin:8px;padding:20px;min-width:180px;border-radius:10px;box-shadow:0 2px 8px #ddd}}p{{font-size:2rem;color:#087f5b}}</style><main><h1>Dashboard de Compliance</h1>{cards}</main></html>"
output = Path(args.output)
output.parent.mkdir(parents=True, exist_ok=True)
output.write_text(html, encoding="utf-8")
