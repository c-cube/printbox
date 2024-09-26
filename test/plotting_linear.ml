module B = PrintBox
module BPlot = PrintBox_ext_plot

(* This tests the printbox-ext-plot extension. *)

let test =
  B.extension
  @@ BPlot.(
       Plot
         {
           default_config with
           specs =
             [
               Line_plot_adaptive
                 {
                   callback = (fun x -> sin x);
                   content = B.line "#";
                   cache = Hashtbl.create 20;
                 };
               Line_plot_adaptive
                 {
                   callback = (fun x -> x ** 2.);
                   content = B.line "%";
                   cache = Hashtbl.create 20;
                 };
               Boundary_map
                 {
                   content_false = B.line ".";
                   content_true = B.line ",";
                   callback = (fun (x, y) -> x > y);
                 };
             ];
         })

let () =
  print_endline "Text output:";
  print_endline @@ PrintBox_text.to_string test;
  print_endline "\nHTML output:";
  print_endline @@ PrintBox_html.to_string test
