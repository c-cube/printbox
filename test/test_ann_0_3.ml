
let b =
  let open PrintBox in
  let open Printbox_unicode in
  PrintBox_unicode.setup();
  frame @@ grid_l [
    [text "subject"; text_with_style Style.bold "announce: printbox 0.3"];
    [text "explanation";
    frame @@ text {|PrintBox is a library for rendering nested tables,
    trees, and similar structures in monospace text or HTML.|}];
    [text "github";
    text_with_style Style.(bg_color Blue) "https://github.com/c-cube/printbox/releases/tag/0.3"];
    [text "contributors";
     vlist_map (text_with_style Style.(fg_color Green)) ["Simon"; "Guillaume"; "Matt"]];
    [text "dependencies";
    tree empty
      [tree (text "mandatory")
         [text "dune"; text "bytes"];
       tree (text "optional")
         [text "uutf"; text "uucp"; text "tyxml"]]];
    [text "expected reaction"; text "🎉"];
  ]

let () = print_endline @@ PrintBox_text.to_string b
