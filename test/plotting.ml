module B = PrintBox
module BPlot = PrintBox_ext_plot

(* This tests the printbox-ext-plot extension. *)

let test ~size =
  BPlot.(
    box
      {
        default_config with
        size;
        specs =
          [
            Scatterbag
              {
                points =
                  [|
                    (0., 1.), B.line "Y";
                    (1., 0.), B.line "X";
                    (0.75, 0.75), B.line "M";
                  |];
              };
            Map
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
              };
          ];
      })

let () =
  print_endline "Text output:";
  print_endline @@ PrintBox_text.to_string
  @@ test ~size:BPlot.default_config.size;
  print_endline "\nHTML output:";
  print_endline @@ PrintBox_html.to_string @@ test ~size:(800, 800)
