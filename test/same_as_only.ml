module B = PrintBox

(* This tests that all backends support [Same_as]-only extensions. *)

type B.ext += Hello_world of string

let () =
  B.register_extension ~key:"hello_world" ~domain:(function
    | Hello_world _ -> true
    | _ -> false)

let example = Hello_world ""

let handler ext ~nested:_ =
  match ext with
  | Hello_world txt -> B.Same_as (B.frame @@ B.text txt)
  | _ -> B.Unrecognized_extension

let register backend_name =
  B.register_extension_handler ~backend_name ~example ~handler

let () =
  register "text";
  register "html";
  register "md"

let test = B.extension @@ Hello_world "Hello world!"

let () =
  print_endline "Text output:";
  print_endline @@ PrintBox_text.to_string test;
  print_endline "\nHTML output:";
  print_endline @@ PrintBox_html.to_string test;
  print_endline "\nMarkdown output:";
  print_endline @@ PrintBox_md.(to_string Config.default test)
