(** Output Markdown.

    @since 0.9 *)

(* This file is free software. See file "license" for more details. *)

(** {2 Markdown configuration} *)
module Config : sig
  type preformatted =
    | Code_block
    | Code_quote
        (** The output option for preformatted-style text, and for outputting tables as text.
      - [Code_block]: use Markdown's backquoted-block style: [```], equivalent to HTML's [<pre>].
        Downside: Markdown's style classes make it extra prominent.
      - [Code_quote]: use Markdown's inline code style: single quote [`].
        Downside: does not respect whitespace. We double spaces to "· " for indentation. *)

  type t

  val default : t
  (** The configuration that leads to more readable Markdown source code. *)

  val uniform : t
  (** The configuration that leads to more lightweight and uniform rendering. *)

  val html_tables : t -> t
  (** Output tables via {!PrintBox_html}. Already the case for the {!uniform} config. *)

  val text_tables : t -> t
  (** Output tables via {!PrintBox_text}. Already the case for the {!default} config. *)

  val vlists : [ `Line_break | `List | `As_table ] -> t -> t
  (** How to output {!PrintBox.vlist} boxes, i.e. single-column grids.
      - [`Line_break]: when the {!PrintBox.vlist} has bars, it puts a quoted horizontal rule
        ["> ---"] at the bottom of a row, otherwise puts an extra empty line.
        It is set in the {!uniform} config.
      - [`List]: puts each row as a separate list item; in addition, when the {!PrintBox.vlist}
        has bars, it puts a quoted horizontal rule ["> ---"] at the bottom of a row.
        It is set in the {!default} config.
      - [`As_table] falls back to the general table printing mechanism. *)

  val hlists : [ `Minimal | `As_table ] -> t -> t
  (** How to output {!PrintBox.hlist} boxes, i.e. single-row grids, curently only if they fit
      in one line.
      - [`Minimal] uses spaces and a horizontal bar [" | "] to separate columns.
        It is set in the {!default} config.
      - [`As_table] falls back to the general table printing mechanism. *)

  val foldable_trees : t -> t
  (** Output trees so every node with children is foldable.
      Already the case for the {!uniform} config. *)

  val unfolded_trees : t -> t
  (** Output trees so every node is just the header followed by a list of children.
      Already the case for the {!default} config. *)

  val multiline_preformatted : preformatted -> t -> t
  (* How to output multiline preformatted text, including tables when output as text. *)

  val one_line_preformatted : preformatted -> t -> t
  (* How to output single-line preformatted text. *)

  val tab_width : int -> t -> t
  (* One tab is this many spaces. *)

  val quotation_frames : t -> t
  (** Output frames using Markdown's quotation syntax [> ], or surrouding by [[]] if inline.
      Already the case for the {!default} config. *)

  val table_frames : t -> t
  (** Output frames by falling back to the mechanism used to output tables.
      Already the case for the {!uniform} config. *)
end

val register_extension :
  key:string -> (Config.t -> PrintBox.ext -> string) -> unit
(** Add support for the extension with the given key to this rendering backend.
    Note: the string returned by the handler can have line breaks. *)

val pp : Config.t -> Format.formatter -> PrintBox.t -> unit
(** Pretty-print the Markdown source code into this formatter. *)

val to_string : Config.t -> PrintBox.t -> string
(** A string with the Markdown source code. *)
