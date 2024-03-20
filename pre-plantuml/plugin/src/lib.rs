use std::str;

use wasm_minimal_protocol::*;
use plantuml_encoding::encode_plantuml_deflate;

initiate_protocol!();

#[wasm_func]
pub fn encode(source: &[u8]) -> Vec<u8> {
    match encode_impl(source) {
        Ok(result) => {
            let mut result = result.into_bytes();
            result.insert(0, 1u8);
            result
        }
        Err(result) => {
            let mut result = result.into_bytes();
            result.insert(0, 0u8);
            result
        }
    }
}

fn encode_impl(source: &[u8]) -> Result<String, String> {
    let source = str::from_utf8(source).map_err(|err| format!("{:?}", err))?;
    let encoded = encode_plantuml_deflate(source).map_err(|err| err.0)?;

    Ok(encoded)
}
