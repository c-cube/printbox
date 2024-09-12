let () =
  PrintBox.(
    PrintBox_text.output stdout
    @@ frame
         (vlist
            [
              text "123456789";
              frame (vlist [ text "." |> align ~h:`Right ~v:`Top; text "." ]);
            ]));
  print_endline ""

let () =
  PrintBox.(
    PrintBox_text.output stdout
    @@ frame
         (vlist
            [
              text "123456789";
              frame (vlist [ text "...." |> align ~h:`Right ~v:`Top; text "." ]);
            ]));
  print_endline ""

(* now with stretch *)

let () =
  PrintBox.(
    PrintBox_text.output stdout
    @@ frame
         (vlist
            [
              text "123456789";
              frame ~stretch:true
                (vlist [ text "." |> align ~h:`Right ~v:`Top; text "." ]);
            ]));
  print_endline ""

let () =
  PrintBox.(
    PrintBox_text.output stdout
    @@ frame
         (vlist
            [
              text "123456789";
              frame ~stretch:true
                (vlist [ text "...." |> align ~h:`Right ~v:`Top; text "." ]);
            ]));
  print_endline ""
