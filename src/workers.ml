module Env = struct
  type t = { ai : Ai.t option; d1 : D1.t option }

  external getUnsafe : t -> string -> 'a = "" [@@mel.get_index]

  let get = getUnsafe
end

module Request = struct
  type t =
    | Head of { url : string; headers : Headers.t; env : Env.t }
    | Get of { url : string; headers : Headers.t; env : Env.t }
    | Post of {
        url : string;
        headers : Headers.t;
        env : Env.t;
        body : unit -> string Js.Promise.t;
      }
    | Put of {
        url : string;
        headers : Headers.t;
        env : Env.t;
        body : unit -> string Js.Promise.t;
      }
    | Delete of { url : string; headers : Headers.t; env : Env.t }
    | Options of { url : string; headers : Headers.t; env : Env.t }
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
  type t = {
    _method : String.t; [@mel.as "method"]
    headers : Headers.t;
    url : Js.String.t;
  }

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
    let { headers; url; _method } = request in
    let request =
      match _method with
      | "HEAD" -> Request.Head { url; headers; env }
      | "GET" -> Request.Get { url; headers; env }
      | "POST" ->
          Request.Post
            {
              url;
              headers;
              env;
              body = (fun () -> request |> Workers_request.text ());
            }
      | "PUT" ->
          Request.Put
            {
              url;
              headers;
              env;
              body = (fun () -> request |> Workers_request.text ());
            }
      | "DELETE" -> Request.Delete { url; headers; env }
      | "OPTIONS" -> Request.Options { url; headers; env }
      | _ -> failwith "method not supported"
    in
    Handler.handle request
end
