(* This file is free software. See file "license" for more details. *)

(** {1 Output HTML} *)

open Tyxml

type 'a html = 'a Html.elt
type toplevel_html = Html_types.li_content_fun html
type summary_html = Html_types.span_content_fun html

type PrintBox.ext +=
  | Embed_html of toplevel_html
        (** Injects HTML into a box. It is handled natively by [PrintBox_html].
            NOTE: this extension is unlikely to be supported by other backends! *)
  | Embed_summary_html of summary_html
        (** Injects HTML intended for tree nodes into a box.
            It is handled natively by [PrintBox_html].
            NOTE: this extension is unlikely to be supported by other backends! *)


val embed_html : toplevel_html -> PrintBox.t
(** Injects HTML into a box. NOTE: this is unlikely to be supported by other backends! *)

val embed_summary_html : summary_html -> PrintBox.t
(** Injects HTML intended for tree nodes into a box.
    NOTE: this is unlikely to be supported by other backends! *)

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

val register_extension :
  key:string -> (Config.t -> PrintBox.ext -> toplevel_html) -> unit
(** Add support for the extension with the given key to this rendering backend. *)

val register_summary_extension :
  key:string -> (Config.t -> PrintBox.ext -> summary_html) -> unit
(** Add support for the extension with the given key to this rendering backend. *)

val to_html : ?config:Config.t -> PrintBox.t -> [ `Div ] html
(** HTML for one box *)

exception Summary_not_supported
(** Raised by {!to_summary_html} if the box cannot be rendered suitably
    for a summary part of the details element. *)

val to_summary_html : ?config:Config.t -> PrintBox.t -> summary_html
(** HTML suitable for tree nodes. Raises {!Summary_not_supported} if the box
    cannot be rendered in this form. *)

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
