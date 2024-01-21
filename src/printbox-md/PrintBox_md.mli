module Config : sig
  type preformatted = Code_quote | Code_block | Stylized

  type t

  val default : t
  val uniform : t

  val html_tables : t -> t
  val text_tables : t -> t
  val foldable_trees : t -> t
  val unfolded_trees : t -> t
  val multiline_preformatted : preformatted -> t -> t
  val one_line_preformatted : preformatted -> t -> t
end

val pp : Config.t -> Format.formatter -> PrintBox.t -> unit

val to_string : Config.t -> PrintBox.t -> string
