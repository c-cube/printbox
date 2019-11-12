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
  B.vlist
    [ B.align_right (B.text "i'm aligned right")
    ; B.text "looooooooooooooooooooooooong"
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
      [ text "bx"; align_right @@ frame @@ record ["x", int 1; "y", int 2]]
    ]

  let () = print_endline @@ PrintBox_text.to_string b
end

module Unicode = struct
  let () = PrintBox_unicode.setup()

  let b =
    B.(frame @@ vlist [text "nice unicode! 💪"; frame @@
    hlist [
      vlist[text "oï ωεird nums:\nπ/2\nτ/4";
        pad @@ pad @@ tree (text "0")[text "1"; tree (text "ω") [text "ω²"]]];
      frame @@ frame @@ frame
      @@ vlist [text "sum=Σ_i a·xᵢ²\n—————\n1+1"; align_right @@ text "Ōₒ\nÀ"]]]);;

  let () = print_endline @@ PrintBox_text.to_string b
end

