#import "@preview/tidy:0.1.0"

#import "src/lib.typ"

// make the PDF reproducible to ease version control
#set document(date: none)

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
