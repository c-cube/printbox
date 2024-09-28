open Tyxml
module B = PrintBox
module H = Html

(* This tests extensions with HTML-specific support (as well as text backend support). *)

type B.ext += Hello_html of string | Hello_with_header of string

let text_handler ext =
  match ext with
  | Hello_html txt -> PrintBox_text.to_string B.(frame @@ text txt)
  | Hello_with_header txt ->
    PrintBox_text.to_string B.(tree (text "Greetings!") [ frame @@ text txt ])
  | _ -> invalid_arg "text_handler: unrecognized extension"

let html_handler config ext =
  match ext with
  | Hello_html txt -> (H.button [ H.txt txt ] :> PrintBox_html.toplevel_html)
  | Hello_with_header txt ->
    let result = H.button [ H.txt txt ] in
    (PrintBox_html.to_html ~config
       B.(
         tree (text "Greetings!")
           [ B.extension ~key:"Embed_html" (PrintBox_html.Embed_html result) ])
      :> PrintBox_html.toplevel_html)
  | _ -> invalid_arg "html_handler: unknown extension"

let () =
  PrintBox_text.register_extension ~key:"Hello_world" text_handler;
  PrintBox_html.register_extension ~key:"Hello_world" html_handler

let test1 = B.extension ~key:"Hello_world" @@ Hello_html "Hello world!"

let test2 =
  B.extension ~key:"Hello_world" @@ Hello_with_header "Hello wide world!"

let () =
  print_endline "Text output simple:";
  print_endline @@ PrintBox_text.to_string test1;
  print_endline "\nHTML output simple:";
  print_endline @@ PrintBox_html.to_string test1;
  print_endline "\nText output with header:";
  print_endline @@ PrintBox_text.to_string test2;
  print_endline "\nHTML output with header:";
  print_endline
  @@ PrintBox_html.(to_string ~config:Config.(tree_summary true default) test2)
