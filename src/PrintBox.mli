(* This file is free software. See file "license" for more details. *)

(** {1 Pretty-Printing of nested Boxes}

    Allows to print nested boxes, lists, arrays, tables in a nice way
    on any monospaced support.

    {[
      # let b = PrintBox.(
          frame
            (vlist [ line "hello";
                     hlist [line "world"; line "yolo"]])
        );;
      val b : t = <abstr>

      # PrintBox_text.output ~indent:2 stdout b;;
        +----------+
        |hello     |
        |----------|
        |world|yolo|
        +----------+
      - : unit = ()

      # let b2 = PrintBox.(
          frame
            (hlist [ text "I love\nto\npress\nenter";
                     grid_text [| [|"a"; "bbb"|];
                                  [|"c"; "hello world"|] |]])
        );;
      val b2 : PrintBox.t = <abstr>

      # PrintBox_text.output stdout b2;;
      +--------------------+
      |I love|a|bbb        |
      |to    |-+-----------|
      |press |c|hello world|
      |enter | |           |
      +--------------------+

     - : unit = ()

    ]}

    Since 0.3 there is also basic support for coloring text:

    {[
      # let b = PrintBox.(
          frame
            (vlist [ line_with_style Style.(bg_color Green) "hello";
                     hlist [line "world"; line_with_style Style.(fg_color Red) "yolo"]])
        );;
      val b : t = <abstr>
    ]}

*)

type position = { x:int ; y: int }
(** Positions are relative to the upper-left corner, that is,
    when [x] increases we go toward the right, and when [y] increases
    we go toward the bottom (same order as a printer) *)

(** {2 Style}

    @since 0.3 *)
module Style : sig
  type color =
    | Black
    | Red
    | Yellow
    | Green
    | Blue
    | Magenta
    | Cyan
    | White

  type t = {
    bold: bool;
    bg_color: color option; (** backgroud color *)
    fg_color: color option; (** foreground color *)
  }
  (** Basic styling (color, bold).
      @since 0.3 *)

  val default : t

  val set_bg_color : color -> t -> t

  val set_fg_color : color -> t -> t

  val set_bold : bool -> t -> t

  val bg_color : color -> t

  val fg_color : color -> t

  val bold : t
end

(** {2 Box Combinators} *)

type t
(** Main type for a document composed of nested boxes.
    @since 0.2 the type [t] is opaque *)

type rich_text
(** Text with formatting and new lines.
    @since NEXT_RELEASE *)

(** The type [view] can be used to observe the inside of the box,
    now that [t] is opaque.

    @since 0.3 added [Align]
    @since 0.5 added [Link]
*)
type view = private
  | Empty
  | Text of rich_text
  | Frame of t
  | Pad of position * t (* vertical and horizontal padding *)
  | Align of {
      h: [`Left | `Center | `Right];
      v: [`Top | `Center | `Bottom];
      inner: t;
    } (** Alignment within the surrounding box *)
  | Grid of [`Bars | `None] * t array array
  | Tree of int * t * t array (* int: indent *)
  | Link of {
      uri: string;
      inner: t;
    }

val view : t -> view
(** Observe the content of the box.
    @since 0.2 *)

(** A box, either empty, containing directly text,  or a table or
    tree of sub-boxes *)

val empty : t
(** Empty box, of size 0 *)

val line : string -> t
(** Make a single-line box.
    @raise Invalid_argument if the string contains ['\n'] *)

val text : string -> t
(** Any text, possibly with several lines *)

