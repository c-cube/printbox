(* This file is free software. See file "license" for more details. *)

(** {1 Render to Text} *)

module B = PrintBox

type position = PrintBox.position = {
  x:int;
  y:int;
}

module Style_ansi : sig
  val brackets : B.Style.t -> string * string
end = struct
  open B.Style

  let int_of_color_ = function
    | Black -> 0
    | Red -> 1
    | Green -> 2
    | Yellow -> 3
    | Blue -> 4
    | Magenta -> 5
    | Cyan -> 6
    | White -> 7

  let codes_of_style (self:t) : int list =
    let {bold;fg_color;bg_color} = self in
    (if bold then [1] else []) @
    (match bg_color with None -> [] | Some c -> [40 + int_of_color_ c]) @
    (match fg_color with None -> [] | Some c -> [30 + int_of_color_ c])

  let ansi_l_to_str_ = function
    | [] -> "", ""
    | [a] -> Printf.sprintf "\x1b[%dm" a, "\x1b[0m"
    | [a;b] -> Printf.sprintf "\x1b[%d;%dm" a b, "\x1b[0m"
    | l ->
      let buf = Buffer.create 16 in
      let pp_num c = Buffer.add_string buf (string_of_int c) in
      Buffer.add_string buf "\x1b[";
      List.iteri
        (fun i c ->
           if i>0 then Buffer.add_char buf ';';
           pp_num c)
        l;
      Buffer.add_string buf "m";
      Buffer.contents buf, "\x1b[0m"

  let brackets s = ansi_l_to_str_ (codes_of_style s)
end

module Pos = struct
  type t = position

  let[@inline] compare pos1 pos2 =
    match compare pos1.y pos2.y with
    | 0 -> compare pos1.x pos2.x
    | x -> x

  let origin = {x=0; y=0;}

  let[@inline] move pos x y = {x=pos.x + x; y=pos.y + y}
  let[@inline] (+) pos1 pos2 = move pos1 pos2.x pos2.y
  let[@inline] (-) pos1 pos2 = move pos1 (-pos2.x) (-pos2.y)
  let[@inline] ( * ) n pos =  {x = n*pos.x; y=n*pos.y}
  let[@inline] move_x pos x = move pos x 0
  let[@inline] move_y pos y = move pos 0 y
end

module M = Map.Make(Pos)

(* String length *)

let str_display_len_ = ref (fun s i len ->
    Uutf.String.fold_utf_8 ~pos:i ~len:len
      (fun n _ c -> match c with
         | `Malformed _ -> 0
         | `Uchar c -> n + max 0 (Uucp.Break.tty_width_hint c))
      0 s)

let[@inline] set_string_len f = str_display_len_ := f
let[@inline] str_display_width_ s i len : int = !str_display_len_ s i len

(** {2 Output: where to print to} *)

module Output : sig
  type t
  val create : unit -> t
  (* val put_char : t -> position -> char -> unit *)
  val put_string : t -> position -> string -> unit
  val put_sub_string : t -> position -> string -> int -> int -> unit
  val put_sub_string_brack :
    t -> position -> pre:string -> string -> int -> int -> post:string -> unit
  val to_string : ?indent:int -> t -> string
  val to_chan : ?indent:int -> out_channel -> t -> unit
  val pp : Format.formatter -> t -> unit
