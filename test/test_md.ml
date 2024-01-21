let b =
  let open PrintBox in
  tree (frame @@ text "root") [
    frame @@ text "child 1";
    text_with_style Style.preformatted "child 2";
    lines ["line 1"; "line 2"; "line 3"];
    frame @@ tree empty [
      tree (frame @@ text "header 3") [frame @@ text "subchild 3"]
    ];
    tree empty [
      tree (frame @@ text "header 4") [text "subchild 4"]
    ];
    frame @@ tree (text_with_style Style.preformatted "header 5")
      [lines_with_style Style.preformatted
        ["subchild 5"; "  body 5"; "    subbody 5";
         "\tone tab end of sub 5"; "end of 5"]];
    frame @@ text "child 6"
  ]

let () = print_endline "Test default:"

let () = print_endline @@ PrintBox_md.(to_string Config.default) b

let () = print_endline "Test foldable:"

let () = print_endline @@ PrintBox_md.(to_string Config.(foldable_trees default)) b

let () = print_endline "Test uniform tab=2:"

let () = print_endline @@ PrintBox_md.(to_string Config.(tab_width 2 uniform)) b

let () = print_endline "Test single quote tab=2:"

let () =
  print_endline @@
    PrintBox_md.(to_string Config.(
       tab_width 2 @@ multiline_preformatted Code_quote uniform)) b

let () = print_endline "The end."