val sprintf : ('a, Buffer.t, unit, t) format4 -> 'a
(** Formatting for {!text} *)

val asprintf : ('a, Format.formatter, unit, t) format4 -> 'a
(** Formatting for {!text}.
    @since 0.2 *)

val lines : string list -> t
(** Shortcut for {!text}, with a list of lines.
    [lines l] is the same as [text (String.concat "\n" l)]. *)

val int_ : int -> t
(** @deprecated use {!int} *)
[@@deprecated "use int"]

val bool_ : bool -> t
(** @deprecated use {!bool} *)
[@@deprecated "use bool"]

val float_ : float -> t
(** @deprecated use {!float} *)
[@@deprecated "use float"]

val int : int -> t
(** @since 0.2 *)

val bool : bool -> t
(** @since 0.2 *)

val float : float -> t
(** @since 0.2 *)

val rich_text : rich_text -> t
(** A box containing rich text. See {!Rich_text} for more.
    @since NEXT_RELEASE *)

val frame : t -> t
(** Put a single frame around the box *)

val pad : t -> t
(** Pad the given box with some free space *)

val pad' : col:int -> lines:int -> t -> t
(** Pad with the given number of free cells for lines and columns *)

val vpad : int -> t -> t
(** Pad vertically by [n] spaces *)

val hpad : int -> t -> t
(** Pad horizontally by [n] spaces *)

val align : h:[`Left | `Right | `Center] -> v:[`Top | `Bottom | `Center] -> t -> t
(** Control alignment of the given box wrt its surrounding box, if any.
    @param h horizontal alignment
    @param v vertical alignment
    @since 0.3 *)

val align_right : t -> t
(** Left-pad to the size of the surrounding box, as in [align ~h:`Right ~v:`Top]
    @since 0.3 *)

val align_bottom : t -> t
(** Align to the bottom, as in [align ~h:`Left ~v:`Bottom]
    @since 0.3 *)

val align_bottom_right : t -> t
(** Align to the right and to the bottom, as in [align ~h:`Right ~v:`Bottom]
    @since 0.3 *)

val center_h : t -> t
(** Horizontal center, as in .
    @since 0.3 *)

val center_v : t -> t
(** Vertical center.
    @since 0.3 *)

val center_hv : t -> t
(** Try to center within the surrounding box, as in [align ~h:`Center ~v:`Center]
    @since 0.3 *)

val grid :
  ?pad:(t -> t) ->
  ?bars:bool ->
  t array array -> t
(** Grid of boxes (no frame between boxes). The matrix is indexed
    with lines first, then columns. The array must be a proper matrix,
    that is, all lines must have the same number of columns!
    @param pad used to pad each cell (for example with {!vpad} or {!hpad}),
      default doesn't do anything
    @param bars if true, each item of the grid will be framed.
      default value is [true] *)

val grid_text :
  ?pad:(t -> t) -> ?bars:bool ->
  string array array -> t
(** Same as {!grid}, but wraps every cell into a {!text} box *)

val transpose : 'a array array -> 'a array array
(** Transpose a matrix *)

val init_grid : ?bars:bool ->
  line:int -> col:int -> (line:int -> col:int -> t) -> t
(** Same as {!grid} but takes the matrix as a function *)

val grid_l :
  ?pad:(t -> t) ->
  ?bars:bool ->
  t list list -> t
(** Same as {!grid} but from lists.
    @since 0.3 *)

val grid_text_l :
  ?pad:(t -> t) ->
  ?bars:bool ->
  string list list -> t
(** Same as {!grid_text} but from lists.
    @since 0.3 *)

val record :
  ?pad:(t -> t) ->
  ?bars:bool ->
  (string * t) list -> t
(** A record displayed as a table, each field being a columng [(label,value)].
    {[
      # frame @@ record ["a", int 1; "b", float 3.14; "c", bool true];;
      - : t = +-----------+
              |a|b   |c   |
              |-+----+----|
              |1|3.14|true|
              +-----------+
    ]}
    @since 0.3 *)

val v_record :
  ?pad:(t -> t) ->
  ?bars:bool ->
  (string * t) list -> t
(** Like {!record}, but printed vertically rather than horizontally.
    {[
      # frame @@ v_record ["a", int 1; "b", float 3.14; "c", bool true];;
      - : t = +------+
              |a|1   |
              |-+----|
              |b|3.14|
              |-+----|
              |c|true|
              +------+
    ]}
    @since 0.4 *)

val vlist : ?pad:(t -> t) -> ?bars:bool -> t list -> t
(** Vertical list of boxes *)

val hlist : ?pad:(t -> t) -> ?bars:bool -> t list -> t
(** Horizontal list of boxes *)

val grid_map : ?bars:bool -> ('a -> t) -> 'a array array -> t

val grid_map_l : ?bars:bool -> ('a -> t) -> 'a list list -> t
(** Same as {!grid_map} but with lists.
    @since 0.4 *)

val vlist_map : ?bars:bool -> ('a -> t) -> 'a list -> t

val hlist_map : ?bars:bool -> ('a -> t) -> 'a list -> t

val tree : ?indent:int -> t -> t list -> t
(** Tree structure, with a node label and a list of children nodes *)

val mk_tree : ?indent:int -> ('a -> t * 'a list) -> 'a -> t
(** Definition of a tree with a local function that maps nodes to
    their content and children *)

val link : uri:string -> t -> t
(** [link ~uri inner] points to the given URI, with the visible description
    being [inner].
    Will render in HTML as a "<a>" element.
    @since 0.5
*)

(** {2 Styling combinators} *)

val line_with_style : Style.t -> string -> t
(** Like {!line} but with additional styling.
    @since 0.3 *)

val lines_with_style : Style.t -> string list -> t
(** Like {!lines} but with additional styling.
    @since 0.3 *)

val text_with_style : Style.t -> string -> t
(** Like {!text} but with additional styling.
    @since 0.3 *)

val sprintf_with_style : Style.t -> ('a, Buffer.t, unit, t) format4 -> 'a
(** Formatting for {!text}, with style
    @since 0.3 *)

val asprintf_with_style : Style.t -> ('a, Format.formatter, unit, t) format4 -> 'a
(** Formatting for {!text}, with style.
    @since 0.3 *)

(** Rich text *)
module Rich_text : sig
  type t = rich_text

  (** View on the internals of the rich text.
      {b NOTE} this is unstable for now, no promise of stability is made. *)
  type view = private
    | RT_str of string
    | RT_style of Style.t * t
    | RT_cat of t list

  val view : t -> view

  val s : string -> t
  (** Short for {!text} *)

  val line : string -> t
  (** Make a single-line text object.
      @raise Invalid_argument if the string contains ['\n'] *)

  val text : string -> t
  (** Any text, possibly with several lines *)

  val space : t

  val newline : t

  val cat : t list -> t
  (** [cat txts] is the concatenation of items in [txts]. *)

  val cat_with : sep:t -> t list -> t
  (** [concat_with ~sep l] concatenates items of [l],
      inserting [sep] in between each. It doesn't add [sep] after
      the last element. *)

  val lines : t list -> t
  (** Concatenate with interspersed new lines *)

  val lines_text : string list -> t
  (** same as [lines @@ List.map line l] *)

  val sprintf : ('a, Buffer.t, unit, t) format4 -> 'a
  (** Formatting. *)

  val asprintf : ('a, Format.formatter, unit, t) format4 -> 'a
  (** Formatting. *)

  val with_style : Style.t -> t -> t
  (** Add style to the text. *)

  val bold : t -> t
  (** Short for [with_style Style.bold] *)
end

(** {2 Simple Structural Interface} *)

type 'a ktree = unit -> [`Nil | `Node of 'a * 'a ktree list]
type box = t

(** A simple interface. *)
module Simple : sig
  type t =
    [ `Empty
    | `Pad of t
    | `Text of string
    | `Vlist of t list
    | `Hlist of t list
    | `Table of t array array
    | `Tree of t * t list
    ]

  val of_ktree : t ktree -> t
  (** Helper to convert trees *)

  val map_ktree : ('a -> t) -> 'a ktree -> t
  (** Helper to map trees into recursive boxes *)

  val to_box : t -> box

  val sprintf : ('a, Buffer.t, unit, t) format4 -> 'a
  (** Formatting for [`Text] *)

  val asprintf : ('a, Format.formatter, unit, t) format4 -> 'a
  (** Formatting for [`Text].
      @since 0.2 *)
end

(**/**)

(** Utils *)

val dim_matrix : _ array array -> position
val map_matrix : ('a -> 'b) -> 'a array array -> 'b array array

(**/**)
