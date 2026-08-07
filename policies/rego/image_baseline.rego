package supply.image

import rego.v1

deny contains msg if {
  image := object.get(input, "image", "")
  not startswith(image, "ghcr.io/")
  msg := "imagem deve usar o registry ghcr.io"
}

deny contains "tag latest nao e permitida" if {
  endswith(object.get(input, "image", ""), ":latest")
}
