type t

external empty : unit -> t = "Headers" [@@mel.new]
external get : string -> (t [@mel.this]) -> string option = "get" [@@mel.send]
external set : string -> string -> (t [@mel.this]) -> unit = "set" [@@mel.send]
