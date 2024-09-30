module B = PrintBox

(* This tests that all backends support extensions that expand into boxes. *)

type B.ext += Hello_world of string

let md_handler config ext =
  match ext with
  | Hello_world txt ->
    String.trim PrintBox_md.(to_string config (B.frame @@ B.text txt))
  | _ -> invalid_arg "text_handler: unrecognized extension"

let () = PrintBox_md.register_extension ~key:"Hello_world" md_handler
let test = B.extension ~key:"Hello_world" @@ Hello_world "Hello world!"

let () =
  print_endline "\nMarkdown output:";
  print_endline @@ PrintBox_md.(to_string Config.default test)
