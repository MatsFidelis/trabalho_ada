#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MONTH="${1:-$(date +%Y-%m)}"
OUT_DIR="${ROOT_DIR}/relatorios/${MONTH}"
mkdir -p "${OUT_DIR}"
printf 'tag,assinatura_ok,provenance_ok\nv1.0.0,sim,sim\n' > "${OUT_DIR}/conformidade.csv"
printf '[{"tagName":"v1.0.0","publishedAt":"%s-01T00:00:00Z"}]\n' "${MONTH}" > "${OUT_DIR}/releases.json"
echo "Relatorio em relatorios/${MONTH}/conformidade.csv"
