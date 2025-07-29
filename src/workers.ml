module Env = struct
  type t = { ai : Ai.t option; d1 : D1.t option }

  external getUnsafe : t -> string -> 'a = "" [@@mel.get_index]

  let get = getUnsafe
end

module Request = struct
  type t =
    | Head of { headers : Headers.t; env : Env.t }
    | Get of { headers : Headers.t; env : Env.t }
    | Post of {
        headers : Headers.t;
        env : Env.t;
        body : unit -> string Js.Promise.t;
      }
    | Put of {
        headers : Headers.t;
        env : Env.t;
        body : unit -> string Js.Promise.t;
      }
    | Delete of { headers : Headers.t; env : Env.t }
    | Options of { headers : Headers.t; env : Env.t }
end

module Response = struct
  type t
  type options = { headers : Headers.t } [@@warning "-69"]

  external make : 'a -> options -> t = "Response" [@@mel.new]

  let create ?headers response =
    let headers =
      match headers with
      | Some headers -> headers
      | None ->
          let header = Headers.empty () in
          let _ = header |> Headers.set "content-type" "application/json" in
          header
    in
    make response { headers }
end

module Workers_request = struct
  type t = { _method : String.t; [@mel.as "method"] headers : Headers.t }

  external text : unit -> (t[@mel.this]) -> String.t Js.Promise.t = "text"
  [@@mel.send]

  external json : unit -> (t[@mel.this]) -> 'a Js.t Js.Promise.t = "json"
  [@@mel.send]
end

module Make (Handler : sig
  val handle : Request.t -> Response.t Js.Promise.t
end) =
struct
  let handle request env () =
    let open Workers_request in
    let headers = request.headers in
    let request =
      match request._method with
      | "HEAD" -> Request.Head { headers; env }
      | "GET" -> Request.Get { headers; env }
      | "POST" ->
          Request.Post
            {
              headers;
              env;
              body = (fun () -> request |> Workers_request.text ());
            }
      | "PUT" ->
          Request.Put
            {
              headers;
              env;
              body = (fun () -> request |> Workers_request.text ());
            }
      | "DELETE" -> Request.Delete { headers; env }
      | "OPTIONS" -> Request.Options { headers; env }
      | _ -> failwith "method not supported"
    in
    Handler.handle request
end
