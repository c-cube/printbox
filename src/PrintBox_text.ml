
(* This file is free software. See file "license" for more details. *)

(** {1 Render to Text} *)

module B = PrintBox

type position = PrintBox.position = {
  x:int;
  y:int;
}

module Pos = struct
  type t = position

  let[@inline] compare pos1 pos2 =
    match Pervasives.compare pos1.y pos2.y with
    | 0 -> Pervasives.compare pos1.x pos2.x
    | x -> x

  let origin = {x=0; y=0;}

  let[@inline] move pos x y = {x=pos.x + x; y=pos.y + y}
  let[@inline] (+) pos1 pos2 = move pos1 pos2.x pos2.y
  let[@inline] move_x pos x = move pos x 0
  let[@inline] move_y pos y = move pos 0 y
end

module M = Map.Make(Pos)

(* String length *)

let str_len_ = ref (fun _ _ len -> len)

let set_string_len f = str_len_ := f

(** {2 Output: where to print to} *)

module Output : sig
  type t
  val create : unit -> t
  val put_char : t -> position -> char -> unit
  val put_string : t -> position -> string -> unit
  val put_sub_string : t -> position -> string -> int -> int -> unit
  val to_string : ?indent:int -> t -> string
  val to_chan : ?indent:int -> out_channel -> t -> unit
  val pp : Format.formatter -> t -> unit
end = struct
  (** Internal multi-line buffer suitable for unicode strings.
      It is a map from start position to a printable entity (string or character)
      All printable sequences are supposed to *NOT* introduce new lines *)
  type printable =
    | Char of char
    | String of string
    | Str_slice of string * int * int

  type t = {
    mutable m: printable M.t;
  }

  (* Note: we trust the user not to mess things up relating to
     strings overlapping because of bad positions *)
  let[@inline] put_char (self:t) pos c =
    self.m <- M.add pos (Char c) self.m

  let[@inline] put_string (self:t) pos s =
    self.m <- M.add pos (String s) self.m

  let[@inline] put_sub_string (self:t) pos s i len =
    self.m <- M.add pos (Str_slice (s,i,len)) self.m

  let create () : t = {m=M.empty}

  module type OUT = sig
    type t
    val output_char : t -> char -> unit
    val output_string : t -> string -> unit
    val output_substring : t -> string -> int -> int -> unit
    val newline : t -> unit
  end

  module Make_out(O : OUT) : sig
    val render : ?indent:int -> O.t -> t -> unit
  end = struct
    let goto ?(indent=0) (out:O.t) start dest =
      (* Go to the line before the one we want *)
      for _i = start.y to dest.y - 2 do
        O.newline out;
      done;
      (* Emit the last line and indent it *)
      if start.y < dest.y then (
        O.newline out;
        for _i = 1 to indent do
          O.output_char out ' ';
        done
      );
      (* Now that we are on the correct line, go the right column. *)
      let x_start = if start.y < dest.y then 0 else start.x in
      for _i = x_start to dest.x - 1 do
        O.output_char out ' '
      done

    let to_buf_aux_ ?(indent=0) (out:O.t) start_pos p curr_pos =
      assert (Pos.compare curr_pos start_pos <= 0);
      (* Go up to the expected location *)
      goto ~indent out curr_pos start_pos;
      (* Print the interesting part *)
      match p with
      | Char c ->
        O.output_char out c;
        Pos.move_x start_pos 1
      | String s ->
        O.output_string out s;
        (* We could use Bytes.unsafe_of_string as long as !string_len
           does not try to mutate the string (which it should have no
           reason to do), but just to be safe... *)
        let l = !str_len_ s 0 (String.length s) in
        Pos.move_x start_pos l
      | Str_slice (s, i, len) ->
        O.output_substring out s i len;
        (* We could use Bytes.unsafe_of_string as long as !string_len
           does not try to mutate the string (which it should have no
           reason to do), but just to be safe... *)
        let l = !str_len_ s i len in
        Pos.move_x start_pos l

    let render ?(indent=0) (out:O.t) (self:t) : unit =
      for _i = 1 to indent do O.output_char out ' ' done;
      ignore (M.fold (to_buf_aux_ ~indent out) self.m Pos.origin : position);
      ()
  end

  module Out_buf = Make_out(struct
    type t = Buffer.t
    let output_char = Buffer.add_char
    let output_string = Buffer.add_string
    let output_substring = Buffer.add_substring
    let newline b = Buffer.add_char b '\n'
  end)

  let to_string ?indent self : string =
    let buf = Buffer.create 42 in
    Out_buf.render ?indent buf self;
    Buffer.contents buf

  module Out_chan = Make_out(struct
    type t = out_channel
    let output_char = output_char
    let output_string = output_string
    let output_substring = output_substring
    let newline oc = output_char oc '\n'
  end)

  let to_chan ?indent oc self : unit =
    Out_chan.render ?indent oc self

  module Out_format = Make_out(struct
    type t = Format.formatter
    let output_char = Format.pp_print_char
    let output_string = Format.pp_print_string
    let output_substring out s i len =
      let s = if i=0 && len=String.length s then s else String.sub s i len in
      Format.pp_print_string out s
    let newline out = Format.pp_print_cut out ()
  end)

  let pp out (self:t) : unit =
    Format.fprintf out "@[<v>%a@]" (Out_format.render ~indent:0) self
