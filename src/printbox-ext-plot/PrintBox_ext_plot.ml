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

let box graph = B.extension ~key:"Plot" (Plot graph)

let plot_canvas ?canvas ?(size : (int * int) option) ?(sparse = false)
    (specs : plot_spec list) =
  (* Unfortunately "x" and "y" of a "matrix" are opposite to how we want them displayed --
     the first dimension (i.e. "x") as the horizontal axis. *)
  let (dimx, dimy, canvas) : int * int * (int * B.t) list array array =
    (* The integer in the cells is the priority number: lower number = more visible. *)
    match canvas, size with
    | None, None -> invalid_arg "PrintBox_utils.plot: provide ~canvas or ~size"
    | None, Some (dimx, dimy) -> dimx, dimy, Array.make_matrix dimy dimx []
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
  let spread ~i ~dmj =
    if sparse then
      i mod 10 = 0 && dmj mod 10 = 0
    else
      true
  in
  let update ~i ~dmj px =
    if i >= 0 && dmj >= 0 && i < dimx && dmj < dimy then
      canvas.(dmj).(i) <- px :: canvas.(dmj).(i)
  in
  let prerender_scatter ~priority points =
    Array.iter
      (fun (p, content) ->
        match scale_2d p with
        | Some (i, j) -> update ~i ~dmj:(dimy - 1 - j) (priority, content)
        | None -> ())
      points
  in
  let prerender_map ~priority callback =
    canvas
    |> Array.iteri (fun dmj ->
           Array.iteri (fun i _ ->
               if spread ~i ~dmj then (
                 let x =
                   Float.(of_int i *. spanx /. of_int (dimx - 1)) +. minx
                 in
                 let y =
                   Float.(of_int (dimy - 1 - dmj) *. spany /. of_int (dimy - 1))
                   +. miny
                 in
                 update ~i ~dmj (priority, callback (x, y))
               )))
  in
  specs
  |> List.iteri (fun priority -> function
       | Scatterplot { points; content } ->
         prerender_scatter ~priority (Array.map (fun p -> p, content) points)
       | Scatterbag { points } -> prerender_scatter ~priority points
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
                    update ~i:(rescale_x i)
                      ~dmj:(dimy - 1 - j)
                      (priority, content)))
       | Boundary_map { callback; content_true; content_false } ->
         prerender_map ~priority (fun point ->
             if callback point then
               content_true
             else
               content_false)
       | Map { callback } -> prerender_map ~priority callback
       | Line_plot_adaptive { callback; cache; content } ->
         canvas.(0)
         |> Array.iteri (fun i _ ->
                if (not sparse) || i mod 5 = 0 then (
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
                         update ~i ~dmj:(dimy - 1 - j) (priority, content))
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

let scale_size_for_text = ref (0.125, 0.05)

let explode s =
  let s_len = String.length s in
  let rec loop pos =
    let char_len = ref 1 in
    let cur_len () = PrintBox_text.str_display_width s pos !char_len in
    while pos + !char_len <= s_len && cur_len () = 0 do
      incr char_len
    done;
    if cur_len () > 0 then
      String.sub s pos !char_len :: loop (pos + !char_len)
    else
      []
  in
  loop 0

let flatten_text_canvas ~num_specs canvas =
  let outputs =
    B.map_matrix
      (fun bs ->
        (* Fortunately, PrintBox_text does not insert \r by itself. *)
        List.map
          (fun (prio, b) ->
            let lines =
              String.split_on_char '\n' @@ PrintBox_text.to_string b
            in
            prio, List.map explode lines)
          bs)
      canvas
  in
  let dimj = Array.length canvas in
  let dimi = Array.length canvas.(0) in
  let canvas = Array.make_matrix dimj dimi (num_specs, " ") in
  let update ~i ~j (prio, box) =
    if i >= 0 && i < dimi && j >= 0 && j < dimj then
      List.iteri
        (fun dj ->
          List.iteri (fun di char ->
              let j' = j + dj and i' = i + di in
              if i' >= 0 && i' < dimi && j' >= 0 && j' < dimj then (
                let old_prio, _ = canvas.(j').(i') in
                if prio <= old_prio then canvas.(j').(i') <- prio, char
              )))
        box
  in
  Array.iteri
    (fun j row ->
      Array.iteri
        (fun i boxes -> List.iter (fun box -> update ~i ~j box) boxes)
        row)
    outputs;
  Array.map
    (fun row -> String.concat "" @@ List.map snd @@ Array.to_list row)
    canvas

let text_based_handler ~render ext =
  match ext with
  | Plot { specs; x_label; y_label; size = sx, sy; no_axes; prec } ->
    let cx, cy = !scale_size_for_text in
    let size =
      Float.(to_int @@ (cx *. of_int sx), to_int @@ (cy *. of_int sy))
    in
    render
      (B.frame
      @@ plot ~prec ~no_axes ~size ~x_label ~y_label ~sparse:false
           (fun canvas ->
             B.lines @@ Array.to_list
             @@ flatten_text_canvas ~num_specs:(List.length specs) canvas)
           specs)
  | _ -> invalid_arg "PrintBox_ext_plot.text_handler: unrecognized extension"

let text_handler = text_based_handler ~render:PrintBox_text.to_string

let md_handler config =
  text_based_handler ~render:(PrintBox_md.to_string config)

let embed_canvas_html ~num_specs canvas =
  let size_y = Array.length canvas in
  let size_x = Array.length canvas.(0) in
  let cells =
    canvas
    |> Array.mapi (fun y row ->
           row
           |> Array.mapi (fun x cell ->
                  List.map
                    (fun (priority, cell) ->
                      let is_framed =
                        match PrintBox.view cell with
                        | B.Frame _ | B.Grid (`Bars, _) -> true
                        | _ -> false
                      in
                      let frame =
                        if is_framed then
                          ";background-color:rgba(255,255,255,1)"
                        else
                          ""
                      in
                      let z_index =
                        ";z-index:" ^ Int.to_string (num_specs - priority)
                      in
                      let cell =
                        PrintBox_html.((to_html cell :> toplevel_html))
                      in
                      H.div
                        ~a:
                          [
                            H.a_style
                              ("position:absolute;top:" ^ Int.to_string y
                             ^ "px;left:" ^ Int.to_string x ^ "px" ^ z_index
                             ^ frame);
                          ]
                        [ cell ])
                    cell)
           |> Array.to_list |> List.concat)
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
  PrintBox_html.embed_html result

let html_handler config ext =
  match ext with
  | Plot { specs; x_label; y_label; size; no_axes; prec } ->
    (PrintBox_html.to_html ~config
       (B.frame
       @@ plot ~prec ~no_axes ~size ~x_label ~y_label ~sparse:true
            (embed_canvas_html ~num_specs:(List.length specs))
            specs)
      :> PrintBox_html.toplevel_html)
  | _ -> invalid_arg "PrintBox_ext_plot.html_handler: unrecognized extension"

let () =
  PrintBox_text.register_extension ~key:"Plot" text_handler;
  PrintBox_md.register_extension ~key:"Plot" md_handler;
  PrintBox_html.register_extension ~key:"Plot" html_handler
