package supply.license

import rego.v1

allowed := {"MIT", "Apache-2.0", "BSD-2-Clause", "BSD-3-Clause", "ISC", "CC0-1.0", "Unlicense"}

deny contains msg if {
  some i, j
  component := input.components[i]
  license := component.licenses[j].license.id
  not allowed[license]
  msg := sprintf("componente %s usa licenca fora da allowlist: %s", [component.name, license])
}
