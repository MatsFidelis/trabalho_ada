package supply.signature

import rego.v1

deny contains "assinatura da imagem nao foi verificada" if {
  object.get(input, "verified", false) != true
}

deny contains "issuer OIDC invalido para assinatura keyless" if {
  object.get(input, "issuer", "") != "https://token.actions.githubusercontent.com"
}

deny contains "identidade da assinatura nao pertence ao GitHub Actions" if {
  not regex.match("^https://github.com/.+/.+", object.get(input, "identity", ""))
}
