type t

external empty : unit -> t = "Headers" [@@mel.new]

external get : string -> (t[@mel.this]) -> string Js.Nullable.t = "get"
[@@mel.send]

external set : string -> string -> (t[@mel.this]) -> unit = "set" [@@mel.send]
