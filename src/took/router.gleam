import gleam/http.{Post}
import gleam/json
import gleam/result
import took/script
import took/web
import wisp.{type Request, type Response}

/// HTTP request handler.
pub fn handle_request(req: Request) -> Response {
  // Apply the middleware stack for this request/response.
  use req <- web.middleware(req)

  case wisp.path_segments(req) {
    // This matches `/`.
    [] -> {
      wisp.ok()
      |> wisp.set_header("content-type", "text/plain")
      |> wisp.string_body("Hello from Took!")
    }

    ["ping"] -> wisp.ok()

    ["scripts"] -> handle_scripts(req)

    _ -> wisp.not_found()
  }
}

pub fn handle_scripts(req: Request) -> Response {
  use <- wisp.require_method(req, Post)
  use json <- wisp.require_json(req)

  let result = {
    // The dynamic value can be decoded into a `Script` value.
    use script <- result.try(script.decode(json))

    // And then a JSON response can be created from the person.
    let object = script.encode_to_json(script)
    Ok(json.to_string_tree(object))
  }

  // An appropriate response is returned depending on whether the JSON could be
  // successfully handled or not.
  case result {
    Ok(json) -> wisp.json_response(json, 201)
    Error(_) -> wisp.unprocessable_entity()
  }
}
