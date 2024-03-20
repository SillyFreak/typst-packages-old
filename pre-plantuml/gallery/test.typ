// make the PDF reproducible to ease version control
#set document(date: none)

#import "../src/lib.typ": plantuml-url, plantuml-source
#import "@preview/prequery:0.1.0"
// #import "@preview/pre-plantuml:0.0.1": plantuml-url, plantuml-source

// toggle this comment or pass `--input prequery-fallback=true` to enable fallback
// #prequery.fallback.update(true)

#let plantuml = plantuml-url.with("https://www.plantuml.com/plantuml/png/")

= Test

#plantuml("assets/uml.png", ```
@startuml
PUML -> RUST: HELLO
@enduml
```)

#plantuml-source("assets/uml.png", ```
@startuml
PUML -> RUST: HELLO
@enduml
```)
