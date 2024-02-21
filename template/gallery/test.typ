// #import "@preview/template:0.0.1": add
// #import "@local/template:0.0.1": add
#import "../src/lib.typ": add

// make the PDF reproducible to ease version control
#set document(date: none)

= Test

#add(2, 7)
