#import "@preview/prequery:0.1.0": prequery

#let p = plugin("./plantuml_url.wasm")

#let encode(source) = {
  let source = bytes(source)
  let result = p.encode(source)
  let (status, result) = (result.at(0), str(result.slice(1)))
  assert(status == 1, message: result)
  result
}

/// A prequery for PlantUML diagrams. Apart from the `base-url` and trailing `source` parameter, the
/// image file name is also mandatory; it is part of `args` for technical reasons. Rendering fails
/// (outside fallback mode) before images have been downloaded in a preprocessing step.
///
/// This function provides a dictionary with `url` and `path` as metadata under the label
/// `<web-resource>`. The URL is formed by adding the
/// #link("https://plantuml.com/text-encoding")[encoded form of the diagram] to the base URL. This
/// metadata can be queried like this:
///
/// ```sh
/// typst query --input prequery-fallback=true --field value ... '<web-resource>'
/// ```
///
/// *Fallback:* renders the raw source block.
///
/// - base-url (string): the PlantUML base URL to be used for generated URLs
/// - ..args (arguments): arguments to be forwarded to `image`
/// - source (raw): the PlantUML source code as a raw block
/// -> content
#let plantuml-url(base-url, ..args, source) = {
  let url = base-url + encode(source.text)
  let path = args.pos().at(0)
  prequery(
    (url: url, path: path),
    <web-resource>,
    image.with(..args),
    fallback: source,
  )
}


/// A prequery for PlantUML diagrams. Apart from the trailing `source` parameter, the image file
/// name is also mandatory; it is part of `args` for technical reasons. Rendering fails (outside
/// fallback mode) before images have been generated in a preprocessing step.
///
/// This function provides a dictionary with `source` and `path` as metadata under the label
/// `<plantuml>`. The sources are strings that can be given to the
/// #link("https://plantuml.com/command-line#f92fb84f0d5ea07f")[PlantUML CLI] via stdin. This
/// metadata can be queried like this:
///
/// ```sh
/// typst query --input prequery-fallback=true --field value ... '<plantuml>'
/// ```
///
/// *Fallback:* renders the raw source block.
///
/// - ..args (arguments): arguments to be forwarded to `image`
/// - source (raw): the PlantUML source code as a raw block
/// -> content
#let plantuml-source(..args, source) = {
  let path = args.pos().at(0)
  prequery(
    (source: source.text, path: path),
    <plantuml>,
    image.with(..args),
    fallback: source,
  )
}
