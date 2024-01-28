let b =
  let open PrintBox in
  tree
    (frame @@ text "root")
    [
      frame @@ text "child 1";
      text "child 2";
      frame
      @@ tree empty
           [ tree (frame @@ text "header 3") [ frame @@ text "subchild 3" ] ];
      tree empty [ tree (frame @@ text "header 4") [ text "subchild 4" ] ];
      frame @@ tree (text "header 5") [ text "subchild 5" ];
      frame @@ text "child 5";
    ]

let () =
  print_endline
  @@ PrintBox_html.(to_string ~config:Config.(tree_summary true default)) b
