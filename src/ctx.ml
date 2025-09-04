type 'a key = ..
type t = { ctx : 'a. 'a key -> 'a option }

let empty = { ctx = (fun _ -> None) }
