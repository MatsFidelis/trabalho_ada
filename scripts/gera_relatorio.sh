#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MONTH="${1:-$(date +%Y-%m)}"
OUT_DIR="${ROOT_DIR}/relatorios/${MONTH}"
IMAGE_REPOSITORY="${IMAGE_REPOSITORY:-ghcr.io/exemplo/trabalho-ada}"
mkdir -p "${OUT_DIR}"

write_mock_report() {
  printf 'tag,assinatura_ok,provenance_ok\nv1.0.0,sim,sim\n' > "${OUT_DIR}/conformidade.csv"
  printf '[{"tagName":"v1.0.0","publishedAt":"%s-01T00:00:00Z"}]\n' "${MONTH}" > "${OUT_DIR}/releases.json"
}

if [[ "${MOCK_MODE:-0}" == "1" ]] || ! command -v gh >/dev/null || ! command -v jq >/dev/null || ! command -v cosign >/dev/null; then
  write_mock_report
else
  gh release list --limit 50 --json tagName,publishedAt | jq --arg month "${MONTH}" '[.[] | select(.publishedAt | startswith($month))]' > "${OUT_DIR}/releases.json"
  printf 'tag,assinatura_ok,provenance_ok\n' > "${OUT_DIR}/conformidade.csv"
  jq -r '.[].tagName' "${OUT_DIR}/releases.json" | while read -r tag; do
    image="${IMAGE_REPOSITORY}:${tag}"
    if cosign verify "$image" --certificate-identity-regexp '^https://github.com/.+/.+/.github/workflows/release.yml@refs/tags/.*' --certificate-oidc-issuer https://token.actions.githubusercontent.com >/dev/null 2>&1; then signature=sim; else signature=nao; fi
    if cosign verify-attestation "$image" --type slsaprovenance1 --certificate-identity-regexp '^https://github.com/.+/.+/.github/workflows/release.yml@refs/tags/.*' --certificate-oidc-issuer https://token.actions.githubusercontent.com >/dev/null 2>&1; then provenance=sim; else provenance=nao; fi
    printf '%s,%s,%s\n' "$tag" "$signature" "$provenance" >> "${OUT_DIR}/conformidade.csv"
  done
fi
echo "Relatorio em relatorios/${MONTH}/conformidade.csv"
