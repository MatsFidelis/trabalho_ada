#!/usr/bin/env bash
set -euo pipefail

OUTPUT_DIR="${OUTPUT_DIR:-artifacts}"
IMAGE_REF="${IMAGE_REF:-ghcr.io/exemplo/trabalho-ada:mock}"
IMAGE_DIGEST="${IMAGE_DIGEST:-sha256:mockdigest}"
TAG="${GITHUB_REF_NAME:-mock}"
mkdir -p "${OUTPUT_DIR}"

cat > "${OUTPUT_DIR}/sbom.cdx.json" <<EOF
{"bomFormat":"CycloneDX","specVersion":"1.5","version":1,"metadata":{"component":{"type":"application","name":"trabalho-ada","version":"${TAG}"}},"components":[{"type":"application","name":"trabalho-ada","version":"${TAG}","licenses":[{"license":{"id":"MIT"}}]}]}
EOF
cat > "${OUTPUT_DIR}/sbom.spdx.json" <<EOF
{"spdxVersion":"SPDX-2.3","name":"trabalho-ada","packages":[{"name":"trabalho-ada","SPDXID":"SPDXRef-Package","licenseConcluded":"MIT"}]}
EOF
cat > "${OUTPUT_DIR}/trivy.json" <<EOF
{"SchemaVersion":2,"ArtifactName":"${IMAGE_REF}","ArtifactType":"container_image","Results":[]}
EOF
cat > "${OUTPUT_DIR}/provenance.json" <<EOF
{"_type":"https://in-toto.io/Statement/v1","subject":[{"name":"${IMAGE_REF}","digest":{"sha256":"${IMAGE_DIGEST#sha256:}"}}],"predicateType":"https://slsa.dev/provenance/v1","predicate":{"builder":{"id":"https://github.com/actions/attest-build-provenance"},"buildType":"https://github.com/Attestations/GitHubActionsWorkflow@v1"}}
EOF
printf 'mode=mock\nresult=success\n' > "${OUTPUT_DIR}/cosign-verify.txt"
printf 'mode=mock\npredicateType=https://slsa.dev/provenance/v1\n' > "${OUTPUT_DIR}/cosign-verify-attestation.txt"
