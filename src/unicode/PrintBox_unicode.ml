
(** {1 Setup Unicode-aware text printing}

    This module just provides a function, {!setup},
    which installs in {!PrintBox_text} a proper string length function,
    as detailed in https://github.com/c-cube/printbox/issues/4

    It depends on Uucp and Uutf.

    @since NEXT_RELEASE
    *)

let string_len s i len =
  Uutf.String.fold_utf_8 ~pos:i ~len
    (fun n _ c -> match c with
      | `Malformed _ -> 0
      | `Uchar c -> n+ max 0 (Uucp.Break.tty_width_hint c))
    0 s

let setup () =
  PrintBox_text.set_string_len string_len

