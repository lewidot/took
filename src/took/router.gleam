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

    _ -> wisp.not_found()
  }
}
