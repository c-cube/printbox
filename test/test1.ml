module B = PrintBox

(* make a square *)
let square n =
  Array.init n
    (fun i -> Array.init n (fun j -> B.sprintf "(%d,%d)" i j))
  |> B.grid

let () =
  for i = 1 to 20 do
    Printf.printf "for %d:\n%a\n\n" i
      (PrintBox_text.output ~style:true ?indent:None)
      (square i)
  done

let tree =
  B.tree (B.text "root")
    [ B.tree (B.text "a") [B.text "a1\na1"; B.text "a2\na2\na2"];
      B.tree (B.text "b") [B.text "b1\nb1"; B.text "b2"; B.text "b3"];
    ]

let () =
  PrintBox_text.output stdout tree

let () =
  Printf.printf "\n\n"

let grid =
  B.frame @@ B.grid_l
    [ [B.text "the center of the triangle is"; B.empty];
      [B.center_hv @@ B.text "lil' ol' me";
       B.pad' ~col:0 ~lines:6 @@ B.text "t\na\nl\nl"];
      [B.align_right (B.text "i'm aligned right"); B.empty];
       [ B.text "loooooooooooooooooooooooooooooooooong"; B.empty; ];
    ]

let () =
  PrintBox_text.output stdout grid;
  print_endline ""

let b2 = PrintBox.(
    let style = Style.(fg_color Red) in
    frame @@ grid_l [
      [text_with_style style "a\nb";
       line_with_style Style.(set_bold true @@ bg_color Green) "OH!"];
      [text "c"; text "ballot"];
    ])

let () =
  PrintBox_text.output stdout b2; Printf.printf "\n\n"

let grid2 =
  B.frame @@ B.record ~pad:B.align_right ["name1", B.int 1; "foo", B.bool true]

let () =
  PrintBox_text.output stdout grid2; print_endline ""

module Box_in = struct
  let b =
    let open B in
    frame @@ grid_l [
      [ text "a"; text "looooooooooooooooooooooooo\noonng"];
      [ text "bx"; center_hv @@ frame @@ record ["x", int 1; "y", int 2]];
      [ pad' ~col:2 ~lines:2 @@ text "?";
        center_hv @@ record ["x", int 10; "y", int 20]];
    ]

  let () = print_endline @@ PrintBox_text.to_string b
end

let b =
  let open PrintBox in
  frame @@ record [
    ("subject", text_with_style Style.bold "announce: printbox 0.3");
    ("explanation",
    frame @@ text {|PrintBox is a library for rendering nested tables,
    trees, and similar structures in monospace text or HTML.|});
    ("github",
    text_with_style Style.(bg_color Blue) "https://github.com/c-cube/printbox/releases/tag/0.3");
    ("contributors",
     vlist_map (text_with_style Style.(fg_color Green)) ["Simon"; "Guillaume"; "Matt"]);
    ("dependencies",
    tree empty
      [tree (text "mandatory")
         [text "dune"; text "bytes"];
       tree (text "optional")
         [text "uutf"; text "uucp"; text "tyxml"]]);
    ("expected reaction", text "🎉");
  ]

module Unicode = struct
  let () = PrintBox_unicode.setup()

  let b =
    B.(frame @@ vlist [text "nice unicode! 💪"; frame @@
    hlist [
      vlist[text "oï ωεird nums:\nπ/2\nτ/4";
        center_hv @@ tree (text "0")[text "1"; tree (text "ω") [text "ω²"]]];
      frame @@ frame @@ frame
      @@ vlist [text "sum=Σ_i a·xᵢ²\n—————\n1+1"; align_right @@ text "Ōₒ\nÀ"]]]);;

  let () = print_endline @@ PrintBox_text.to_string b
end

