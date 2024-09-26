open Tyxml
module B = PrintBox
module H = Html

type plot_spec =
  | Scatterplot of {
      points: (float * float) array;
      content: B.t;
    }
  | Scatterbag of { points: ((float * float) * B.t) array }
  | Line_plot of {
      points: float array;
      content: B.t;
    }
  | Boundary_map of {
      callback: float * float -> bool;
      content_true: B.t;
      content_false: B.t;
    }
  | Map of { callback: float * float -> B.t }
  | Line_plot_adaptive of {
      callback: float -> float;
      cache: (float, float) Hashtbl.t;
      content: B.t;
    }
[@@deriving sexp_of]

type graph = {
  specs: plot_spec list;
  x_label: string;
  y_label: string;
  size: int * int;
  no_axes: bool;
  prec: int;
}

let default_config =
  {
    specs = [];
    x_label = "x";
    y_label = "y";
    size = 800, 800;
    no_axes = false;
    prec = 3;
  }

type PrintBox.ext += Plot of graph

let () =
  B.register_extension ~key:"plot" ~domain:(function
    | Plot _ -> true
    | _ -> false)

let plot_canvas ?canvas ?(size : (int * int) option) ?(sparse = false)
    (specs : plot_spec list) =
  (* Unfortunately "x" and "y" of a "matrix" are opposite to how we want them displayed --
     the first dimension (i.e. "x") as the horizontal axis. *)
  let (dimx, dimy, canvas) : int * int * B.t option array array =
    match canvas, size with
    | None, None -> invalid_arg "PrintBox_utils.plot: provide ~canvas or ~size"
    | None, Some (dimx, dimy) -> dimx, dimy, Array.make_matrix dimy dimx None
    | Some canvas, None ->
      let dimy = Array.length canvas in
      let dimx = Array.length canvas.(0) in
      dimx, dimy, canvas
    | Some canvas, Some (dimx, dimy) ->
      assert (dimy = Array.length canvas);
      assert (dimx = Array.length canvas.(0));
      dimx, dimy, canvas
  in
  let all_x_points =
    specs
    |> List.map (function
         | Scatterplot { points; _ } -> Array.map fst points
         | Scatterbag { points } -> Array.map (fun ((x, _), _) -> x) points
         | Line_plot _ -> [||]
         | Map _ | Boundary_map _ -> [||]
         | Line_plot_adaptive _ -> [||])
    |> Array.concat
  in
  let given_y_points =
    specs
    |> List.map (function
         | Scatterplot { points; _ } -> Array.map snd points
         | Scatterbag { points } -> Array.map (fun ((_, y), _) -> y) points
         | Line_plot { points; _ } -> points
         | Map _ | Boundary_map _ -> [||]
         | Line_plot_adaptive _ -> [||])
    |> Array.concat
  in
  let minx =
    if all_x_points = [||] then
      0.
    else
      Array.fold_left min all_x_points.(0) all_x_points
  in
  let maxx =
    if given_y_points = [||] then
      1.
    else if all_x_points = [||] then
      Float.of_int (Array.length given_y_points - 1)
    else
      Array.fold_left max all_x_points.(0) all_x_points
  in
  let spanx = maxx -. minx in
  let spanx =
    if spanx <= epsilon_float then
      1.0
    else
      spanx
  in
  let scale_x x = Float.(to_int (of_int (dimx - 1) *. (x -. minx) /. spanx)) in
  let unscale_x i = Float.(of_int i *. spanx /. of_int (dimx - 1)) +. minx in
  let extra_y_points =
    specs
    |> List.map (function
         | Line_plot_adaptive { callback; cache; _ } ->
           Array.init
             (if sparse then
                dimx / 5
              else
                dimx)
             (fun i ->
               let x =
                 unscale_x
                   (if sparse then
                      i * 5
                    else
                      i)
               in
               let y =
                 match Hashtbl.find_opt cache x with
                 | Some y -> y
                 | None -> callback x
               in
               if not (Hashtbl.mem cache x) then Hashtbl.add cache x y;
               y)
         | _ -> [||])
    |> Array.concat
  in
  let all_y_points = Array.append given_y_points extra_y_points in
  let miny =
    if all_y_points = [||] then
      0.
    else
      Array.fold_left min all_y_points.(0) all_y_points
  in
  let maxy =
    if all_y_points = [||] then
      maxx -. minx
    else
      Array.fold_left max all_y_points.(0) all_y_points
  in
  let spany = maxy -. miny in
  let spany =
    if spany <= epsilon_float then
      1.0
    else
      spany
  in
  let scale_1d y =
    try Some Float.(to_int @@ (of_int (dimy - 1) *. (y -. miny) /. spany))
    with Invalid_argument _ -> None
  in
  let scale_2d (x, y) =
    try
      Some Float.(scale_x x, to_int (of_int (dimy - 1) *. (y -. miny) /. spany))
    with Invalid_argument _ -> None
  in
  let spread ~i ~dmj updated =
    if sparse then
      (i mod 10 = 0 && dmj mod 10 = 0)
      || (i mod 10 = 5 && dmj mod 10 = 0 && not updated)
    else
      true
  in
  let update ~i ~dmj px =
    if
      i >= 0 && dmj >= 0 && i < dimx && dmj < dimy
      && Option.is_none canvas.(dmj).(i)
    then (
      canvas.(dmj).(i) <- Some px;
      true
    ) else
      false
  in
  let prerender_scatter points =
    Array.iter
      (fun (p, content) ->
        match scale_2d p with
        | Some (i, j) -> ignore @@ update ~i ~dmj:(dimy - 1 - j) content
        | None -> ())
      points
  in
  let prerender_map callback =
    let updated = ref true in
    canvas
    |> Array.iteri (fun dmj ->
           Array.iteri (fun i pix ->
               if Option.is_none pix && spread ~i ~dmj !updated then (
                 let x =
                   Float.(of_int i *. spanx /. of_int (dimx - 1)) +. minx
                 in
                 let y =
                   Float.(of_int (dimy - 1 - dmj) *. spany /. of_int (dimy - 1))
                   +. miny
                 in
                 updated := update ~i ~dmj (callback (x, y))
               )))
  in
  specs
  |> List.iter (function
       | Scatterplot { points; content } ->
         prerender_scatter (Array.map (fun p -> p, content) points)
       | Scatterbag { points } -> prerender_scatter points
       | Line_plot { points; content } ->
         let points = Array.map scale_1d points in
         let npoints = Float.of_int (Array.length points) in
         let rescale_x i =
           Float.(to_int @@ (of_int i *. of_int dimx /. npoints))
         in
         (* TODO: implement interpolation if not enough points. *)
         points
         |> Array.iteri (fun i ->
                Option.iter (fun j ->
                    ignore
                    @@ update ~i:(rescale_x i) ~dmj:(dimy - 1 - j) content))
       | Boundary_map { callback; content_true; content_false } ->
         prerender_map (fun point ->
             if callback point then
               content_true
             else
               content_false)
       | Map { callback } -> prerender_map callback
       | Line_plot_adaptive { callback; cache; content } ->
         let updated = ref true in
         canvas.(0)
         |> Array.iteri (fun i _ ->
                if (not sparse) || i mod 5 = 0 || ((not !updated) && i mod 5 = 2)
                then (
                  let x = unscale_x i in
                  let y =
                    match Hashtbl.find_opt cache x with
                    | Some y -> y
                    | None ->
                      let y = callback x in
                      Hashtbl.add cache x y;
                      y
                  in
                  scale_1d y
                  |> Option.iter (fun j ->
                         updated := update ~i ~dmj:(dimy - 1 - j) content)
                )));
  minx, miny, maxx, maxy, canvas

