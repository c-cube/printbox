open Tyxml
module B = PrintBox
module H = Html

(* This tests extensions with HTML-specific support (as well as text backend support). *)

type B.ext += Hello_html of string | Hello_with_header of string

let () =
  B.register_extension ~key:"hello_html" ~domain:(function
    | Hello_html _ | Hello_with_header _ -> true
    | _ -> false)

let example = Hello_html ""

let text_handler ext ~nested:_ =
  match ext with
  | Hello_html txt -> B.Same_as B.(frame @@ text txt)
  | Hello_with_header txt ->
    B.Same_as B.(tree (text "Greetings!") [ frame @@ text txt ])
  | _ -> B.Unrecognized_extension

let html_handler ext ~nested =
  match ext with
  | Hello_html txt ->
    let result = H.button [ H.txt txt ] in
    PrintBox_html.Render_html result
  | Hello_with_header txt ->
    let result = H.button [ H.txt txt ] in
    nested
      B.(
        tree (text "Greetings!")
          [ embed_rendering @@ PrintBox_html.Render_html result ])
  | _ -> B.Unrecognized_extension

let () =
  B.register_extension_handler ~backend_name:"text" ~example
    ~handler:text_handler;
  B.register_extension_handler ~backend_name:"html" ~example
    ~handler:html_handler

let test1 = B.extension @@ Hello_html "Hello world!"
let test2 = B.extension @@ Hello_with_header "Hello wide world!"

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
