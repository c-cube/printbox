open Tyxml
module B = PrintBox
module H = Html

(* This tests extensions with HTML-specific support (as well as text backend support). *)

type B.ext += Hello_html of string | Hello_with_header of string

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

let summary_handler config ext =
  match ext with
  | Hello_html txt -> (H.button [ H.txt txt ] :> PrintBox_html.summary_html)
  | Hello_with_header txt ->
      let result = H.button [ H.txt txt ] in
      (PrintBox_html.to_summary_html ~config
         B.(
           hlist ~bars:true [text "Greetings!"
             ; B.extension ~key:"Embed_summary_html" (PrintBox_html.Embed_summary_html result) ])
        :> PrintBox_html.summary_html)
    | _ -> invalid_arg "html_handler: unknown extension"
  
let () =
  PrintBox_html.register_extension ~key:"Hello_world" html_handler;
  PrintBox_html.register_summary_extension ~key:"Hello_world" summary_handler

let test1 = B.extension ~key:"Hello_world" @@ Hello_html "Hello world!"

let test2 =
  B.extension ~key:"Hello_world" @@ Hello_with_header "Hello wide world!"

let test3 = B.tree test2 [test1; test2]

let () =
  print_endline "\nHTML output simple:";
  print_endline @@ PrintBox_html.to_string test1;
  print_endline "\nHTML output with header:";
  print_endline
  @@ PrintBox_html.(to_string ~config:Config.(tree_summary true default) test2);
  print_endline "\nHTML output with details and summary:";
  print_endline
  @@ PrintBox_html.(to_string ~config:Config.(tree_summary true default) test3)
