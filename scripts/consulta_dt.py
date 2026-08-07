#!/usr/bin/env python3
"""Submete SBOM ao Dependency-Track ou gera evidência mockada."""
import argparse
import base64
import json
import os
from pathlib import Path
from urllib import request

parser = argparse.ArgumentParser()
parser.add_argument("--sbom", required=True)
parser.add_argument("--project", required=True)
parser.add_argument("--version", required=True)
parser.add_argument("--output", required=True)
parser.add_argument("--mock", action="store_true")
args = parser.parse_args()
payload = {"projectName": args.project, "projectVersion": args.version, "autoCreate": "true", "bom": base64.b64encode(Path(args.sbom).read_bytes()).decode()}
output = Path(args.output)
output.parent.mkdir(parents=True, exist_ok=True)
url, key = os.getenv("DT_URL", "").rstrip("/"), os.getenv("DT_API_KEY", "")
if args.mock or not url or not key:
    result = {"mode": "mock", "status": "accepted", "projectName": args.project, "projectVersion": args.version}
else:
    req = request.Request(f"{url}/api/v1/bom", data=json.dumps(payload).encode(), headers={"Content-Type": "application/json", "X-Api-Key": key}, method="POST")
    with request.urlopen(req, timeout=30) as response:
        result = {"mode": "live", "status": response.status, "response": response.read().decode()}
output.write_text(json.dumps(result, indent=2), encoding="utf-8")