let concise_float = ref (fun ~prec -> Printf.sprintf "%.*g" prec)

let plot ?(prec = 3) ?(no_axes = false) ?canvas ?size ?(x_label = "x")
    ?(y_label = "y") ~sparse embed_canvas specs =
  let minx, miny, maxx, maxy, canvas =
    plot_canvas ?canvas ?size ~sparse specs
  in
  let open PrintBox in
  let y_label_l =
    List.map Char.escaped @@ List.of_seq @@ String.to_seq y_label
  in
  if no_axes then
    embed_canvas canvas
  else
    grid_l
      [
        [
          hlist ~bars:false
            [
              align ~h:`Left ~v:`Center @@ lines y_label_l;
              vlist ~bars:false
                [
                  line @@ !concise_float ~prec maxy;
                  align_bottom @@ line @@ !concise_float ~prec miny;
                ];
            ];
          embed_canvas canvas;
        ];
        [
          empty;
          vlist ~bars:false
            [
              hlist ~bars:false
                [
                  line @@ !concise_float ~prec minx;
                  align_right @@ line @@ !concise_float ~prec maxx;
                ];
              align ~h:`Center ~v:`Bottom @@ line x_label;
            ];
        ];
      ]

let example = Plot default_config
let scale_size_for_text = ref (0.125, 0.05)

