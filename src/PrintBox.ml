
(* This file is free software. See file "license" for more details. *)

(** {1 Pretty-Printing of Boxes} *)

type position = { x:int ; y: int }

type view =
  | Empty
  | Text of string list
  | Frame of t
  | Pad of position * t (* vertical and horizontal padding *)
  | Align_right of t (* dynamic left-padding *)
  | Grid of [`Bars | `None] * t array array
  | Tree of int * t * t array

and t = view

let empty = Empty
let[@inline] view (t:t) : view = t

let[@inline] line_ s = Text [s]

let line s =
  if String.contains s '\n' then invalid_arg "PrintBox.line";
  line_ s

let text s = Text [s]

let sprintf format =
  let buffer = Buffer.create 64 in
  Printf.kbprintf
    (fun _ -> Text [Buffer.contents buffer])
    buffer
    format

let asprintf format =
  Format.kasprintf (fun s -> Text [s]) format

let[@inline] lines l = Text l

let int x = line_ (string_of_int x)
let float x = line_ (string_of_float x)
let bool x = line_ (string_of_bool x)

let int_ = int
let float_ = float
let bool_ = bool

let[@inline] frame b = Frame b

let pad' ~col ~lines b =
  assert (col >=0 || lines >= 0);
  if col=0 && lines=0
  then b
  else Pad ({x=col;y=lines}, b)

let pad b = pad' ~col:1 ~lines:1 b

let hpad col b = pad' ~col ~lines:0 b
let vpad lines b = pad' ~col:0 ~lines b

let align_right b = Align_right b

let map_matrix f m =
  Array.map (Array.map f) m

let grid ?(pad=fun b->b) ?(bars=true) m =
  let m = map_matrix pad m in
  Grid ((if bars then `Bars else `None), m)

let init_grid ?bars ~line ~col f =
  let m = Array.init line (fun j-> Array.init col (fun i -> f ~line:j ~col:i)) in
  grid ?bars m

let vlist ?pad ?bars l =
  let a = Array.of_list l in
  grid ?pad ?bars (Array.map (fun line -> [| line |]) a)

let hlist ?pad ?bars l =
  grid ?pad ?bars [| Array.of_list l |]

let hlist_map ?bars f l = hlist ?bars (List.map f l)
let vlist_map ?bars f l = vlist ?bars (List.map f l)
let grid_map ?bars f m = grid ?bars (Array.map (Array.map f) m)

let grid_text ?(pad=fun x->x) ?bars m =
  grid_map ?bars (fun x -> pad (text x)) m

let dim_matrix m =
  if Array.length m = 0 then {x=0;y=0}
  else {y=Array.length m; x=Array.length m.(0); }

let transpose m =
  let dim = dim_matrix m in
  Array.init dim.x
    (fun i -> Array.init dim.y (fun j -> m.(j).(i)))

let tree ?(indent=1) node children =
  if indent <= 0 then invalid_arg "tree: need strictly positive indent";
  let children =
    List.filter
      (function
        | Empty -> false
        | _ -> true)
      children
  in
  match children with
  | [] -> node
  | _::_ ->
    let children = Array.of_list children in
    Tree (indent, node, children)

let mk_tree ?indent f root =
  let rec make x = match f x with
    | b, [] -> b
    | b, children -> tree ?indent b (List.map make children)
  in
  make root

(** {2 Simple Structural Interface} *)

type 'a ktree = unit -> [`Nil | `Node of 'a * 'a ktree list]
type box = t

module Simple = struct
  type t =
    [ `Empty
    | `Pad of t
    | `Align_right of t
    | `Text of string
    | `Vlist of t list
    | `Hlist of t list
    | `Table of t array array
    | `Tree of t * t list
    ]

  let rec to_box = function
    | `Empty -> empty
    | `Pad b -> pad (to_box b)
    | `Align_right b -> align_right (to_box b)
    | `Text t -> text t
    | `Vlist l -> vlist (List.map to_box l)
    | `Hlist l -> hlist (List.map to_box l)
    | `Table a -> grid (map_matrix to_box a)
    | `Tree (b,l) -> tree (to_box b) (List.map to_box l)

  let rec of_ktree t = match t () with
    | `Nil -> `Empty
    | `Node (x, l) -> `Tree (x, List.map of_ktree l)

  let rec map_ktree f t = match t () with
    | `Nil -> `Empty
    | `Node (x, l) -> `Tree (f x, List.map (map_ktree f) l)

  let sprintf format =
    let buffer = Buffer.create 64 in
    Printf.kbprintf
      (fun _ -> `Text (Buffer.contents buffer))
      buffer
      format

  let asprintf format =
    Format.kasprintf (fun s -> `Text s) format
end
