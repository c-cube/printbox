module B = PrintBox
module BPlot = PrintBox_ext_plot

module Rand = struct
  let rand = ref (1l : Int32.t)

  let rand_int32 () =
    let open Int32 in
    rand := logxor !rand @@ shift_left !rand 13;
    rand := logxor !rand @@ shift_right_logical !rand 17;
    rand := logxor !rand @@ shift_left !rand 5;
    !rand

  let float_range low high =
    let raw = Int32.(to_float @@ rem (rand_int32 ()) 10000l) in
    (raw /. 10000. *. (high -. low)) +. low

  let int high = Int32.(to_int @@ rem (rand_int32 ()) (of_int high))
end

let noise () = Rand.float_range (-0.1) 0.1

(* [Array.split] only available since OCaml 4.12. *)
let array_split x =
  let a0, b0 = x.(0) in
  let n = Array.length x in
  let a = Array.make n a0 in
  let b = Array.make n b0 in
  for i = 1 to n - 1 do
    let ai, bi = x.(i) in
    a.(i) <- ai;
    b.(i) <- bi
  done;
  a, b

(* This tests the printbox-ext-plot extension. *)
let moons data_len =
  let npairs = data_len / 2 in
  array_split
    (Array.init npairs (fun _pos ->
         let i = Rand.int npairs in
         let v = Float.(of_int (i / 2) *. pi /. of_int npairs) in
         let c = cos v and s = sin v in
         ( (s +. noise (), c +. noise ()),
           (1.0 -. s +. noise (), 0.5 -. c +. noise ()) )))

let points1, points2 = moons 1024
let callback (x, y) = Float.compare x y > 0

let test =
  B.extension
  @@ BPlot.(
       Plot
         {
           default_config with
           specs =
             [
               Scatterplot { points = points1; content = B.line "#" };
               Scatterplot { points = points2; content = B.line "%" };
               Boundary_map
                 {
                   content_false = B.line ".";
                   content_true = B.line ",";
                   callback;
                 };
             ];
         })

let () =
  print_endline "Text output:";
  print_endline @@ PrintBox_text.to_string test;
  print_endline "\nHTML output:";
  print_endline @@ PrintBox_html.to_string test
