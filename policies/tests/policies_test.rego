package supply.tests

import rego.v1

test_image_accepts_pinned_ghcr_image if {
  count(data.supply.image.deny with input as {"image": "ghcr.io/org/trabalho-ada:v1.0.0"}) == 0
}

test_image_rejects_latest if {
  "tag latest nao e permitida" in data.supply.image.deny with input as {"image": "ghcr.io/org/trabalho-ada:latest"}
}

test_license_rejects_unapproved_license if {
  msgs := data.supply.license.deny with input as {"components": [{"name": "copyleft", "licenses": [{"license": {"id": "GPL-3.0-only"}}]}]}
  count(msgs) == 1
}

test_provenance_accepts_slsa if {
  count(data.supply.provenance.deny with input as {"predicateType": "https://slsa.dev/provenance/v1", "predicate": {"builder": {"id": "github-actions"}, "buildType": "workflow"}}) == 0
}

test_sbom_rejects_empty_components if {
  "sbom precisa listar ao menos um componente" in data.supply.sbom.deny with input as {"bomFormat": "CycloneDX", "metadata": {"component": {"name": "x"}}, "components": []}
}

test_signature_accepts_github_oidc if {
  count(data.supply.signature.deny with input as {"verified": true, "issuer": "https://token.actions.githubusercontent.com", "identity": "https://github.com/org/repo/.github/workflows/release.yml"}) == 0
}
