let b =
  let open PrintBox in
  let table =
    frame @@ grid_l [
      [ text "a"; text "looooooooooooooooooooooooo\noonng"];
      [ text "bx"; center_hv @@ frame @@ record ["x", int 1; "y", int 2]];
      [ pad' ~col:2 ~lines:2 @@ text "?";
        center_hv @@ record ["x", int 10; "y", int 20]];
    ] in
  tree (frame @@ text "root") [
    frame @@ text "child 1";
    text_with_style Style.preformatted "child 2";
    lines ["line 1"; "line 2"; "line 3"];
    frame @@ tree empty [
      tree (frame @@ text "header 3") [frame @@ text "subchild 3"]
    ];
    tree empty [
      tree (frame @@ text "header 4") [
        tree (text "<returns>") [text_with_style Style.preformatted "<nothing>"];
        text "& *subchild* 4"]
    ];
    frame @@ tree (text_with_style Style.preformatted "header 5")
      [lines_with_style Style.preformatted
        ["subchild 5"; "  body 5"; "    subbody 5";
         "\tone tab end of sub 5"; "end of 5"]];
    frame table
  ]

let () = print_endline "Test default:"

let () = print_endline @@ PrintBox_md.(to_string Config.default) b

let () = print_endline "Test uniform unfolded:\n"

let () = print_endline @@ PrintBox_md.(to_string Config.(unfolded_trees uniform)) b

let () = print_endline "Test foldable:"

let () = print_endline @@ PrintBox_md.(to_string Config.(foldable_trees default)) b

let () = print_endline "Test uniform tab=2, text tables:"

let () =
  print_endline @@
  PrintBox_md.(to_string Config.(text_tables @@ tab_width 2 uniform)) b

let () = print_endline "Test single quote tab=2, text tables:"

let () =
  print_endline @@
    PrintBox_md.(to_string Config.(
       text_tables @@ tab_width 2 @@ multiline_preformatted Code_quote uniform)) b

let () = print_endline "The end."
