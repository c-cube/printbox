let b =
  let open PrintBox in
  tree
    (frame @@ text "root")
    [
      link ~uri:"#HiddenAnchor" @@ text "link to a hidden anchor";
      vlist ~bars:true [ text "1"; text "2"; text "3"; text "4"; text "5" ];
      frame @@ text "child 1";
      text "child 2";
      frame
      @@ tree empty
           [ tree (frame @@ text "header 3") [ frame @@ text "subchild 3" ] ];
      tree empty [ tree (frame @@ text "header 4") [ text "subchild 4" ] ];
      frame @@ tree (text "header 5") [ text "subchild 5" ];
      frame @@ text "child 5";
      text "separator";
      tree
        (hlist ~bars:false [ text "entry 0.1"; text "entry 0.2" ])
        [ text "child 5.5" ];
      text "separator";
      tree
        (hlist ~bars:false [ text "entry 1"; frame @@ text "entry 2" ])
        [ text "child 6" ];
      anchor ~id:"VisibleAnchor" @@ text "anchor (visible)";
      tree
        (hlist ~bars:true
           [
             anchor ~id:"HiddenAnchor" empty;
             text "entry 3";
             frame @@ text "entry 4";
           ])
        [ text "child 7" ];
      text "separator after hidden anchor";
      anchor ~id:"HiddenAnchor2" empty;
      tree
        (vlist ~bars:false [ text "entry 5"; frame @@ text "entry 6" ])
        [ text "child 8" ];
      text "separator";
      tree
        (vlist ~bars:true [ text "entry 7"; frame @@ text "entry 8" ])
        [ text "child 9" ];
    ]

let () =
  print_endline
  @@ PrintBox_html.(to_string ~config:Config.(tree_summary true default)) b
