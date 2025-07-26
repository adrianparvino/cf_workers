module Response : sig
  type t
end

module Workers_request : sig
  type t = { _method : String.t; [@mel.as "method"] headers : Headers.t }

  external text : unit -> String.t Js.Promise.t = "text" [@@mel.send.pipe: t]
  external json : unit -> 'a Js.t Js.Promise.t = "json" [@@mel.send.pipe: t]
end

module type Handler = sig
  module Response : sig
    type t

    val render : t -> Js.String.t
  end

  module Env : sig
    type t
  end

  val head : Headers.t -> Env.t -> Response.t Js.Promise.t
  val get : Headers.t -> Env.t -> Response.t Js.Promise.t
  val post : Headers.t -> Env.t -> Js.String.t -> Response.t Js.Promise.t
  val put : Headers.t -> Env.t -> Js.String.t -> Response.t Js.Promise.t
  val delete : Headers.t -> Env.t -> Response.t Js.Promise.t
end

module Make (Handler : Handler) : sig
  val handle :
    Workers_request.t -> Handler.Env.t -> unit -> Response.t Js.Promise.t
end
