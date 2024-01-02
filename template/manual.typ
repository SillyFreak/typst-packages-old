#import "@preview/tidy:0.1.0"

#import "src/lib.typ"

= Template

This is a template for typst packages.

#{
    let module = tidy.parse-module(
      read("src/lib.typ"),
      scope: (template: lib),
    )
    tidy.show-module(
      module,
      sort-functions: none,
      style: tidy.styles.minimal,
    )
}
