module B = PrintBox
module BPlot = PrintBox_ext_plot

(* This tests the printbox-ext-plot extension. *)

let reg_45 =
  B.(
    frame
      (vlist
         [
           text "123456789";
           frame ~stretch:true
             (vlist [ text "...." |> align ~h:`Right ~v:`Top; text "." ]);
         ]))

let for_3 =
  let n = 3 in
  Array.init n (fun i -> Array.init n (fun j -> B.sprintf "(%d,%d)" i j))
  |> B.grid

let nice_unicode =
  B.(
    frame
    @@ vlist
         [
           text "nice unicode! 💪";
           frame
           @@ hlist
                [
                  vlist
                    [
                      text "oï ωεird nums:\nπ/2\nτ/4";
                      center_hv
                      @@ tree (text "0")
                           [ text "1"; tree (text "ω") [ text "ω²" ] ];
                    ];
                  frame @@ frame @@ frame
                  @@ vlist
                       [
                         text "sum=Σ_i a·xᵢ²\n—————\n1+1";
                         align_right @@ text "Ōₒ\nÀ";
                       ];
                ];
         ])

let test ~size =
  B.extension
  @@ BPlot.(
       Plot
         {
           default_config with
           size;
           specs =
             [
               Scatterbag
                 {
                   points =
                     [|
                       (0., 1.), reg_45;
                       (1., 0.), for_3;
                       (0.75, 0.75), nice_unicode;
                     |];
                 };
               (* Map
                 {
                   callback =
                     (fun (x, y) ->
                       let s = ((x ** 2.) +. (y ** 2.)) ** 0.5 in
                       B.line
                       @@
                       if s < 0.3 then
                         " "
                       else if s < 0.6 then
                         "."
                       else if s < 0.9 then
                         ","
                       else if s < 1.2 then
                         ":"
                       else
                         ";");
                 }; *)
             ];
         })

let () =
  print_endline "Text output:";
  print_endline @@ PrintBox_text.to_string
  @@ test ~size:BPlot.default_config.size;
  print_endline "\nHTML output:";
  print_endline @@ PrintBox_html.to_string @@ test ~size:(800, 800)
