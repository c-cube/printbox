module B = PrintBox
module BPlot = PrintBox_ext_plot

(* This tests the printbox-ext-plot extension. *)

let test ~size =
  B.extension
  @@ BPlot.(
       Plot
         {
           default_config with
           size;
           specs =
             [
               Scatterplot
                 { points = [| 0., 1.; 1., 0.; 0.75, 0.75 |]; pixel = "#" };
             ];
         })

let () =
  print_endline "Text output:";
  print_endline @@ PrintBox_text.to_string
  @@ test ~size:BPlot.default_config.size;
  print_endline "\nHTML output:";
  print_endline @@ PrintBox_html.to_string @@ test ~size:(800, 800)
