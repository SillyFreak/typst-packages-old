#import "@preview/tidy:0.1.0"

#import "template.typ": *

// make the PDF reproducible to ease version control
#set document(date: none)

#let package-meta = toml("../typst.toml").package

#show: project.with(
  title: "Template",
  // subtitle: "...",
  authors: package-meta.authors.map(a => a.split("<").at(0).trim()),
  abstract: [
    A template for typst packages
  ],
  // date: "December 22, 2023",
  version: package-meta.version,
  url: package-meta.repository
)

#pad(x: 10%, outline(depth: 1))
#pagebreak()

#let ref-fn(name) = link(label(name), raw(name))

= Introduction

This is a template for typst packages. It provides, for example, the #ref-fn("template.add()") function.

= Module reference

#import "../src/lib.typ"

== `template`

#{
    let module = tidy.parse-module(
      read("../src/lib.typ"),
      label-prefix: "template.",
      scope: (template: lib),
    )
    tidy.show-module(
      module,
      sort-functions: none,
      style: tidy.styles.minimal,
    )
}