let flatten_text_canvas canvas =
  let outputs =
    B.map_matrix
      (function
        | Some b ->
          (* Fortunately, PrintBox_text does not insert \r by itself. *)
          String.split_on_char '\n' @@ PrintBox_text.to_string b
        | None -> [])
      canvas
  in
  let dimj = Array.length canvas in
  let dimi = Array.length canvas.(0) in
  (* A [None] on the canvas means that the cell is occupied by a cell to the left of it. *)
  let canvas = Array.make_matrix dimj dimi (Some " ") in
  let update ~i ~j line =
    if i >= 0 && i < dimi && j >= 0 && j < dimj then (
      let visible_len =
        min (dimi - i)
          (PrintBox_text.str_display_width line 0 (String.length line))
      in
      if visible_len > 0 then (
        let actual_len = ref @@ String.length line in
        let cur_len () = PrintBox_text.str_display_width line 0 !actual_len in
        while !actual_len > 0 && (cur_len () = 0 || cur_len () > visible_len) do
          decr actual_len
        done;
        canvas.(j).(i) <- Some (String.sub line 0 !actual_len)
      );
      for di = 1 to visible_len - 1 do
        canvas.(j).(i + di) <- None
      done
    )
  in
  (* Traverse in reverse order, so that space-making changes do not get undone. *)
  let _ : int =
    Array.fold_right
      (fun row j ->
        let _ : int =
          Array.fold_right
            (fun lines i ->
              List.iteri (fun dj line -> update ~i ~j:(j + dj) line) lines;
              i - 1)
            row (dimi - 1)
        in
        j - 1)
      outputs (dimj - 1)
  in
  Array.map
    (fun row -> String.concat "" @@ List.filter_map Fun.id @@ Array.to_list row)
    canvas

let text_handler ext ~nested:_ =
  match ext with
  | Plot { specs; x_label; y_label; size = sx, sy; no_axes; prec } ->
    let cx, cy = !scale_size_for_text in
    let size =
      Float.(to_int @@ (cx *. of_int sx), to_int @@ (cy *. of_int sy))
    in
    B.Same_as
      (B.frame
      @@ plot ~prec ~no_axes ~size ~x_label ~y_label ~sparse:false
           (fun canvas ->
             B.lines @@ Array.to_list @@ flatten_text_canvas canvas)
           specs)
  | _ -> B.Unrecognized_extension

let embed_canvas_html ~nested canvas =
  let size_y = Array.length canvas in
  let size_x = Array.length canvas.(0) in
  let cells =
    canvas
    |> Array.mapi (fun y row ->
           row
           |> Array.mapi (fun x cell -> x, cell)
           |> Array.to_list
           |> List.filter_map (fun (x, cell) ->
                  Option.map
                    (fun cell ->
                      let cell =
                        match nested cell with
                        | PrintBox_html.Render_html html -> html
                        | _ ->
                          invalid_arg
                            "PrintBox_ext_plot.embed_canvas_html: unrecognized \
                             rendering backend"
                      in
                      H.div
                        ~a:
                          [
                            H.a_style
                              ("position:absolute;top:" ^ Int.to_string y
                             ^ "px;left:" ^ Int.to_string x ^ "px");
                          ]
                        [ cell ])
                    cell))
  in
  let result =
    Array.to_list cells |> List.concat
    |> H.div
         ~a:
           [
             H.a_style @@ "border:thin dotted;position:relative;width:"
             ^ Int.to_string size_x ^ ";height:" ^ Int.to_string size_y;
           ]
  in
  B.embed_rendering @@ PrintBox_html.Render_html result

let html_handler ext ~nested =
  match ext with
  | Plot { specs; x_label; y_label; size; no_axes; prec } ->
    B.Same_as
      (B.frame
      @@ plot ~prec ~no_axes ~size ~x_label ~y_label ~sparse:true
           (embed_canvas_html ~nested)
           specs)
  | _ -> B.Unrecognized_extension

let () =
  B.register_extension_handler ~backend_name:"text" ~example
    ~handler:text_handler;
  B.register_extension_handler ~backend_name:"md" ~example ~handler:text_handler;
  B.register_extension_handler ~backend_name:"html" ~example
    ~handler:html_handler