end = struct
  (** Internal multi-line buffer suitable for unicode strings.
      It is a map from start position to a printable entity (string or character)
      All printable sequences are supposed to *NOT* introduce new lines *)
  type printable =
    (* | Char of char *)
    | String of string
    | Str_slice of {s: string;i: int;len: int}
    | Str_slice_bracket of {
        pre: string; (* prefix *)
        s: string;
        i: int;
        len: int;
        post: string; (* suffix *)
      }

  type t = {
    mutable m: printable M.t;
  }

  (* Note: we trust the user not to mess things up relating to
     strings overlapping because of bad positions *)
  (* let[@inline] put_char (self:t) pos c =
     self.m <- M.add pos (Char c) self.m *)

  let[@inline] put_string (self:t) pos s =
    self.m <- M.add pos (String s) self.m

  let[@inline] put_sub_string (self:t) pos s i len =
    self.m <- M.add pos (Str_slice {s;i;len}) self.m

  let[@inline] put_sub_string_brack (self:t) pos ~pre s i len ~post =
    self.m <- M.add pos (Str_slice_bracket {pre;s;i;len;post}) self.m

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

    (*
    let _pp_elem = function
      | Char c -> Printf.sprintf "'%c'" c
      | String s -> Printf.sprintf "%S" s
      | Str_slice (s,i,len) -> Printf.sprintf "%S[%d,%d]" s i len
    *)

    let to_buf_aux_ ?(indent=0) (out:O.t) start_pos p curr_pos =
      assert (Pos.compare curr_pos start_pos <= 0);
      (* Go up to the expected location *)
      goto ~indent out curr_pos start_pos;
      (* Print the interesting part *)
      match p with
      (* | Char c ->
         O.output_char out c;
         Pos.move_x start_pos 1 *)
      | String s ->
        O.output_string out s;
        let l = !str_display_len_ s 0 (String.length s) in
        Pos.move_x start_pos l
      | Str_slice {s; i; len} ->
        O.output_substring out s i len;
        let l = str_display_width_ s i len in
        Pos.move_x start_pos l
      | Str_slice_bracket {pre; s; i; len; post} ->
        O.output_string out pre;
        O.output_substring out s i len;
        (* We could use Bytes.unsafe_of_string as long as !string_len
           does not try to mutate the string (which it should have no
           reason to do), but just to be safe... *)
        O.output_string out post;
        let l = str_display_width_ s i len in
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

module Box_inner : sig
  type t
  val of_box : B.box -> t
  val render : ansi:bool -> Output.t -> t -> unit
