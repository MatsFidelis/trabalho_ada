package supply.sbom

import rego.v1

deny contains "sbom precisa informar o campo bomFormat" if {
  object.get(input, "bomFormat", "") == ""
}

deny contains "sbom precisa informar metadata.component.name" if {
  object.get(object.get(object.get(input, "metadata", {}), "component", {}), "name", "") == ""
}

deny contains "sbom precisa listar ao menos um componente" if {
  count(object.get(input, "components", [])) == 0
}
