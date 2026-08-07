# Evidências do pipeline

Os artefatos de release não são versionados porque incluem digests, datas e dados da execução. O pipeline os publica como artefatos do GitHub Actions e, para tags, como anexos da GitHub Release.

| Evidência | Origem | Validação |
| --- | --- | --- |
| `sbom.cdx.json` e `sbom.spdx.json` | Syft/Anchore | CycloneDX CLI e policy de licenças |
| `trivy.json` | Trivy | anexado e atestado com Cosign |
| `provenance*.json` | GitHub Attestations | `cosign verify-attestation` |
| `cosign-verify*.txt` | Cosign | prova de assinatura e provenance válidas |
| `dependency-track-log.json` | script de integração | status de aceitação da submissão |
| `cyclonedx-*.txt` | CycloneDX CLI | validação e análise do SBOM |
| `release-summary.txt` | workflow | referência, digest e modo do pipeline |
| `gate-bloqueio-exemplo.txt` | admission controller | exemplo de imagem sem assinatura bloqueada |
| `verification/dashboard.html` | verificação pós-release | consolidação visual dos KPIs da release |

Para reproduzir localmente em modo simulado, execute `bash scripts/mock_release_artifacts.sh`, a política de licenças, a submissão mock do Dependency-Track e `python3 scripts/verify_evidence.py`.

Veja também [verificacao-pos-release.md](verificacao-pos-release.md) para a sequência executada depois de uma release publicada.
