#let lang = "tidy-type"

/// Wraps the given string, a type name, into a ```typc raw``` element with the language #raw(repr(tt.lang), lang: "typ").
/// By itself, that doesn't do anything, but it allows styling that text using a ```typc show``` rule; see #link(<intro>)[the introduction].
///
/// #example(`tt.type("foo")`)
///
/// - text (string): the type name
/// -> content
#let type(text) = raw(text, lang: "tidy-type")

#let t-none = type("none")
#let t-auto = type("auto")
#let boolean = type("boolean")
#let integer = type("integer")
#let float = type("float")
#let length = type("length")
#let angle = type("angle")
#let ratio = type("ratio")
#let relative-length = type("relative length")
#let fraction = type("fraction")
#let color = type("color")
#let datetime = type("datetime")
#let symbol = type("symbol")
#let bytes = type("bytes")
#let string = type("string")
#let content = type("content")
#let array = type("array")
#let dictionary = type("dictionary")
#let function = type("function")
#let arguments = type("arguments")
#let selector = type("selector")
#let module = type("module")

/// A function for rendering an array type including element type information:
///
/// #example(`tt.arr(tt.integer)`)
///
/// This representation uses the array spread syntax to convey
/// that there may be any number of #tt.integer elements in the array.
///
/// The name of this function is `arr` because `tt.array` (#tt.array) exists already.
///
/// - element (content): the element type of the array
/// -> content
#let arr(element) = [`(..`#element`)`]

/// A function for rendering a dictionary type including element type information:
///
/// #example(`tt.dict(tt.integer)`)
///
/// This representation uses the implicit #tt.string key type to convey that there may be any number of mappings in the dictionary.
///
/// The name of this function is `dict` because `tt.dictionary` (#tt.dictionary) exists already.
///
/// - value (content): the value type of the dictionary
/// -> content
#let dict(value) = [`(`#string`:`#value`)`]

/// A function for rendering an array type containing exactly the given elements:
///
/// #example(`tt.tuple(tt.string, tt.integer)`)
///
/// - ..elements (content): the tuple element types given as positional parameters
/// -> content
#let tuple(..elements) = {
  if elements.named().len() != 0 {
    panic("tidy-types.tuple() takes only positional parameters")
  }
  let elements = elements.pos()
  [`(`#elements.join(`,`)`)`]
}

/// A function for rendering a dictionary type containing exactly the given pairs:
///
/// #example(`tt.object(a: tt.string, b: tt.integer)`)
///
/// - ..pairs (content): the object attribute name/type pairs given as named parameters
/// -> content
#let object(..pairs) = {
  if pairs.pos().len() != 0 {
    panic("tidy-types.object() takes only named parameters")
  }
  let elements = pairs.named().pairs()
    .map(((name, type)) => [#raw(name)`:`#type])
  [`(`#elements.join(`,`)`)`]
}

/// A function for rendering a function type taking the given parameters and having the given return type:
///
///
/// #example(```
/// tt.func(
///   tt.string, opt: tt.boolean,
///   tt.integer)
/// ```)
///
/// Note that the relative order of positional and named parameters is not preserved; all named parameters come after all positional parameters. It makes sense to, as a convention, put the result type after any named parameters.
///
/// The name of this function is `func` because `tt.function` (#tt.function) exists already.
///
/// - ..args (content): the function parameter types and return type (last positional argument) of the function
/// -> content
#let func(..args) = {
  let positional-params = args.pos()
  let result = positional-params.pop()
  let named-params = args.named()
  let params = (
    ..positional-params,
    ..named-params.pairs().map(((name, type)) => [#raw(name)`:`#type]),
  )
  [`(`#params.join(`,`)`)`#sym.arrow.r#result]
}
