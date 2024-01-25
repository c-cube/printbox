let b =
  let open PrintBox in
  let table =
    frame @@ grid_l [
      [ text "a"; text "looooooooooooooooooooooooo\noonng"];
      [ text "bx"; center_hv @@ frame @@ record ["x", int 1; "y", int 2]];
      [ pad' ~col:2 ~lines:2 @@ text "?";
        center_hv @@ record ["x", int 10; "y", int 20]];
    ] in
  let bold = text_with_style Style.bold in
  let native =
    grid_l [
      [ bold "header 1"; bold "header 2"; frame @@ bold "header 3" ];
      [ line "cell 1.1"; frame @@ line "cell 1.2"; line "cell 1.3" ];
      [ frame @@ line "cell 2.1"; line "cell 2.2"; bold "cell 2.3" ];
    ] in
  tree (frame @@ text "root") [
    frame @@ text "child 1";
    text_with_style Style.preformatted "child 2";
    lines ["line 1"; "line 2"; "line 3"];
    vlist ~bars:false [
      line "a row 1"; lines ["a row 2.1"; "a row 2.2"]; frame @@ line "a row 3"];
    vlist ~bars:true [
      line "b row 1"; lines ["b row 2.1"; "b row 2.2"]; bold "b row 3"];
    hlist ~bars:false [
      bold "a longiiish column 1"; line "a longiiish column 2";
      frame @@ line "a longiiish column 3"; line "a longiiish column 4"];
    hlist ~bars:true [
      line "b longiiish column 1"; bold "b longiiish column 2";
      line "b longiiish column 3"; frame @@ line "b longiiish column 4"];
    frame @@ vlist ~bars:true [
      line "c row 1"; lines ["c row 2.1"; "c row 2.2"]; line "c row 3"
    ];
    frame @@ tree empty [
      tree (frame @@ text "header 3") [frame @@ text "subchild 3"]
    ];
    tree empty [
      tree (frame @@ text "header 4") [
        tree (text "<returns>") [text_with_style Style.preformatted "<nothing>"];
        text "& **subchild** 4"]
    ];
    frame @@ tree (text_with_style Style.preformatted "header 5")
      [lines_with_style Style.preformatted
        ["subchild 5"; "  body 5"; "    subbody 5";
         "\tone tab end of sub 5"; "end of 5"]];
    frame table;
    native;
    frame native
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
