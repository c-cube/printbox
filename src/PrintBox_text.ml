
(* This file is free software. See file "license" for more details. *)

(** {1 Render to Text} *)

module B = PrintBox

type position = PrintBox.position = {
  x:int;
  y:int;
}

let _string_len = ref Bytes.length

let set_string_len f = _string_len := f

let origin = {x=0; y=0;}

let _move pos x y = {x=pos.x + x; y=pos.y + y}
let _add pos1 pos2 = _move pos1 pos2.x pos2.y
let _minus pos1 pos2 = _move pos1 (- pos2.x) (- pos2.y)
let _move_x pos x = _move pos x 0
let _move_y pos y = _move pos 0 y

(** {2 Output: where to print to} *)

module Output = struct
  type t = {
    put_char : position -> char -> unit;
    put_string : position -> string -> unit;
    put_sub_string : position -> string -> int -> int -> unit;
    flush : unit -> unit;
  }

  let put_char out pos c = out.put_char pos c
  let put_string out pos s = out.put_string pos s

  (** An internal buffer, suitable for writing efficiently, then
      convertable into a list of lines *)
  type buffer = {
    mutable buf_lines : buf_line array;
    mutable buf_len : int;
  }
  and buf_line = {
    mutable bl_str : Bytes.t;
    mutable bl_len : int;
  }

  let _make_line _ = {bl_str=Bytes.empty; bl_len=0}

  let _ensure_lines buf i =
    if i >= Array.length buf.buf_lines
    then (
      let lines' = Array.init (2 * i + 5) _make_line in
      Array.blit buf.buf_lines 0 lines' 0 buf.buf_len;
      buf.buf_lines <- lines';
    )

  let _ensure_line line i =
    if i >= !_string_len line.bl_str
    then (
      let str' = Bytes.make (2 * i + 5) ' ' in
      Bytes.blit line.bl_str 0 str' 0 line.bl_len;
      line.bl_str <- str';
    )

  let _buf_put_char buf pos c =
    _ensure_lines buf pos.y;
    _ensure_line buf.buf_lines.(pos.y) pos.x;
    buf.buf_len <- max buf.buf_len (pos.y+1);
    let line = buf.buf_lines.(pos.y) in
    Bytes.set line.bl_str pos.x c;
    line.bl_len <- max line.bl_len (pos.x+1)

  let _buf_put_sub_string buf pos s s_i s_len =
    _ensure_lines buf pos.y;
    _ensure_line buf.buf_lines.(pos.y) (pos.x + s_len);
    buf.buf_len <- max buf.buf_len (pos.y+1);
    let line = buf.buf_lines.(pos.y) in
    String.blit s s_i line.bl_str pos.x s_len;
    line.bl_len <- max line.bl_len (pos.x+s_len)

  let _buf_put_string buf pos s =
    _buf_put_sub_string buf pos s 0 (!_string_len (Bytes.unsafe_of_string s))

  (* create a new buffer *)
  let make_buffer () =
    let buf = {
      buf_lines = Array.init 16 _make_line;
      buf_len = 0;
    } in
    let buf_out = {
      put_char = _buf_put_char buf;
      put_sub_string = _buf_put_sub_string buf;
      put_string = _buf_put_string buf;
      flush = (fun () -> ());
    } in
    buf, buf_out

  let buf_to_lines ?(indent=0) buf =
    let buffer = Buffer.create (5 + buf.buf_len * 32) in
    for i = 0 to buf.buf_len - 1 do
      for _ = 1 to indent do Buffer.add_char buffer ' ' done;
      let line = buf.buf_lines.(i) in
      Buffer.add_substring buffer (Bytes.unsafe_to_string line.bl_str) 0 line.bl_len;
      Buffer.add_char buffer '\n';
    done;
    Buffer.contents buffer

  let buf_output ?(indent=0) oc buf =
    for i = 0 to buf.buf_len - 1 do
      for _ = 1 to indent do output_char oc ' '; done;
      let line = buf.buf_lines.(i) in
      output oc line.bl_str 0 line.bl_len;
      output_char oc '\n';
    done
end