end = struct
  type 'a shape =
    | Empty
    | Text of {
        l: (string * int * int) list; (* list of lines *)
        style: B.Style.t;
      }
    | Frame of 'a
    | Pad of position * 'a (* vertical and horizontal padding *)
    | Align of {
        h: [`Left | `Center | `Right];
        v: [`Top | `Center | `Bottom];
        inner: 'a (* dynamic centering/alignment *)
      }
    | Grid of [`Bars | `None] * 'a array array
    | Tree of int * 'a * 'a array

  type t = {
    shape : t shape;
    size : position lazy_t;
  }

  type display_conn_basic = {
    mutable left: bool;
    mutable right: bool;
    mutable top: bool;
    mutable bottom: bool;
  }

  type display_connections = {
    mutable nontree: display_conn_basic;
    mutable tree: display_conn_basic;
  }

  let init_connection () = {
    nontree = {
      left = false;
      right = false;
      top = false;
      bottom = false
    };
    tree = {
      left = false;
      right = false;
      top = false;
      bottom = false
    }
  }

  let update_conn ?left ?right ?top ?bottom con_type =
    (match left with
     | None -> ()
     | Some _ -> con_type.left <- true);
    (match right with
     | None -> ();
     | Some _ -> con_type.right <- true);
    (match top with
     | None -> ();
     | Some _ -> con_type.top <- true);
    (match bottom with
     | None -> ();
     | Some _ -> con_type.bottom <- true)

  let disp_conn ct conn =
    let conn_basic =
      match ct with
      | `Nontree -> conn.nontree
      | `Tree -> conn.tree
    in
    match conn_basic.left, conn_basic.right, conn_basic.top, conn_basic.bottom with
    | false, false, false, false -> false
    | true, false, false, false -> false
    | false, true, false, false -> false
    | false, false, true, false -> false
    | false, false, false, true -> false
    | _, _, _, _ -> true

  let disp_conn_char conn =
    match conn.left, conn.right, conn.top, conn.bottom with
    | false, false, false, false -> ""
    | true, false, false, false -> ""
    | false, true, false, false -> ""
    | false, false, true, false -> ""
    | false, false, false, true -> ""
    | true, true, false, false -> "─"
    | true, false, true, false -> "┘"
    | true, false, false, true -> "┐"
    | false, true, true, false -> "└"
    | false, true, false, true -> "┌"
    | false, false, true, true -> "│"
    | true, true, true, false -> "┴"
    | true, true, false, true -> "┬"
    | true, false, true, true -> "┤"
    | false, true, true, true -> "├"
    | true, true, true, true -> "┼"

  type test = {
    mutable m: display_connections M.t
  }

  let create_or_update ?(ct=`Nontree) ?left ?right ?top ?bottom pos disp_map =
    let (new_el, tmp_disp_map) = match M.find_opt pos disp_map with
      | None -> (init_connection (), disp_map)
      | Some el -> (el, M.remove pos disp_map)
    in
    (match ct with
     | `Nontree -> update_conn ?left ?right ?top ?bottom new_el.nontree
     | `Tree -> update_conn ?left ?right ?top ?bottom new_el.tree);
    M.add pos new_el tmp_disp_map

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
    for j = 0 to dim.y-1 do
      lines.(j+1) <- lines.(j) + (_height_line m.(j)) + additional_space
    done;
    (* no trailing bars, adjust *)
    columns.(dim.x) <- columns.(dim.x) - additional_space;
    lines.(dim.y) <- lines.(dim.y) - additional_space;
    lines, columns, additional_space

  let size_of_shape = function
    | Empty -> Pos.origin
    | Text {l;style=_} ->
      let width =
        List.fold_left
          (fun acc (s,i,len) -> max acc (str_display_width_ s i len))
          0 l
      in
      { x=width; y=List.length l; }
    | Frame t -> Pos.move (size t) 2 2
    | Pad (dim, b') ->
      Pos.(size b' + (2 * dim))
    | Align {inner=b';_} -> size b'
    | Grid (style,m) ->
      let bars = match style with
        | `Bars -> true
        | `None -> false
      in
      let dim = B.dim_matrix m in
      let lines, columns, _space_for_bars = _size_matrix ~bars m in
      { y=lines.(dim.y); x=columns.(dim.x)}
    | Tree (indent, node, children) ->
      let dim_children = _dim_vertical_array children in
      let s = size node in
      { x=max s.x (dim_children.x+3+indent)
      ; y=s.y + dim_children.y
      }

  let[@unroll 2] rec lines_ s i (k: string -> int -> int -> unit) : unit =
    match String.index_from s i '\n' with
    | j ->
      k s i (j - i);
      lines_ s (j+1) k
    | exception Not_found ->
      if i < String.length s then (
        k s i (String.length s - i)
      )

  let lines_l_ l k =
    match l with
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
      | B.Text {l;style} ->
        (* split into lines *)
        let acc = ref [] in
        lines_l_ l (fun s i len -> acc := (s,i,len) :: !acc);
        Text {l=List.rev !acc; style}
      | B.Frame t -> Frame (of_box t)
      | B.Pad (dim, t) -> Pad (dim, of_box t)
      | B.Align {h;v;inner} -> Align {h;v;inner=of_box inner}
      | B.Grid (bars, m) -> Grid (bars, B.map_matrix of_box m)
      | B.Tree (i, b, l) -> Tree (i, of_box b, Array.map of_box l)
      | B.Link {inner;uri} ->
        (* just encode as a record *)
        let self =
          of_box (B.v_record ["uri", B.text uri; "inner", inner])
        in
        self.shape
    in
    { shape; size = lazy (size_of_shape shape) }

  (** {3 Rendering} *)

  let write_vline_ ?ct conn_map pos n =
    conn_map.m <- create_or_update ?ct ~bottom:true (Pos.move_y pos ~-1) conn_map.m;
    for j=0 to n-1 do
      conn_map.m <- create_or_update ?ct ~top:true ~bottom:true (Pos.move_y pos j) conn_map.m;
    done;
    conn_map.m <- create_or_update ?ct ~top:true (Pos.move_y pos n) conn_map.m

  let write_hline_ ?ct conn_map pos n =
    conn_map.m <-  create_or_update ?ct ~right:true (Pos.move_x pos ~-1) conn_map.m;
    for i=0 to n-1 do
      conn_map.m <- create_or_update ?ct ~left:true ~right:true (Pos.move_x pos i) conn_map.m;
    done;
    conn_map.m <- create_or_update ?ct ~left:true (Pos.move_x pos n) conn_map.m

  (* render given box on the output, starting with upper left corner
      at the given position. [expected_size] is the size of the
      available surrounding space. [offset] is the offset of the box
      w.r.t the surrounding box *)
  let pre_render ~ansi ?(offset=Pos.origin) ?expected_size ~out b pos =
    let conn_m : test = {m=M.empty} in
    let rec render_rec ~ansi ?(offset=offset) ?expected_size b pos =
      match shape b with
      | Empty -> conn_m.m
      | Text {l;style} ->
        let ansi_prelude, ansi_suffix =
          if ansi then Style_ansi.brackets style else "", "" in
        let has_style = ansi_prelude <> "" || ansi_suffix <> "" in
        List.iteri
          (fun line_idx (s,s_i,len)->
             if has_style then (
               Output.put_sub_string_brack out (Pos.move_y pos line_idx)
                 ~pre:ansi_prelude s s_i len ~post:ansi_suffix
             ) else (
               Output.put_sub_string out (Pos.move_y pos line_idx) s s_i len
             ))
          l;
        conn_m.m
      | Frame b' ->
        let {x;y} = size b' in
        conn_m.m <- create_or_update ~right:true ~bottom:true pos conn_m.m;
        conn_m.m <- create_or_update ~left:true ~top:true (Pos.move pos (x+1) (y+1)) conn_m.m;
        conn_m.m <- create_or_update ~top:true ~right:true (Pos.move pos 0 (y+1)) conn_m.m;
        conn_m.m <- create_or_update ~left:true ~bottom:true (Pos.move pos (x+1) 0) conn_m.m;
        write_hline_ conn_m (Pos.move_x pos 1) x;
        write_hline_ conn_m (Pos.move pos 1 (y+1)) x;
        write_vline_ conn_m (Pos.move_y pos 1) y;
        write_vline_ conn_m (Pos.move pos (x+1) 1) y;
        let expected_size = match expected_size with
          | Some p -> Some (Pos.move p (-2) (-2)) (* remove space for bars *)
          | None -> None
        in
        render_rec ~ansi ?expected_size b' (Pos.move pos 1 1)
      | Pad (dim, b') ->
        let expected_size = match expected_size with
          | None -> None
          | Some p -> Some Pos.(p - (2*dim))
        in
        render_rec ~offset:Pos.(offset+dim) ~ansi ?expected_size b' Pos.(pos + dim)
      | Align {h;v;inner=b'} ->
        begin match expected_size with
          | Some expected_size ->
            (* add padding on the left *)
            let hpad = match h with
              | `Left -> 0
              | `Center -> max 0 ((expected_size.x - (size b').x) / 2)
              | `Right -> max 0 (expected_size.x - (size b').x)
            and vpad = match v with
              | `Top -> 0
              | `Center -> max 0 ((expected_size.y - (size b').y) / 2)
              | `Bottom -> max 0 (expected_size.y - (size b').y)
            in
            let pos' = Pos.move pos hpad vpad in
            (* just render [b'] with new offset *)
            render_rec ~offset ~ansi b' pos';
          | None ->
            render_rec ~ansi ~offset b' pos
        end
      | Grid (style,m) ->
        let dim = B.dim_matrix m in
        let bars = match style with
          | `None -> false
          | `Bars -> true
        in
        let lines, columns, space_for_bars = _size_matrix ~bars m in

        (* write boxes *)
        for j = 0 to dim.y - 1 do
          for i = 0 to dim.x - 1 do
            let expected_x = match expected_size with
              | Some es when i=dim.x-1 -> es.x - columns.(i)
              | _ -> columns.(i+1) - columns.(i) - (if i=dim.x-1 then 0 else space_for_bars)
            and expected_y = match expected_size with
              | Some es when j=dim.y-1 -> es.y - lines.(j)
              | _ -> lines.(j+1) - lines.(j)- (if j=dim.y-1 then 0 else space_for_bars)
            in
            let expected_size = {x=expected_x; y=expected_y} in
            let pos' = Pos.move pos (columns.(i)) (lines.(j)) in
            conn_m.m <- render_rec ~ansi ~expected_size m.(j).(i) pos'
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
              write_hline_ conn_m (Pos.move pos (-offset.x) (lines.(j)-1)) len_hlines
            done;
            for i=1 to dim.x - 1 do
              write_vline_ conn_m (Pos.move pos (columns.(i)-1) (-offset.y)) len_vlines
            done;
            for j=1 to dim.y - 1 do
              for i=1 to dim.x - 1 do
                conn_m.m <- create_or_update ~left:true ~right:true ~top:true ~bottom:true (Pos.move pos (columns.(i)-1) (lines.(j)-1)) conn_m.m
              done
            done
        end;
        conn_m.m
      | Tree (indent, n, a) ->
        conn_m.m <- render_rec ~ansi n pos;
        (* start position for the children *)
        let pos' = Pos.move pos indent (size n).y in
        assert (Array.length a > 0);
        let _ = _array_foldi
            (fun pos' i b ->
               let s = "└─" in
               conn_m.m <- create_or_update ~ct:`Tree ~top:true ~right:true pos' conn_m.m;
               conn_m.m <- create_or_update ~ct:`Tree ~left:true ~right:true (Pos.move_x pos' 1) conn_m.m;
               conn_m.m <- create_or_update ~ct:`Tree ~top:true (Pos.move_y pos' 1) conn_m.m;
               if i<Array.length a-1 then (
                 write_vline_ ~ct:`Tree conn_m (Pos.move_y pos' 1) ((size b).y-1)
               );
               conn_m.m <- render_rec ~ansi b (Pos.move_x pos' (str_display_width_ s 0 (String.length s)));
               Pos.move_y pos' (size b).y
            ) pos' a
        in
        conn_m.m
    in
    render_rec ~ansi:ansi ~offset:offset ?expected_size:expected_size b pos

  let post_render ~out conn_map =
    let render_conn_pos pos conn =
      if (pos.x >= 0) && (pos.y >=0) then
        if disp_conn `Nontree conn then
          Output.put_string out pos (disp_conn_char conn.nontree)
        else if disp_conn `Tree conn then
          Output.put_string out pos (disp_conn_char conn.tree)
    in
    M.iter render_conn_pos conn_map

  let render ~ansi out b =
    post_render ~out (pre_render ~ansi ~out b Pos.origin)
end

let to_string_with ~style b =
  let buf = Output.create() in
  Box_inner.render ~ansi:style buf (Box_inner.of_box b);
  Output.to_string buf

let to_string = to_string_with ~style:true

let output ?(style=true) ?(indent=0) oc b =
  let buf = Output.create () in
  Box_inner.render ~ansi:style buf (Box_inner.of_box b);
  Output.to_chan ~indent oc buf;
  flush oc

let pp_with ~style out b =
  let buf = Output.create () in
  Box_inner.render ~ansi:style buf (Box_inner.of_box b);
  Output.pp out buf

let pp = pp_with ~style:true
