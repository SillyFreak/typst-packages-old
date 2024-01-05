#import "@preview/tidy:0.2.0"

#import "template.typ": *

#import "../src/lib.typ" as tt

#let package-meta = toml("../typst.toml").package
#let date = none
// #let date = datetime(year: ..., month: ..., day: ...)

// make the PDF reproducible to ease version control
#set document(date: date)

#show: project.with(
  title: "Tidy Types",
  // subtitle: "...",
  authors: package-meta.authors.map(a => a.split("<").at(0).trim()),
  abstract: [
    Helpers for writing complex types in tidy documentation and
    rendering types like tidy outside of tidy-generated signatures.
  ],
  ..if date != none {
    (date: date.display("[month repr:long] [day], [year]"))
  },
  version: package-meta.version,
  url: package-meta.repository
)

#pad(x: 10%, outline(depth: 1))
#pagebreak()

// the scope for evaluating expressions and documentation
#let scope = (tt: tt)

#let ref-fn(name) = link(label(name), raw(name))

#set table(stroke: 0.5pt)

#let style = tidy.styles.minimal
#show raw.where(lang: tt.lang): it => style.show-type(it.text)

= Introduction <intro>

This package contains helpers for documenting the types of values with tidy, just as tidy itself shows them in function signatures. To do so, it produces raw blocks with language #raw(repr(tt.lang)), which can be then styled using a show rule as follows:

```typ
#import "@preview/tidy:0.2.0"
#import "@preview/tidy-types:0.1.0" as tt

// using the default style with default colors
#let style = tidy.styles.default
#show raw.where(lang: tt.lang): it => {
  style.show-type(it.text, style-args: (colors: style.colors))
}

// using the minimal style
#let style = tidy.styles.minimal
#show raw.where(lang: tt.lang): it => style.show-type(it.text)
```

For example, the raw block #raw("```" + tt.lang + " content```", lang: "typ") would be displayed as
#{
  let style = tidy.styles.default
  show raw.where(lang: tt.lang): it => {
    style.show-type(it.text, style-args: (colors: style.colors))
  }
  tt.content
}
in the default style, or
#{
  let style = tidy.styles.minimal
  show raw.where(lang: tt.lang): it => style.show-type(it.text)
  tt.content
}
in the minimal style.
This can be more easily written using the basic function of this package, #ref-fn("tt.type()"): ```typ #tt.type("content")```. In practice, you will not need to use this function directly but instead use the utility functions and variables built on top.

= Built-in Typst types

There are constants for all the built-in types that Typst provides. Note how two of them are prefixed with `"t-"` as their names are keywords -- ```typc none``` and ```typc auto```:

#{
  let type-names = (
    "t-none",
    "t-auto",
    "boolean",
    "integer",
    "float",
    "length",
    "angle",
    "ratio",
    "relative-length",
    "fraction",
    "color",
    "datetime",
    "symbol",
    "bytes",
    "string",
    "content",
    "array",
    "dictionary",
    "function",
    "arguments",
    "selector",
    "module",
  )

  table(
    columns: (1fr,)*6,
    ..type-names.map(name => {
      (raw(name, lang: "typc"), eval("tt." + name, scope: (tt: tt)))
    }).flatten()
  )
}

TODO: some types are missing, update to current typst version

#pagebreak(weak: true)

= Module reference

== `template`

#{
    let module = tidy.parse-module(
      read("../src/lib.typ"),
      label-prefix: "tt.",
      scope: scope,
    )
    tidy.show-module(
      module,
      sort-functions: none,
      style: tidy.styles.minimal,
    )
}
