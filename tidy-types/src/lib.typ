#let lang = "tidy-type"

#let _type = type

/// Wraps the given string, a type name, into a ```typc raw``` element with the language #raw(repr(tt.lang), lang: "typ").
/// By itself, that doesn't do anything, but it allows styling that text using a ```typc show``` rule; see #link(<intro>)[the introduction].
///
/// #example(`tt.type("foo")`)
///
/// - text (string): the type name
/// -> content
#let type(text) = raw(text, lang: "tidy-type")


// Takes either or both of the named parameters `type` or `value`.
// If both are given, this checks that the example value is actually of that type,
// then a tidy type with that type's name (as given by `str(type)`) is returned.
#let _builtin_type(..args) = {
  assert(args.pos().len() == 0)
  let args = args.named()
  let t = if args.len() == 1 and "value" in args {
    let (value,) = args
    let type = _type(value)
    type
  } else if args.len() == 1 and "type" in args {
    let (type,) = args
    type
  } else if args.len() == 2 and "value" in args and "type" in args {
    let (value, type) = args
    let actual-type = _type(value)
    assert(actual-type == type, message: str(actual-type + " != " + str(type)))
    actual-type
  } else {
    panic("wrong arguments given")
  }

  type(str(t))
}

// General types
#let t-none     = _builtin_type(type: "none",     value: none)
#let bool       = _builtin_type(type: bool,       value: true)
#let int        = _builtin_type(type: int,        value: 1)
#let float      = _builtin_type(type: float,      value: 1.1)
#let str        = _builtin_type(type: str,        value: "")
#let bytes      = _builtin_type(type: bytes,      value: bytes(""))
#let array      = _builtin_type(type: array,      value: ())
#let dictionary = _builtin_type(type: dictionary, value: (:))
#let t-type     = _builtin_type(type: _type,      value: _type)
#let function   = _builtin_type(type: function,   value: () => none)

// Misc Typst-specific types
#let t-auto     = _builtin_type(type: "auto",     value: auto)
#let datetime   = _builtin_type(type: datetime,   value: datetime(year: 1, month: 1, day: 1))
#let duration   = _builtin_type(type: duration,   value: duration(hours: 1))
#let regex      = _builtin_type(type: regex,      value: regex(""))
#let version    = _builtin_type(type: version,    value: version())
#let content    = _builtin_type(type: content,    value: [])
#let symbol     = _builtin_type(type: symbol,     value: sym.arrow)

// Layout & style quantities
#let length     = _builtin_type(type: length,     value: 1pt)
#let ratio      = _builtin_type(type: ratio,      value: 1%)
#let relative   = _builtin_type(type: relative,   value: 1pt + 1%)
#let fraction   = _builtin_type(type: fraction,   value: 1fr)
#let angle      = _builtin_type(type: angle,      value: 1deg)
#let color      = _builtin_type(type: color,      value: red)
#let stroke     = _builtin_type(type: stroke,     value: 2pt + red)
#let alignment  = _builtin_type(type: alignment,  value: center)

// Typst-specific meta stuff
#let location = locate(l =>
  _builtin_type(                type: location,   value: l)
)
#let styles = style(s =>
  _builtin_type(                type: "styles",   value: s)
)
#let label      = _builtin_type(type: label,      value: <a>)
#let selector   = _builtin_type(type: selector,   value: heading.where())
#let module     = _builtin_type(type: module,  /* value: import("...") */)
#let plugin     = _builtin_type(type: plugin,  /* value: plugin("...") */)
#let arguments  = _builtin_type(type: arguments,  value: ((..args) => args)())

/// This is not a real type, but it can be used as the last parameter in @@func() to indicate that
/// the function uses an argument sink to take additional positional or named parameters:
///
/// #example(```
/// tt.func(tt.int, tt.sink, tt.int)
/// ```)
///
/// -> content
#let sink = [ ...]

/// A function for rendering an array type including element type information:
///
/// #example(`tt.arr(tt.int)`)
///
/// This representation uses the array spread syntax to convey
/// that there may be any number of #tt.int elements in the array.
///
/// The name of this function is `arr` because `tt.array` (#tt.array) exists already.
///
/// - element (content): the element type of the array
/// -> content
#let arr(element) = [`(`#element`,`#sink`)`]

/// A function for rendering a dictionary type including element type information:
///
/// #example(`tt.dict(tt.int)`)
///
/// This representation uses the implicit #tt.str key type to convey that there may be any number of mappings in the dictionary.
///
/// The name of this function is `dict` because `tt.dictionary` (#tt.dictionary) exists already.
///
/// - value (content): the value type of the dictionary
/// -> content
#let dict(value) = [`(`#str`:`#value`,`#sink`)`]

/// A function for rendering an array type containing exactly the given elements:
///
/// #example(`tt.tuple(tt.str, tt.int)`)
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
/// #example(`tt.object(a: tt.str, b: tt.int)`)
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
/// #example(```
/// tt.func(
///   tt.str, opt: tt.bool,
///   tt.int)
/// ```)
///
/// Note that the relative order of positional and named parameters is not preserved; all named parameters come after all positional parameters. It makes sense to, as a convention, put the result type after any named parameters. There is one exception to this rule though: if the last positional parameter is @@sink, it will be put after any named arguments:
///
/// #example(```
/// tt.func(
///   tt.str, opt: tt.bool, tt.sink,
///   tt.int)
/// ```)
///
/// The name of this function is `func` because `tt.function` (#tt.function) exists already.
///
/// - ..args (content): the function parameter types and return type (last positional argument) of the function
/// -> content
#let func(..args) = {
  let positional-params = args.pos()
  let result = positional-params.pop()
  let named-params = args.named()
  let with-sink = if positional-params.last() == sink {
    let _ = positional-params.pop()
    true
  } else {
    false
  }
  let params = (
    ..positional-params,
    ..named-params.pairs().map(((name, type)) => [#raw(name)`:`#type]),
    ..if with-sink { (sink,) }
  )
  [`(`#params.join(`,`)`)`#sym.arrow.r#result]
}

/// A function for rendering a choice between the given types:
///
/// #example(`tt.either(tt.str, tt.int)`)
///
/// - ..options (content): the possible types given as positional parameters
/// -> content
#let either(..options) = {
  if options.named().len() != 0 {
    panic("tidy-types.either() takes only positional parameters")
  }
  let options = options.pos()
  [#options.join(`|`)]
}

/// A function for rendering a parameter/element that may be omitted
///
/// #example(```
/// tt.optional(tt.str)
/// parbreak()
/// tt.func(tt.optional(tt.str), tt.str)
/// ```)
///
/// - type (content): the tuple element types given as positional parameters
/// -> content
#let optional(type) = {
  [#type`?`]
}
