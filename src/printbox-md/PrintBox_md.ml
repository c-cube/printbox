(* This file is free software. See file "license" for more details. *)

module B = PrintBox

module Config = struct
  type preformatted = Code_block | Code_quote
  type t = {
    tables: [`Text | `Html];
    vlists: [`Line_break | `List | `As_table];
    hlists: [`Minimal | `As_table];
    foldable_trees: bool;
    multiline_preformatted: preformatted;
    one_line_preformatted: preformatted;
    frames: [`Quotation | `As_table];
    tab_width: int;
  }

  let default = {
    tables=`Text;
    vlists=`List;
    hlists=`Minimal;
    foldable_trees=false;
    multiline_preformatted=Code_block;
    one_line_preformatted=Code_quote;
    frames=`Quotation;
    tab_width=4;
  }
  let uniform = {
    tables=`Html;
    vlists=`Line_break;
    hlists=`As_table;
    foldable_trees=true;
    multiline_preformatted=Code_block;
    one_line_preformatted=Code_quote;
    frames=`As_table;
    tab_width=4;
  }

  let html_tables c = {c with tables=`Html}
  let text_tables c = {c with tables=`Text}
  let vlists x c = {c with vlists=x}
  let hlists x c = {c with hlists=x}
  let foldable_trees c = {c with foldable_trees=true}
  let unfolded_trees c = {c with foldable_trees=false}
  let multiline_preformatted x c = {c with multiline_preformatted=x}
  let one_line_preformatted x c = {c with one_line_preformatted=x}
  let tab_width x c = {c with tab_width=x}
  let quotation_frames c = {c with frames=`Quotation}
  let table_frames c = {c with frames=`As_table}
end

 let style_format c ~no_md ~multiline (s:B.Style.t) =
  let open B.Style in
  (* Colors require support for styles: see issue #37 *)
  let {bold; bg_color = _; fg_color = _; preformatted} = s in
  let preformatted_conf =
    if multiline then c.Config.multiline_preformatted
    else c.Config.one_line_preformatted in
  let code_block =
    not no_md && preformatted && preformatted_conf = Config.Code_block in
  let code_quote =
    not no_md && preformatted && preformatted_conf = Config.Code_quote in
  let bold_pre, bold_post =
    match bold, no_md with
    | false, _ -> "", ""
    | true, false -> "**", "**"
    | true, true -> "<b>", "</b>" in
  let code_pre, code_post =
    if code_block || code_quote || not preformatted then "", ""
    else "<code>", "</code>" in
  bold_pre ^ code_pre, code_post ^ bold_post, code_block, code_quote

let break_lines l =
  let lines = List.concat @@ List.map (String.split_on_char '\n') l in
  List.filter_map (fun s ->
      let len = String.length s in
      if len = 0 then None
      else if s.[len - 1] = '\r' then Some (String.sub s 0 (len - 1))
      else Some s)
    lines

let pp_string_escaped ~tab_width ~code_block ~code_quote ~html out s =
  let open Format in
  if code_block then pp_print_string out s
  else
    let len = String.length s in
    let opt_char i = if i < len then Some s.[i] else None in
    let print_spaces nbsp n_spaces =
      if n_spaces > 0 then
        let halfsp = Array.to_list @@ Array.make ((n_spaces + 1) / 2) " " in
        let trailing = if n_spaces mod 2 = 0 then nbsp else "" in
        fprintf out "%s%s" (String.concat nbsp halfsp) trailing in
    let print_next_spaces i =
      match opt_char i, opt_char (i+1), opt_char (i+2) with
      | Some ' ', Some ' ', Some ' ' when i = 0 -> pp_print_string out "·"; 1
      | Some ' ', Some ' ', Some ' ' -> pp_print_string out " ·"; 2
      | Some ' ', Some ' ', _ -> pp_print_string out "· "; 2
      | Some '\t', Some ' ', _ when i = 0 && tab_width mod 2 = 0 ->
        pp_print_string out "·"; print_spaces "·" tab_width; 2
      | Some '\t', Some '\t', Some ' ' when i = 0 && tab_width mod 2 = 0 ->
        pp_print_string out "·"; print_spaces "·" (tab_width - 1);
        pp_print_string out "·"; print_spaces "·" tab_width; 2
      | Some '\t', _, _ when i = 0 ->
        pp_print_string out "·"; print_spaces "·" (tab_width - 1); 1
      | Some '\t', Some ' ', _ when tab_width mod 2 = 1 ->
        print_spaces "·" (tab_width + 1); 2
      | Some '\t', Some '\t', _ when tab_width mod 2 = 1 ->
        print_spaces "·" (2 * tab_width); 2
      | Some '\t', _, _ -> print_spaces "·" tab_width; 1
      | Some ' ', _, _ -> pp_print_string out " "; 1
      | _ -> assert false in
    let print_next_chars =
      if html then
        fun i ->
          match opt_char i with
          | Some '<' -> pp_print_string out "&lt;"; 1
          | Some '>' -> pp_print_string out "&gt;"; 1
          | Some '&' -> pp_print_string out "&amp;"; 1
          | Some '\t' | Some ' ' -> print_next_spaces i
          | Some c -> pp_print_char out c; 1
          | None -> len
      else if code_quote then
        fun i ->
          match opt_char i with
          | Some '\t' | Some ' ' -> print_next_spaces i
          | Some c -> pp_print_char out c; 1
          | None -> len  
      else
        fun i ->
          match opt_char i, opt_char (i+1), opt_char (i+2) with
          | Some '<', _, _ -> pp_print_string out "\\<"; 1
          | Some '>', _, _ -> pp_print_string out "\\>"; 1
          | Some ' ', Some '*', Some ' ' -> pp_print_string out " * "; 3
          | Some '*', _, _ -> pp_print_string out "\\*"; 1
          | Some ' ', Some '_', Some ' ' -> pp_print_string out " _ "; 3
          | Some c1, Some '_', Some c2 when c1 <> ' ' && c2 <> ' ' -> fprintf out "%c_%c" c1 c2; 3
          | Some '_', _, _ -> pp_print_string out "\\_"; 1
          | Some '\t', _, _ | Some ' ', _, _ -> print_next_spaces i
          | Some c, _, _ -> pp_print_char out c; 1
          | _ -> len
    in
    let i = ref 0 in
    if code_quote then pp_print_char out '`';
    while !i < len do i := !i + print_next_chars !i done;
    if code_quote then pp_print_char out '`'

let rec multiline_heuristic c b =
  match B.view b with
  | B.Empty -> false
  | B.Text {l=[]; _} -> false
  | B.Text {l=[s]; _} -> String.contains s '\n'
  | B.Text _ -> true
  | B.Frame _ when c.Config.frames = `As_table -> true
  | B.Frame b -> multiline_heuristic c b
  | B.Pad (_, _) -> true
  | B.Align {inner; _} -> multiline_heuristic c inner
  | B.Grid (_, [|_|]) when c.Config.hlists = `As_table -> true
  | B.Grid (_, rows) ->
    Array.length rows > 1 || Array.exists (Array.exists @@ multiline_heuristic c) rows
  | B.Tree (_, header, children) ->
    Array.length children > 0 || multiline_heuristic c header
  | B.Link {inner; _} -> multiline_heuristic c inner

let rec line_of_length_heuristic_exn c b =
  match B.view b with
  | B.Empty | B.Text {l=[]; _} -> 0
  | B.Text {l=[s]; _} ->
    if String.contains s '\n' then raise Not_found else String.length s
  | B.Text _ -> raise Not_found
  | B.Frame _ when c.Config.frames = `As_table -> raise Not_found
  | B.Frame b ->
    (* "> " or "[]" *)
    line_of_length_heuristic_exn c b + 2
  | B.Pad (_, _) -> raise Not_found
  | B.Align {inner; _} -> line_of_length_heuristic_exn c inner
  | B.Grid (_, [||]) | B.Grid (_, [|[||]|]) -> 0
  | B.Grid (`None, [|row|]) when c.Config.hlists = `Minimal ->
    (* " &nbsp; " *)
    (Array.length row - 1) * 8 +
    Array.fold_left (+) 0 (Array.map (line_of_length_heuristic_exn c) row)
  | B.Grid (`Bars, [|row|]) when c.Config.hlists = `Minimal ->
    (* " | " *)
    (Array.length row - 1) * 3 +
    Array.fold_left (+) 0 (Array.map (line_of_length_heuristic_exn c) row)
  | B.Grid _ -> raise Not_found
  | B.Tree (_, header, [||]) -> line_of_length_heuristic_exn c header
  | B.Tree _ -> raise Not_found
  | B.Link {inner; uri} -> line_of_length_heuristic_exn c inner + String.length uri + 4

let is_native_table c rows =
  let rec header h =
    match B.view h with
    | B.Text {l=[_]; style={B.Style.bold=true; _}} -> true
    | B.Frame b -> header b
    | _ -> false in
  Array.for_all header rows.(0) &&
  Array.for_all (fun row -> Array.for_all (Fun.negate @@ multiline_heuristic c) row) rows

let rec remove_bold b =
  match B.view b with
  | B.Empty | B.Text {l=[]; _} -> B.empty
  | B.Text {l; style} -> B.lines_with_style (B.Style.set_bold false style) l
  | B.Frame b -> B.frame @@ remove_bold b
  | B.Pad (pos, b) -> B.pad' ~col:pos.B.x ~lines:pos.B.y @@ remove_bold b
  | B.Align {h; v; inner} -> B.align ~h ~v @@ remove_bold inner
  | B.Grid _ -> assert false
  | B.Tree (_, header, [||]) -> remove_bold header
  | B.Tree _ -> assert false
  | B.Link {inner; uri} -> B.link ~uri @@ remove_bold inner
  
let pp c out b =
  let open Format in
  (* We cannot use Format for indentation, because we need to insert ">" at the right places. *)
  let rec loop ~no_block ~no_md ~prefix b =
    let br = if no_md then "<br>" else "  " in
    match B.view b with
    | B.Empty -> ()
    | B.Text {l; style} ->
      let l = break_lines l in
      let multiline = List.length l > 1 in
      let sty_pre, sty_post, code_block, code_quote =
        style_format c ~no_md ~multiline style in
      let preformat =
        pp_string_escaped ~tab_width:c.Config.tab_width ~code_block ~code_quote ~html:no_md in
      pp_print_string out sty_pre;
      if code_block then fprintf out "@,%s```@,%s" prefix prefix;
      pp_print_list
        ~pp_sep:(fun out () ->
           if not code_block then pp_print_string out br;
           fprintf out "@,%s" prefix)
        preformat out l;
      if code_block then fprintf out "@,%s```@,%s" prefix prefix;
      pp_print_string out sty_post
    | B.Frame fb -> (
      match c.Config.frames, c.Config.tables, no_block with
      | `As_table, `Html, _ ->
        PrintBox_html.pp ~flush:false ~indent:(not no_block) () out b;
        if not no_md then fprintf out "@,%s@,%s" prefix prefix
      | `As_table, `Text, _ ->
        let style = B.Style.preformatted in
        let l = break_lines [PrintBox_text.to_string_with ~style:false b] in
        loop ~no_block ~no_md ~prefix (B.lines_with_style style l)
      | _, _, true ->
        (* E.g. in a first Markdown table cell, "> " would mess up rendering. *)
        fprintf out "[%a]" (fun _out -> loop ~no_block ~no_md ~prefix:(prefix ^ " ")) fb
      | _ -> fprintf out "> %a"
        (fun _out -> loop ~no_block ~no_md ~prefix:(prefix ^ "> ")) fb)
    | B.Pad (_, b) -> 
      (* NOT IMPLEMENTED YET *)
      loop ~no_block ~no_md ~prefix b
    | B.Align {h = _; v=_; inner} ->
      (* NOT IMPLEMENTED YET *)
      loop ~no_block ~no_md ~prefix inner
    | B.Grid (bars, [|row|])
      when c.Config.hlists = `Minimal &&
           Array.for_all (Fun.negate @@ multiline_heuristic c) row ->
      let len = Array.length row in
      Array.iteri (fun i r ->
          loop ~no_block:true ~no_md ~prefix r;
          if i < len - 1 then (
            if bars = `Bars then fprintf out " | " else fprintf out " &nbsp; "))
        row
    | B.Grid (bars, rows)
          when c.Config.vlists <> `As_table &&
               Array.for_all (fun row -> Array.length row = 1) rows -> (
      let len = Array.length rows in
      match c.Config.vlists with
      | `As_table -> assert false
      | `List ->
        Array.iteri (fun i r ->
            pp_print_string out "- ";
            loop ~no_block ~no_md ~prefix:(prefix ^ "  ") r.(0);
            if i < len - 1 then (
              if bars = `Bars then fprintf out "@,%s  > ---" prefix;
              fprintf out "@,%s" prefix))
          rows
      | `Line_break ->
        Array.iteri (fun i r ->
            loop ~no_block ~no_md ~prefix r.(0);
            if i < len - 1 then (
              if bars = `Bars then fprintf out "%s@,%s> ---@,%s" br prefix prefix
              else fprintf out "%s@,%s@,%s" br prefix prefix))
          rows)
    | B.Grid (_, [||]) -> ()
    | B.Grid (bars, rows) when bars <> `None && is_native_table c rows ->
      let lengths =
        Array.fold_left (Array.map2 (fun len b -> max len @@ line_of_length_heuristic_exn c b))
          (Array.map (fun _ -> 0) rows.(0)) rows in
      let n_rows = Array.length rows and n_cols = Array.length rows.(0) in
      Array.iteri (fun i header ->
          loop ~no_block:true ~no_md ~prefix:"" @@ remove_bold header;
          if i < n_rows - 1 then
            let len = line_of_length_heuristic_exn c header in
            fprintf out "%s|" (String.make (lengths.(i) - len) ' ')
        ) rows.(0);
      fprintf out "@,%s" prefix;
      Array.iteri (fun j _ ->
          pp_print_string out @@ String.make lengths.(j) '-';
          if j < n_cols - 1 then pp_print_char out '|'
        ) rows.(0);
      Array.iteri (fun i row ->
          if i > 0 then Array.iteri (fun j b ->
              loop ~no_block:true ~no_md ~prefix:"" b;
              if j < n_cols - 1 then
                let len = line_of_length_heuristic_exn c b in
                fprintf out "%s|" (String.make (lengths.(j) - len) ' ')
            ) row;
          if i < n_rows - 1 then fprintf out "@,%s" prefix;
        ) rows
    | B.Grid (_, _) when c.Config.tables = `Html && String.length prefix = 0 ->
      PrintBox_html.pp ~flush:false ~indent:(not no_block) () out b;
      if not no_md then fprintf out "@,%s@,%s" prefix prefix
    | B.Grid (_, _) -> (
      match c.Config.tables with
      | `Text ->
          let style = B.Style.preformatted in
          let l = break_lines [PrintBox_text.to_string_with ~style:false b] in
          loop ~no_block ~no_md ~prefix (B.lines_with_style style l)
      | `Html ->
        let table = PrintBox_html.(if no_block then to_string else to_string_indent) b in
        let lines = break_lines [table] in
        pp_print_list
          ~pp_sep:(fun out () -> if not no_block then fprintf out "@,%s" prefix)
          pp_print_string out lines);
        if not no_md then fprintf out "@,%s@,%s" prefix prefix
    | B.Tree (_extra_indent, header, [||]) ->
      loop ~no_block ~no_md ~prefix header
    | B.Tree (extra_indent, header, body) ->
      if c.Config.foldable_trees
      then
        fprintf out "<details><summary>%a</summary>@,%s@,%s- "
          (fun _out -> loop ~no_block:true ~no_md:true ~prefix) header prefix prefix
      else (loop ~no_block ~no_md ~prefix header; fprintf out "@,%s- " prefix);
      let pp_sep out () = fprintf out "@,%s- " prefix in
      let subprefix = prefix ^ String.make (2 + extra_indent) ' ' in
      pp_print_list
        ~pp_sep
        (fun _out sub -> loop ~no_block ~no_md ~prefix:subprefix sub)
        out @@ Array.to_list body;
      if c.Config.foldable_trees
      then fprintf out "@,%s</details>@,%s@,%s" prefix prefix prefix
    | B.Link {uri; inner} ->
      pp_print_string out "[";
      loop ~no_block:true ~no_md ~prefix:(prefix ^ " ") inner;
      fprintf out "](%s)" uri in
  pp_open_vbox out 0;
  loop ~no_block:false ~no_md:false ~prefix:"" b;
  pp_close_box out ()

let to_string c b =
  Format.asprintf "%a@." (pp c) b
