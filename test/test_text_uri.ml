let b =
  let open PrintBox in
  vlist
    [
      link ~uri:"#SecondAnchor" @@ frame @@ text "Link to a within-document anchor";
      link ~uri:"https://example.com/1" @@ frame @@ text "child 1";
      link ~uri:"https://example.com/2" @@ text "child 2";
      frame
      @@ tree
           (link ~uri:"https://example.com/3" empty)
           [
             link ~uri:"https://example.com/4"
             @@ tree (frame @@ text "header 3") [ frame @@ text "subchild 3" ];
           ];
      link ~uri:"https://example.com/5"
      @@ tree empty
           [ tree (frame @@ text "header 4") [ frame @@ text "subchild 4" ] ];
      frame @@ text "child 5";
      link ~uri:"https://example.com/6"
      @@ frame
      @@ tree
           (frame @@ text "header 6")
           [
             tree
               (frame @@ text "child 6")
               [
                 link ~uri:"https://example.com/7" @@ frame @@ text "subchild 6";
               ];
           ];
      anchor ~id:"FirstAnchor" @@ frame @@ text "anchor self-link 1";
      tree
        (hlist ~bars:false
           [ anchor ~id:"SecondAnchor" empty; text "silent anchor" ])
        [ text "subchild 7" ];
    ]

let () = print_endline @@ PrintBox_text.to_string b
