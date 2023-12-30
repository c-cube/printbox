let b =
  let open PrintBox in
  tree (frame @@ text "root") [
    frame @@ text "child 1";
    text "child 2";
    frame @@ tree empty [
      tree (frame @@ text "header 3") [frame @@ text "subchild 3"]
    ];
    tree empty [
      tree (frame @@ text "header 4") [frame @@ text "subchild 4"]
    ];
    frame @@ text "child 5";
    frame @@ tree (frame @@ text "header 6") [
      tree (frame @@ text "child 6") [frame @@ text "subchild 6"]
    ]
  ]

let () = print_endline @@ PrintBox_text.to_string b
