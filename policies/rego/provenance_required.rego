package supply.provenance

import rego.v1

deny contains "provenance precisa usar o predicateType SLSA v1" if {
  object.get(input, "predicateType", "") != "https://slsa.dev/provenance/v1"
}

deny contains "provenance precisa informar o builder" if {
  object.get(object.get(input, "predicate", {}), "builder", {}).id == ""
}

deny contains "provenance precisa informar o buildType" if {
  object.get(object.get(input, "predicate", {}), "buildType", "") == ""
}
