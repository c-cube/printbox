open Tyxml
module B = PrintBox
module H = Html

(* This tests extensions with HTML-specific support (as well as text backend support). *)

type B.ext += Hello_html of string

let () =
  B.register_extension ~key:"hello_html" ~domain:(function
    | Hello_html _ -> true
    | _ -> false)

let example = Hello_html ""

let text_handler ext ~nested:_ =
  match ext with
  | Hello_html txt -> B.Same_as (B.frame @@ B.text txt)
  | _ -> B.Unrecognized_extension

let html_handler ext ~nested:_ =
  match ext with
  | Hello_html txt ->
    let result = H.h2 [ H.txt txt ] in
    PrintBox_html.Render_html result
  | _ -> B.Unrecognized_extension

let () =
  B.register_extension_handler ~backend_name:"text" ~example
    ~handler:text_handler;
  B.register_extension_handler ~backend_name:"html" ~example
    ~handler:html_handler

let test = B.extension @@ Hello_html "Hello world!"

let () =
  print_endline "Text output:";
  print_endline @@ PrintBox_text.to_string test;
  print_endline "\nHTML output:";
  print_endline @@ PrintBox_html.to_string test
