# trabalho_ada

Projeto final integrador de compliance contínuo para cadeia de suprimentos de software. A imagem mínima do `Dockerfile` é o artefato do pipeline, portanto não há aplicação de negócio.

## Cobertura do trabalho

| Requisito | Implementação |
| --- | --- |
| 5 policies como código | Policies Rego em `policies/rego` e testes automatizados |
| Policy bloqueante | `ClusterImagePolicy` em `k8s/policy-controller-policy.yaml` |
| SBOM CycloneDX/SPDX | Gerados pelo workflow de release |
| Dependency-Track e licenças | Scripts de submissão e allowlist |
| Assinatura e provenance | Cosign keyless e attestation SLSA |
| Auditoria e KPIs | Relatório mensal, dashboard Grafana e HTML |

## Validação local

```bash
docker build -t trabalho-ada:local .
opa test policies -v
MOCK_MODE=1 bash scripts/gera_relatorio.sh
```

Para simular uma release sem serviços externos:

```bash
bash scripts/mock_release_artifacts.sh
python3 scripts/check_license_policy.py --sbom artifacts/sbom.cdx.json --output artifacts/license-policy.json
python3 scripts/consulta_dt.py --sbom artifacts/sbom.cdx.json --project trabalho-ada --version local --output artifacts/dependency-track-log.json --mock
python3 scripts/gera_dashboard.py --csv "relatorios/$(date +%Y-%m)/conformidade.csv" --dt-log artifacts/dependency-track-log.json --trivy-log artifacts/trivy.json --output verification/dashboard.html
```

`verify.yml` valida o projeto em PRs e pushes na `main`. `release.yml` roda em tags `v*`; no modo `live` publica em GHCR, gera SBOM, scan Trivy, assinatura Cosign e atestações. O disparo manual também permite modo `mock`.

## Mapeamento de controles

| Controle | Referências |
| --- | --- |
| Policy as Code | NIST SSDF PW.7, ISO 27001 A.8 |
| SBOM | NIST SSDF PS.3, ISO 27001 A.5 |
| Assinatura e provenance | SLSA Build L3, NIST SSDF PS.2 |
| Evidências e auditoria | NIST SSDF RV.1, ISO 27001 A.12 |
