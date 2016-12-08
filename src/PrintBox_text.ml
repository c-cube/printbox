
(* This file is free software. See file "license" for more details. *)

(** {1 Render to Text} *)

module B = PrintBox

type position = PrintBox.position = {
  x:int;
  y:int;
}

let _cmp pos1 pos2 =
  match Pervasives.compare pos1.y pos2.y with
  | 0 -> Pervasives.compare pos1.x pos2.x
  | x -> x

let origin = {x=0; y=0;}

let _move pos x y = {x=pos.x + x; y=pos.y + y}
let _add pos1 pos2 = _move pos1 pos2.x pos2.y
let _minus pos1 pos2 = _move pos1 (- pos2.x) (- pos2.y)
let _move_x pos x = _move pos x 0
let _move_y pos y = _move pos 0 y

module M = Map.Make(struct
    type t = position
    let compare = _cmp
  end)

(* String length *)

let _string_len = ref Bytes.length

let set_string_len f = _string_len := f

(** {2 Output: where to print to} *)

module Output = struct
  type t = {
    put_char : position -> char -> unit;
    put_string : position -> string -> unit;
    flush : unit -> unit;
  }

  let put_char out pos c = out.put_char pos c
  let put_string out pos s = out.put_string pos s

  (** Internal multi-line buffer suitable for unicode strings.
      It is a map from start position to a printable entity (string or character)
      All printable sequences are supposed to *NOT* introduce new lines *)
  type printable =
    | Char of char
    | String of string

  (* Note: we trust the user not to mess things up relating to
     strings overlapping because of bad positions *)
  let _buf_put_char buf pos c =
    buf := M.add pos (Char c) !buf

  let _buf_put_string buf pos s =
    buf := M.add pos (String s) !buf

  let make_buffer () =
    let buf = ref M.empty in
    let buf_out = {
      put_char = _buf_put_char buf;
      put_string = _buf_put_string buf;
      flush = (fun () -> ());
    } in
    buf, buf_out

  let goto ?(indent=0) buf start dest =
    (** Go to the line before the one we want *)
    for _ = start.y to dest.y - 2 do
      Buffer.add_char buf '\n'
    done;
    (** Emit the last line and indent it *)
    if start.y < dest.y then begin
      Buffer.add_char buf '\n';
      for _ = 1 to indent do
        Buffer.add_char buf ' '
      done
    end;
    (** Now that we are on the correct line, go the right column. *)
    let x_start = if start.y < dest.y then 0 else start.x in
    for _ = x_start to dest.x - 1 do
      Buffer.add_char buf ' '
    done

  let buf_out_aux ?(indent=0) buf start_pos p curr_pos =
    assert (_cmp curr_pos start_pos <= 0);
    (* Go up to the expected location *)
    goto ~indent buf curr_pos start_pos;
    (* Print the interesting part *)
    match p with
    | Char c ->
      Buffer.add_char buf c;
      _move_x start_pos 1
    | String s ->
      Buffer.add_string buf s;
      (* We could use Bytes.unsafe_of_string as long as !string_len
         does not try to mutate the string (which it should have no
         reason to do), but just to be safe... *)
      let l = !_string_len (Bytes.of_string s) in
      _move_x start_pos l

  let buf_out ?(indent=0) buf b =
    for _ = 1 to indent do Buffer.add_char buf ' ' done;
    let _pos = M.fold (buf_out_aux ~indent buf) !b origin in ()

  let buf_to_lines ?indent b =
    let buf = Buffer.create 42 in
    buf_out ?indent buf b;
    Buffer.contents buf

  let buf_output ?indent oc b =
    let buf = Buffer.create 42 in
    buf_out ?indent buf b;
    Buffer.output_buffer oc buf

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
          (fun acc line ->
             max acc (!_string_len (Bytes.unsafe_of_string line)))
          0 l
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

  let str_idx s i c =
    try Some (String.index_from s i c)
    with Not_found -> None

  let rec lines_ s i k = match str_idx s i '\n' with
    | None ->
      if i<String.length s then k (String.sub s i (String.length s-i))
    | Some j ->
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
      (* start position for the children *)
      let pos' = _move pos indent (Box_inner.size n).y in
      Output.put_char out (_move_x pos' ~-1) '`';
      assert (Array.length a > 0);
      let _ = Box_inner._array_foldi
          (fun pos' i b ->
             let s = "+- " in
             let n = String.length s in
             Output.put_string out pos' s;
             if i<Array.length a-1 then (
               _write_vline ~out (_move_y pos' 1) ((Box_inner.size b).y-1)
             );
             render_rec ~out b (_move_x pos' n);
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

