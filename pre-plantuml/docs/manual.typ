#import "@preview/tidy:0.3.0"

#import "template.typ": *

#import "../src/lib.typ" as template

#let package-meta = toml("../typst.toml").package
#let date = none
// #let date = datetime(year: ..., month: ..., day: ...)

#show: project.with(
  title: "pre-plantuml",
  // subtitle: "...",
  authors: package-meta.authors.map(a => a.split("<").at(0).trim()),
  abstract: [
    Extract PlantUML diagrams from Typst documents to be rendered into images.
  ],
  url: package-meta.repository,
  version: package-meta.version,
  date: date,
)

// the scope for evaluating expressions and documentation
#let scope = (template: template)

= Introduction

This package provides two #link("https://typst.app/universe/package/prequery")[prequeries] for using PlantUML in Typst:
- #ref-fn("plantuml-url()") provides the encoded diagram URL to preprocessors for downloading the diagram file;
- #ref-fn("plantuml-source()") provides the diagram source code to preprocessors for generating the diagram image locally.

See the Prequery library documentation for more general information on how this can be used.

= Module reference

== `template`

#{
  let module = tidy.parse-module(
    read("../src/lib.typ"),
    // label-prefix: "template.",
    scope: scope,
  )
  tidy.show-module(
    module,
    sort-functions: none,
    style: tidy.styles.minimal,
  )
}
