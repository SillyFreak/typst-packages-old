# adapted from https://github.com/johannes-wolf/cetz/blob/6838c79b017365b6a1f2f0baf90c9f8fbd1700a4/justfile
# licensed under Apache License 2.0

package package target:
  ./scripts/package "{{package}}" "{{target}}"

install package:
  ./scripts/package "{{package}}" "@local"

# test package:
#   ./scripts/test test "{{package}}"

# update-test package:
#   ./scripts/test update "{{package}}"

manual package:
  typst c --root "{{package}}" "{{package}}/docs/manual.typ" "{{package}}/docs/manual.pdf"

gallery package:
  for f in "{{package}}/gallery"/*.typ; do typst c --root "{{package}}" "$f"; done
