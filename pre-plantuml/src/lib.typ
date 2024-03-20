#let p = plugin("./plantuml_url.wasm")

#let encode(source) = {
  let source = bytes(source)
  let result = p.encode(source)
  let (status, result) = (result.at(0), str(result.slice(1)))
  assert(status == 1, message: result)
  result
}
