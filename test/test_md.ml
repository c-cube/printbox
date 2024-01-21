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
    frame @@ tree (text_with_style Style.preformatted "header 5") [text "subchild 5"];
    frame @@ text "child 6"
  ]

let () = print_endline "Test unfolded:"

let () = print_endline @@ PrintBox_md.(to_string ~tables:`Text ~foldable_trees:false) b

let () = print_endline "Test foldable:"

let () = print_endline @@ PrintBox_md.(to_string ~tables:`Text ~foldable_trees:true) b

let () = print_endline "The end."
