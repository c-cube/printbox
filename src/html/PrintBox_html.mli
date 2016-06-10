
(* This file is free software. See file "license" for more details. *)

(** {1 Output HTML} *)

open Tyxml

type 'a html = 'a Html.elt

val prelude : [> Html_types.style] html
(** HTML text to embed in the "<head>", defining the style for tables *)

val prelude_str : string

val to_html : PrintBox.t -> [`Div] html
(** HTML for one box *)

val to_string : PrintBox.t -> string

val to_string_doc : PrintBox.t -> string
(** Same as {!to_string}, but adds the prelude and some footer *)
