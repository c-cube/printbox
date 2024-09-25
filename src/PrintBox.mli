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

type position = {
  x: int;
  y: int;
}
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
    bg_color: color option;  (** backgroud color *)
    fg_color: color option;  (** foreground color *)
    preformatted: bool;
        (** where supported, the text rendering should be monospaced and respect whitespace *)
  }
  (** Basic styling (color, bold).
      @since 0.3 *)

  val default : t
  val set_bg_color : color -> t -> t
  val set_fg_color : color -> t -> t
  val set_bold : bool -> t -> t
  val set_preformatted : bool -> t -> t
  val bg_color : color -> t
  val fg_color : color -> t
  val bold : t
  val preformatted : t
end

(** {2 Box Combinators} *)

type t
(** Main type for a document composed of nested boxes.
    @since 0.2 the type [t] is opaque *)

type ext = ..
(** Extensions of the representation.

    @since NEXT_RELEASE
*)

(** The type [view] can be used to observe the inside of the box,
    now that [t] is opaque.

    @since 0.3 added [Align]
    @since 0.5 added [Link]
    @since 0.11 added [Anchor]
    @since NEXT_RELEASE added [Stretch]
*)
type view = private
  | Empty
  | Text of {
      l: string list;
      style: Style.t;
    }
  | Frame of {
      sub: t;
      stretch: bool;
    }
  | Pad of position * t (* vertical and horizontal padding *)
  | Align of {
      h: [ `Left | `Center | `Right ];
      v: [ `Top | `Center | `Bottom ];
      inner: t;
    }  (** Alignment within the surrounding box *)
  | Grid of [ `Bars | `None ] * t array array
  | Tree of int * t * t array (* int: indent *)
  | Link of {
      uri: string;
      inner: t;
    }
  | Anchor of {
      id: string;
      inner: t;
    }
  | Ext of {
      key: string;
      ext: ext;
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
val bool_ : bool -> t
val float_ : float -> t

val int : int -> t
(** @since 0.2 *)

val bool : bool -> t
(** @since 0.2 *)

val float : float -> t
(** @since 0.2 *)

val frame : ?stretch:bool -> t -> t
(** Put a single frame around the box.
    @param stretch if true (default false), the frame expands to
    fill the available space. Present since NEXT_RELEASE *)

val pad : t -> t
(** Pad the given box with some free space *)

val pad' : col:int -> lines:int -> t -> t
(** Pad with the given number of free cells for lines and columns *)

val vpad : int -> t -> t
(** Pad vertically by [n] spaces *)

val hpad : int -> t -> t
(** Pad horizontally by [n] spaces *)

val align :
  h:[ `Left | `Right | `Center ] -> v:[ `Top | `Bottom | `Center ] -> t -> t
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

val grid : ?pad:(t -> t) -> ?bars:bool -> t array array -> t
(** Grid of boxes (no frame between boxes). The matrix is indexed
    with lines first, then columns. The array must be a proper matrix,
    that is, all lines must have the same number of columns!
    @param pad used to pad each cell (for example with {!vpad} or {!hpad}),
      default doesn't do anything
    @param bars if true, each item of the grid will be framed.
      default value is [true] *)

val grid_text : ?pad:(t -> t) -> ?bars:bool -> string array array -> t
(** Same as {!grid}, but wraps every cell into a {!text} box *)

val transpose : 'a array array -> 'a array array
(** Transpose a matrix *)

val init_grid :
  ?bars:bool -> line:int -> col:int -> (line:int -> col:int -> t) -> t
(** Same as {!grid} but takes the matrix as a function *)

val grid_l : ?pad:(t -> t) -> ?bars:bool -> t list list -> t
(** Same as {!grid} but from lists.
    @since 0.3 *)

val grid_text_l : ?pad:(t -> t) -> ?bars:bool -> string list list -> t
(** Same as {!grid_text} but from lists.
    @since 0.3 *)

val record : ?pad:(t -> t) -> ?bars:bool -> (string * t) list -> t
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

val v_record : ?pad:(t -> t) -> ?bars:bool -> (string * t) list -> t
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

val anchor : id:string -> t -> t
(** [anchor ~id inner] provides an anchor with the given ID, with the visible hyperlink description
    being [inner].
    Will render in HTML as an "<a>" element, and as a link in ANSI stylized text.
    If [inner] is non-empty, the rendered link URI is ["#" ^ id].
    @since 0.11
*)

val extension : ext -> t
(** [extension ext] embeds an extended representation [ext] as a box. [ext] must be recognized
    as a registered extension by one of the [to_key] arguments passed to {!register_extension}.
    @since NEXT_RELEASE
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

val asprintf_with_style :
  Style.t -> ('a, Format.formatter, unit, t) format4 -> 'a
(** Formatting for {!text}, with style.
    @since 0.3 *)

(** {2 Managing Representation Extensions} *)

val is_empty : t -> bool
(** [is_empty b] is equivalent to [match view b with Empty -> true | _ -> false]. *)

val register_extension : key:string -> domain:(ext -> bool) -> unit
(** Registers a new representation extension, where [key] is a unique identifier for
    the scope of the extension values, and [domain] delineates that scope.
    Intended for extension writers.
    @since NEXT_RELEASE *)

type ext_backend_result = ..
(** The type packaging backend-dependent results of handling a representation extension. *)

type ext_backend_result +=
  | Unrecognized_extension  (** This is an error condition. *)
  | Same_as of t
        (** The result of rendering is the same as for the given box. *)

val register_extension_handler :
  backend_name:string ->
  example:ext ->
  handler:(ext -> nested:(t -> ext_backend_result) -> ext_backend_result) ->
  unit
(** Registers a [handler] for the backend [backend_name] of extensions of the same domain
    as [example]. Intended for extension writers.
    @since NEXT_RELEASE *)

val get_extension_handler :
  backend_name:string ->
  key:string ->
  ext ->
  nested:(t -> ext_backend_result) ->
  ext_backend_result
(** [get_extension_handler ~backend_name] returns a getter function for extension handlers.
    Intended for backend writers.
    @since NEXT_RELEASE *)

val expand_extensions_same_as_only : backend_name:string -> t -> t
(** [expand_extensions_same_as_only ~backend_name b] expands extensions in [b] for the backend,
    as long as the backend's extension handlers (for extensions in [b]) only use
    the [Same_as] variant of {!ext_backend_result}.
    @since NEXT_RELEASE *)

(** {2 Simple Structural Interface} *)

type 'a ktree = unit -> [ `Nil | `Node of 'a * 'a ktree list ]
type box = t

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
