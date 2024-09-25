(* This file is free software. See file "license" for more details. *)

(** {1 Output HTML} *)

open Tyxml

type 'a html = 'a Html.elt
type toplevel_html = Html_types.li_content_fun html
type PrintBox.ext_backend_result += Render_html of toplevel_html

val prelude : [> Html_types.style ] html
(** HTML text to embed in the "<head>", defining the style for tables *)

val prelude_str : string

(** {2 Classes and attributes}

    Custom classes and attributes for tables, lists, etc.

    @since 0.5 *)
module Config : sig
  type t

  val default : t
  val cls_table : string list -> t -> t
  val a_table : Html_types.table_attrib Html.attrib list -> t -> t
  val cls_text : string list -> t -> t
  val a_text : Html_types.div_attrib Html.attrib list -> t -> t
  val cls_row : string list -> t -> t
  val a_row : Html_types.div_attrib Html.attrib list -> t -> t
  val cls_col : string list -> t -> t
  val a_col : Html_types.div_attrib Html.attrib list -> t -> t

  val tree_summary : bool -> t -> t
  (** When set to true, the trees are rendered collapsed
      using the [<detalis>] HTML5 element. *)
end

val to_html : ?config:Config.t -> PrintBox.t -> [ `Div ] html
(** HTML for one box *)

val pp :
  ?flush:bool ->
  ?config:Config.t ->
  ?indent:bool ->
  unit ->
  Format.formatter ->
  PrintBox.t ->
  unit

val to_string : ?config:Config.t -> PrintBox.t -> string
val to_string_indent : ?config:Config.t -> PrintBox.t -> string

val to_string_doc : ?config:Config.t -> PrintBox.t -> string
(** Same as {!to_string}, but adds the prelude and some footer *)
