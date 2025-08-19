module Env : sig
  type t = { ai : Ai.t option; d1 : D1.t option }

  val get : t -> string -> 'a option
end

module Request : sig
  type t =
    | Head
    | Get
    | Post of { body : unit -> string Js.Promise.t }
    | Put of { body : unit -> string Js.Promise.t }
    | Delete
    | Options
end

module Response : sig
  type t

  val create : ?headers:Headers.t -> Js.String.t -> t
end

module Workers_request : sig
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

module Make (_ : sig
  val handle :
    Headers.t -> Env.t -> string -> Request.t -> Response.t Js.Promise.t
end) : sig
  val handle : Workers_request.t -> Env.t -> unit -> Response.t Js.Promise.t
end
