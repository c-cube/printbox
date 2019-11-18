(* This file is free software. See file "license" for more details. *)

(** {1 Render to Text}

    This module should be used to output boxes directly to a terminal, or
    another  area of monospace text *)

val set_string_len : (String.t -> int -> int -> int) -> unit
(** Set which function is used to compute string length. Typically
    to be used with a unicode-sensitive length function.
    An example of such a function for utf8 encoded strings is the following
    (it uses the [Uutf] and [Uucp] libraries):
    {[
      let string_leng s i len =
        Uutf.String.fold_utf_8 ~pos:i ~len
          (fun n _ c -> n+ max 0 (Uucp.Break.tty_width_hint c)) 0 s
    ]}
    Note that this function assumes there is no newline character in the given string.

    @since 0.3, this is also used in [printbox_unicode] to basically install the code above
*)

val to_string : PrintBox.t -> string
(** Returns a string representation of the given structure.
    @param style if true, emit ANSI codes for styling (default true) (@since 0.3) *)

val to_string_with : style:bool -> PrintBox.t -> string
(** Returns a string representation of the given structure, with style.
    @param style if true, emit ANSI codes for styling
    @since 0.3
*)

val output : ?style:bool -> ?indent:int -> out_channel -> PrintBox.t -> unit
(** Outputs the given structure on the channel.
    @param indent initial indentation to use
    @param style if true, emit ANSI codes for styling (default true) (@since 0.3)
*)

val pp : Format.formatter -> PrintBox.t -> unit
(** Pretty-print the box into this formatter.
    @since 0.2 *)

val pp_with : style:bool -> Format.formatter -> PrintBox.t -> unit
(** Pretty-print the box into this formatter, with style.
    @param style if true, emit ANSI codes for styling
    @since 0.3
*)
