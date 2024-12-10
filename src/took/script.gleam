import decode/zero
import gleam/dynamic.{type Dynamic}
import gleam/json
import gleam/list

/// Test Script data structure.
pub type Script {
  Script(title: String, steps: List(String), tags: List(String), status: String)
}

/// Decode dynamic data into a Script.
pub fn decode(data: Dynamic) {
  let decoder = {
    use title <- zero.field("title", zero.string)
    use steps <- zero.field("steps", zero.list(zero.string))
    use tags <- zero.field("tags", zero.list(zero.string))
    zero.success(Script(title:, steps:, tags: list.unique(tags), status: "new"))
  }

  zero.run(data, decoder)
}

/// Encode Script to a json object.
pub fn encode_to_json(script: Script) -> json.Json {
  json.object([
    #("title", json.string(script.title)),
    #("steps", json.array(script.steps, json.string)),
    #("tags", json.array(script.tags, json.string)),
    #("status", json.string(script.status)),
  ])
}
