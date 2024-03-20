// make the PDF reproducible to ease version control
#set document(date: none)

#import "../src/lib.typ": encode
// #import "@preview/pre-plantuml:0.0.1": encode

= Test

#("https://www.plantuml.com/plantuml/uml/" + encode("@startuml\nPUML -> RUST: HELLO\n@enduml"))
