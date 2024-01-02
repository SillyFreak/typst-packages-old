# adapted from https://github.com/johannes-wolf/cetz/blob/6838c79b017365b6a1f2f0baf90c9f8fbd1700a4/justfile
# licensed under Apache License 2.0

gallery_dir := "./gallery"
test_dir := "./tests"

package target package:
  ./scripts/package "{{target}}" "{{package}}"

install package:
  ./scripts/package "@local" "{{package}}"

# test package:
#   ./scripts/test test "{{package}}"

# update-test package:
#   ./scripts/test update "{{package}}"

# manual:
#   typst c manual.typ manual.pdf

# gallery:
#   for f in "{{gallery_dir}}"/*.typ; do typst c "$f" "${f/typ/png}"; done
