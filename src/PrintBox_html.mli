
(* This file is free software. See file "license" for more details. *)

(** {1 Output HTML} *)

type html = string

val prelude : html
(** HTML text to embed in the "<head>", defining the style for tables *)

val to_string : PrintBox.t -> html
(** HTML for one box *)
