#import "@preview/tidy:0.1.0"

#import "../src/lib.typ" as tt
// #import "@local/tidy-types:0.0.1" as tt

// make the PDF reproducible to ease version control
#set document(date: none)

#let style = tidy.styles.default
#show raw.where(lang: "tidy-type"): it => style.show-type(it.text)

= Test

#tt.arr(tt.integer)
