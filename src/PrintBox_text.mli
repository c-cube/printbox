
(* This file is free software. See file "license" for more details. *)

(** {1 Render to Text}

    This module should be used to output boxes directly to a terminal, or
    another  area of monospace text *)

val set_string_len : (Bytes.t -> int) -> unit
(** Set which function is used to compute string length. Typically
    to be used with a unicode-sensitive length function *)

val to_string : PrintBox.t -> string

val output : ?indent:int -> out_channel -> PrintBox.t -> unit

