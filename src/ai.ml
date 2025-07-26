type t
type role_scoped_chat_input = { role : string; content : string }
type tool_call = { name : string; arguments : string }

type text_generation_options = {
  messages : role_scoped_chat_input array;
  max_tokens : int option;
}

type text_generation_output = {
  response : string;
  tool_calls : tool_call array option;
}

external run_text_generation :
  t -> string -> 'a Js.t -> text_generation_output Js.Promise.t = "run"
[@@mel.send]
