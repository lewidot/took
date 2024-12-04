import gleeunit
import gleeunit/should
import took/router
import wisp/testing

pub fn main() {
  gleeunit.main()
}

pub fn ping_test() {
  let response = router.handle_request(testing.get("/ping", []))

  response.status
  |> should.equal(200)
}
