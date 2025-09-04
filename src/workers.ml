module Env = struct
  type t

  external getUnsafe : t -> string -> 'a = "" [@@mel.get_index]

  let get = getUnsafe

  let getAI env key =
    let ai = getUnsafe env key in
    ai

  let getD1 env key =
    let d1 = getUnsafe env key in
    d1
end

module Request = struct
  type t =
    | Head
    | Get
    | Post of { body : unit -> string Js.Promise.t }
    | Put of { body : unit -> string Js.Promise.t }
    | Delete
    | Options
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

module type Handler = sig
  val handle :
    Ctx.t ->
    Headers.t ->
    Env.t ->
    string ->
    Request.t ->
    Response.t Js.Promise.t
end

module Make (Handler : Handler) = struct
  let handle request env () =
    let open Workers_request in
    let { headers; url; _method } = request in
    let request =
      match _method with
      | "HEAD" -> Request.Head
      | "GET" -> Request.Get
      | "POST" ->
          Request.Post { body = (fun () -> request |> Workers_request.text ()) }
      | "PUT" ->
          Request.Put { body = (fun () -> request |> Workers_request.text ()) }
      | "DELETE" -> Request.Delete
      | "OPTIONS" -> Request.Options
      | _ -> failwith "method not supported"
    in
    Handler.handle Ctx.empty headers env url request
end
