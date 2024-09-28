module B = PrintBox

(* This tests that all backends support extensions that expand into boxes. *)

type B.ext += Hello_world of string

let text_handler ext =
  match ext with
  | Hello_world txt -> PrintBox_text.to_string (B.frame @@ B.text txt)
  | _ -> invalid_arg "text_handler: unrecognized extension"

let md_handler config ext =
  match ext with
  | Hello_world txt ->
    String.trim PrintBox_md.(to_string config (B.frame @@ B.text txt))
  | _ -> invalid_arg "text_handler: unrecognized extension"

let html_handler config ext =
  match ext with
  | Hello_world txt ->
    PrintBox_html.((to_html ~config (B.frame @@ B.text txt) :> toplevel_html))
  | _ -> invalid_arg "text_handler: unrecognized extension"

let () =
  PrintBox_text.register_extension ~key:"Hello_world" text_handler;
  PrintBox_md.register_extension ~key:"Hello_world" md_handler;
  PrintBox_html.register_extension ~key:"Hello_world" html_handler

let test = B.extension ~key:"Hello_world" @@ Hello_world "Hello world!"

let () =
  print_endline "Text output:";
  print_endline @@ PrintBox_text.to_string test;
  print_endline "\nMarkdown output:";
  (print_endline @@ PrintBox_md.(to_string Config.default test));
  print_endline "\nHTML output:";
  print_endline @@ PrintBox_html.to_string test
