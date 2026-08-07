package supply.provenance

import rego.v1

predicate := object.get(input, "predicate", {})
builder_id := object.get(object.get(predicate, "builder", {}), "id", "")
build_type := object.get(predicate, "buildType", "")

deny contains "provenance precisa usar o predicateType SLSA v1" if {
  object.get(input, "predicateType", "") != "https://slsa.dev/provenance/v1"
}

deny contains "provenance precisa informar o builder" if {
  builder_id == ""
}

deny contains "provenance precisa informar o buildType" if {
  build_type == ""
}