end

module Box_inner = struct
  type 'a shape =
    | Empty
    | Text of (string * int * int) list  (* list of lines *)
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
    | Empty -> Pos.origin
    | Text l ->
      let width =
        List.fold_left
          (fun acc (s,i,len) -> max acc (!str_len_ s i len))
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

  let[@unroll 2] rec lines_ s i (k: string -> int -> int -> unit) : unit =
    match str_idx s i '\n' with
    | None ->
      if i<String.length s then (
        k s i (String.length s-i)
      )
    | Some j ->
      k s i (j-i);
      lines_ s (j+1) k

  let lines_l_ l k = match l with
    | [] -> ()
    | [s] -> lines_ s 0 k
    | s1::s2::tl ->
      lines_ s1 0 k;
      lines_ s2 0 k;
      List.iter (fun s -> lines_ s 0 k) tl

  let rec of_box (b:B.t) : t =
    let shape =
      match B.view b with
      | B.Empty -> Empty
      | B.Text l ->
        (* split into lines *)
        let acc = ref [] in
        lines_l_ l (fun s i len -> acc := (s,i,len) :: !acc);
        Text (List.rev !acc)
      | B.Frame t -> Frame (of_box t)
      | B.Pad (dim, t) -> Pad (dim, of_box t)
      | B.Grid (bars, m) -> Grid (bars, B.map_matrix of_box m)
      | B.Tree (i, b, l) -> Tree (i, of_box b, Array.map of_box l)
    in
    { shape; size = lazy (size_of_shape shape) }

  (** {3 Rendering} *)

  let write_vline_ ~out pos n =
    for j=0 to n-1 do
      Output.put_char out (Pos.move_y pos j) '|'
    done

  let write_hline_ ~out pos n =
    for i=0 to n-1 do
      Output.put_char out (Pos.move_x pos i) '-'
    done

  (* render given box on the output, starting with upper left corner
      at the given position. [expected_size] is the size of the
      available surrounding space. [offset] is the offset of the box
      w.r.t the surrounding box *)
  let rec render_rec ?(offset=Pos.origin) ?expected_size ~out b pos =
    match shape b with
    | Empty -> ()
    | Text l ->
      List.iteri
        (fun line_idx (s,s_i,len)->
           Output.put_sub_string out (Pos.move_y pos line_idx) s s_i len)
        l
    | Frame b' ->
      let {x;y} = size b' in
      Output.put_char out pos '+';
      Output.put_char out (Pos.move pos (x+1) (y+1)) '+';
      Output.put_char out (Pos.move pos 0 (y+1)) '+';
      Output.put_char out (Pos.move pos (x+1) 0) '+';
      write_hline_ ~out (Pos.move_x pos 1) x;
      write_hline_ ~out (Pos.move pos 1 (y+1)) x;
      write_vline_ ~out (Pos.move_y pos 1) y;
      write_vline_ ~out (Pos.move pos (x+1) 1) y;
      render_rec ~out b' (Pos.move pos 1 1)
    | Pad (dim, b') ->
      let expected_size = size b in
      render_rec ~offset:Pos.(dim + offset) ~expected_size ~out b' Pos.(pos + dim)
    | Grid (style,m) ->
      let dim = B.dim_matrix m in
      let bars = match style with
        | `None -> false
        | `Bars -> true
      in
      let lines, columns = _size_matrix ~bars m in

      (* write boxes *)
      for j = 0 to dim.y - 1 do
        for i = 0 to dim.x - 1 do
          let expected_size = {
            x=columns.(i+1)-columns.(i);
            y=lines.(j+1)-lines.(j);
          } in
          let pos' = Pos.move pos (columns.(i)) (lines.(j)) in
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
            write_hline_ ~out (Pos.move pos (-offset.x) (lines.(j)-1)) len_hlines
          done;
          for i=1 to dim.x - 1 do
            write_vline_ ~out (Pos.move pos (columns.(i)-1) (-offset.y)) len_vlines
          done;
          for j=1 to dim.y - 1 do
            for i=1 to dim.x - 1 do
              Output.put_char out (Pos.move pos (columns.(i)-1) (lines.(j)-1)) '+'
            done
          done
      end
    | Tree (indent, n, a) ->
      render_rec ~out n pos;
      (* start position for the children *)
      let pos' = Pos.move pos indent (size n).y in
      Output.put_char out (Pos.move_x pos' ~-1) '`';
      assert (Array.length a > 0);
      let _ = _array_foldi
          (fun pos' i b ->
             let s = "+- " in
             let n = String.length s in
             Output.put_string out pos' s;
             if i<Array.length a-1 then (
               write_vline_ ~out (Pos.move_y pos' 1) ((size b).y-1)
             );
             render_rec ~out b (Pos.move_x pos' n);
             Pos.move_y pos' (size b).y
          ) pos' a
      in
      ()

  let render out b = render_rec ~out b Pos.origin
end

let to_string b =
  let buf = Output.create() in
  Box_inner.render buf (Box_inner.of_box b);
  Output.to_string buf

let output ?(indent=0) oc b =
  let buf = Output.create () in
  Box_inner.render buf (Box_inner.of_box b);
  Output.to_chan ~indent oc buf;
  flush oc

let pp out b =
  let buf = Output.create () in
  Box_inner.render buf (Box_inner.of_box b);
  Output.pp out buf

