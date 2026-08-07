# Verificação pós-release

Depois da publicação de uma tag `v*`, o workflow `verify.yml` baixa os anexos da GitHub Release e executa esta sequência:

1. `verify_evidence.py` confirma presença e integridade estrutural de SBOM, scan, provenance, licenças, Dependency-Track e resumo.
2. A imagem publicada no GHCR é resolvida pelo digest imutável.
3. `cosign verify` confirma a assinatura keyless emitida pelo GitHub Actions.
4. `cosign verify-attestation` confirma a provenance SLSA v1.
5. O relatório mensal registra, por tag, o resultado das verificações.
6. O dashboard HTML consolida releases, assinaturas, provenance, Dependency-Track e vulnerabilidades.

Os arquivos resultantes ficam no artefato `release-verification-<tag>`, preservando uma evidência independente da etapa de publicação.
