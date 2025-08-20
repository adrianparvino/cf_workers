type t
type bound_prepared_statement
type prepared_statement
type 'a results = { results : 'a }

module Bind = struct
  type t

  external unsafeCast : 'a -> t = "%identity"

  let number : int -> t = unsafeCast
  let string : string -> t = unsafeCast

  let null : ('a -> t) -> 'a option -> t =
   fun f -> fun x -> x |> Option.map f |> Js.Null.fromOption |> unsafeCast
end

external run : bound_prepared_statement -> 'a results Js.Promise.t = "run"
[@@mel.send]

external bind : prepared_statement -> Bind.t array -> bound_prepared_statement
  = "bind"
[@@mel.send] [@@mel.variadic]

external prepare : t -> string -> prepared_statement = "prepare" [@@mel.send]

external batch :
  t -> bound_prepared_statement array -> 'a results array Js.Promise.t = "batch"
[@@mel.send]
