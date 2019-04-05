
module B = PrintBox

(* make a square *)
let square n =
  Array.init n
    (fun i -> Array.init n (fun j -> B.sprintf "(%d,%d)" i j))
  |> B.grid

let () =
  for i = 1 to 20 do
    Printf.printf "for %d:\n%a\n\n" i
      (PrintBox_text.output ?indent:None)
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
  PrintBox_text.output stdout grid