module Box_inner = struct
  type 'a shape =
    | Empty
    | Text of string list  (* list of lines *)
    | Frame of 'a
    | Pad of position * 'a (* vertical and horizontal padding *)
    | Grid of [`Bars | `None] * 'a array array
    | Tree of int * 'a * 'a array

  type t = {
    shape : t shape;
    size : position lazy_t;
  }

  let size box = Lazy.force box.size

  let shape b = b.shape

  let _array_foldi f acc a =
    let acc = ref acc in
    Array.iteri (fun i x -> acc := f !acc i x) a;
    !acc

  (* height of a line composed of boxes *)
  let _height_line a =
    _array_foldi
      (fun h _ box ->
         let s = size box in
         max h s.y
      ) 0 a

  (* how large is the [i]-th column of [m]? *)
  let _width_column m i =
    let acc = ref 0 in
    for j = 0 to Array.length m - 1 do
      acc := max !acc (size m.(j).(i)).x
    done;
    !acc

  (* width and height of a column as an array *)
  let _dim_vertical_array a =
    let w = ref 0 and h = ref 0 in
    Array.iter
      (fun b ->
         let s = size b in
         w := max !w s.x;
         h := !h + s.y
      ) a;
    {x= !w; y= !h;}

  (* from a matrix [m] (line,column), return two arrays [lines] and [columns],
     with [col.(i)] being the start offset of column [i] and
     [lines.(j)] being the start offset of line [j].
     Those arrays have one more slot to indicate the end position.
     @param bars if true, leave space for bars between lines/columns *)
  let _size_matrix ~bars m =
    let dim = PrintBox.dim_matrix m in
    (* +1 is for keeping room for the vertical/horizontal line/column *)
    let additional_space = if bars then 1 else 0 in
    (* columns *)
    let columns = Array.make (dim.x + 1) 0 in
    for i = 0 to dim.x - 1 do
      columns.(i+1) <- columns.(i) + (_width_column m i) + additional_space
    done;
    (* lines *)
    let lines = Array.make (dim.y + 1) 0 in
    for j = 1 to dim.y do
      lines.(j) <- lines.(j-1) + (_height_line m.(j-1)) + additional_space
    done;
    (* no trailing bars, adjust *)
    columns.(dim.x) <- columns.(dim.x) - additional_space;
    lines.(dim.y) <- lines.(dim.y) - additional_space;
    lines, columns

  let size_of_shape = function
    | Empty -> origin
    | Text l ->
      let width = List.fold_left
          (fun acc line -> max acc (!_string_len (Bytes.unsafe_of_string line))) 0 l
      in
      { x=width; y=List.length l; }
    | Frame t ->
      let {x;y} = size t in
      { x=x+2; y=y+2; }
    | Pad (dim, b') ->
      let {x;y} = size b' in
      { x=x+2*dim.x; y=y+2*dim.y; }
    | Grid (style,m) ->
      let bars = match style with
        | `Bars -> true
        | `None -> false
      in
      let dim = B.dim_matrix m in
      let lines, columns = _size_matrix ~bars m in
      { y=lines.(dim.y); x=columns.(dim.x)}
    | Tree (indent, node, children) ->
      let dim_children = _dim_vertical_array children in
      let s = size node in
      { x=max s.x (dim_children.x+3+indent)
      ; y=s.y + dim_children.y
      }

  let rec lines_ s i k = match String.index_from s i '\n' with
    | -1 ->
      if i<String.length s then k (String.sub s i (String.length s-i))
    | j ->
      let s' = String.sub s i (j-i) in
      k s';
      lines_ s (j+1) k

  let rec of_box b =
    let shape = match b with
      | B.Empty -> Empty
      | B.Text s ->
        (* split into lines *)
        let acc = ref [] in
        lines_ s 0 (fun x -> acc := x :: !acc);
        Text (List.rev !acc)
      | B.Frame t -> Frame (of_box t)
      | B.Pad (dim, t) -> Pad (dim, of_box t)
      | B.Grid (bars, m) -> Grid (bars, B.map_matrix of_box m)
      | B.Tree (i, b, l) -> Tree (i, of_box b, Array.map of_box l)
    in
    { shape; size = lazy (size_of_shape shape) }
end

(** {2 Rendering} *)

let _write_vline ~out pos n =
  for j=0 to n-1 do
    Output.put_char out (_move_y pos j) '|'
  done

let _write_hline ~out pos n =
  for i=0 to n-1 do
    Output.put_char out (_move_x pos i) '-'
  done

(* render given box on the output, starting with upper left corner
    at the given position. [expected_size] is the size of the
    available surrounding space. [offset] is the offset of the box
    w.r.t the surrounding box *)
let rec render_rec ?(offset=origin) ?expected_size ~out b pos =
  match Box_inner.shape b with
    | Box_inner.Empty -> ()
    | Box_inner.Text l ->
      List.iteri
        (fun i line ->
           Output.put_string out (_move_y pos i) line
        ) l
    | Box_inner.Frame b' ->
      let {x;y} = Box_inner.size b' in
      Output.put_char out pos '+';
      Output.put_char out (_move pos (x+1) (y+1)) '+';
      Output.put_char out (_move pos 0 (y+1)) '+';
      Output.put_char out (_move pos (x+1) 0) '+';
      _write_hline ~out (_move_x pos 1) x;
      _write_hline ~out (_move pos 1 (y+1)) x;
      _write_vline ~out (_move_y pos 1) y;
      _write_vline ~out (_move pos (x+1) 1) y;
      render_rec ~out b' (_move pos 1 1)
    | Box_inner.Pad (dim, b') ->
      let expected_size = Box_inner.size b in
      render_rec ~offset:(_add dim offset) ~expected_size ~out b' (_add pos dim)
    | Box_inner.Grid (style,m) ->
      let dim = B.dim_matrix m in
      let bars = match style with
        | `None -> false
        | `Bars -> true
      in
      let lines, columns = Box_inner._size_matrix ~bars m in

      (* write boxes *)
      for j = 0 to dim.y - 1 do
        for i = 0 to dim.x - 1 do
          let expected_size = {
            x=columns.(i+1)-columns.(i);
            y=lines.(j+1)-lines.(j);
          } in
          let pos' = _move pos (columns.(i)) (lines.(j)) in
          render_rec ~expected_size ~out m.(j).(i) pos'
        done;
      done;

      let len_hlines, len_vlines = match expected_size with
        | None -> columns.(dim.x), lines.(dim.y)
        | Some {x;y} -> x,y
      in

      (* write frame if needed *)
      begin match style with
        | `None -> ()
        | `Bars ->
          for j=1 to dim.y - 1 do
            _write_hline ~out (_move pos (-offset.x) (lines.(j)-1)) len_hlines
          done;
          for i=1 to dim.x - 1 do
            _write_vline ~out (_move pos (columns.(i)-1) (-offset.y)) len_vlines
          done;
          for j=1 to dim.y - 1 do
            for i=1 to dim.x - 1 do
              Output.put_char out (_move pos (columns.(i)-1) (lines.(j)-1)) '+'
            done
          done
      end
    | Box_inner.Tree (indent, n, a) ->
      render_rec ~out n pos;
      (* star position for the children *)
      let pos' = _move pos indent (Box_inner.size n).y in
      Output.put_char out (_move_x pos' ~-1) '`';
      assert (Array.length a > 0);
      let _ = Box_inner._array_foldi
          (fun pos' i b ->
             Output.put_string out pos' "+- ";
             if i<Array.length a-1
             then (
               _write_vline ~out (_move_y pos' 1) ((Box_inner.size b).y-1)
             );
             render_rec ~out b (_move_x pos' 2);
             _move_y pos' (Box_inner.size b).y
          ) pos' a
      in
      ()

let render out b =
  render_rec ~out b origin

let to_string b =
  let buf, out = Output.make_buffer () in
  render out (Box_inner.of_box b);
  Output.buf_to_lines buf

let output ?(indent=0) oc b =
  let buf, out = Output.make_buffer () in
  render out (Box_inner.of_box b);
  Output.buf_output ~indent oc buf;
  flush oc
