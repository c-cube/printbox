(* This file is free software. See file "license" for more details. *)

module B = PrintBox

module Config = struct
  type preformatted = Code_block | Code_quote | Stylized
  type t = {
    tables: [`Text | `Html];
    vlists: [`Line_break | `List | `As_table];
    foldable_trees: bool;
    multiline_preformatted: preformatted;
    one_line_preformatted: preformatted;
    non_preformatted: [`Minimal | `Stylized];
    frames: [`Quotation | `Stylized];
    tab_width: int;
  }

  let default = {
    tables=`Text;
    vlists=`List;
    foldable_trees=false;
    multiline_preformatted=Code_block;
    one_line_preformatted=Code_quote;
    non_preformatted=`Minimal;
    frames=`Quotation;
    tab_width=4;
  }
  let uniform = {
    tables=`Html;
    vlists=`Line_break;
    foldable_trees=true;
    multiline_preformatted=Stylized;
    one_line_preformatted=Stylized;
    non_preformatted=`Stylized;
    frames=`Stylized;
    tab_width=4;
  }

  let html_tables c = {c with tables=`Html}
  let text_tables c = {c with tables=`Text}
  let vlists x c = {c with vlists=x}
  let foldable_trees c = {c with foldable_trees=true}
  let unfolded_trees c = {c with foldable_trees=false}
  let multiline_preformatted x c = {c with multiline_preformatted=x}
  let one_line_preformatted x c = {c with one_line_preformatted=x}
  let tab_width x c = {c with tab_width=x}
  let quotation_frames c = {c with frames=`Quotation}
  let stylized_frames c = {c with frames=`Stylized}
end

 let style_format c ~in_span ~multiline (s:B.Style.t) =
  let open B.Style in
  let {bold; bg_color; fg_color; preformatted} = s in
  let encode_color = function
    | Red -> "red"
    | Blue -> "blue"
    | Green -> "green"
    | Yellow -> "yellow"
    | Cyan -> "cyan"
    | Black -> "black"
    | Magenta -> "magenta"
    | White -> "white"
  in
  let preformatted_conf =
    if multiline then c.Config.multiline_preformatted else c.Config.one_line_preformatted in
  let stylized = in_span || preformatted_conf = Config.Stylized in
  let code_block =
    preformatted && not stylized && preformatted_conf = Config.Code_block in
  let code_quote =
    preformatted && not stylized && preformatted_conf = Config.Code_quote in
  let handle_space = not code_block && not code_quote in
  let pre_block =
    handle_space && multiline && c.Config.non_preformatted = `Stylized in
  let s =
    (match bg_color with None -> [] | Some c -> ["background-color", encode_color c]) @
    (match fg_color with None -> [] | Some c -> ["color", encode_color c]) @
    (if stylized && preformatted then ["font-family", "monospace"] else []) @
    (if handle_space && not multiline && c.Config.non_preformatted = `Stylized
     then ["white-space", "pre"] else [])
  in
  let inline = in_span || not multiline in
  let spec_pre, spec_post =
    if inline then {|<span style="|}, "</span>"
    else {|<div style="|}, "</div>" in
  let sty_pre, sty_post =
    match s with
      | [] -> "", ""
      | s ->
        spec_pre ^ String.concat ";" (List.map (fun (k,v) -> k ^ ": " ^ v) s) ^ {|">|},
        spec_post in
  let bold_pre, bold_post =
    match bold, in_span with
    | false, _ -> "", ""
    | true, false -> "**", "**"
    | true, true -> "<b>", "</b>" in
  bold_pre ^ sty_pre, sty_post ^ bold_post, code_block, pre_block, code_quote, inline

let break_lines l =
  let lines = List.concat @@ List.map (String.split_on_char '\n') l in
  List.filter_map (fun s ->
      let len = String.length s in
      if len = 0 then None
      else if s.[len - 1] = '\r' then Some (String.sub s 0 (len - 1))
      else Some s)
    lines

let pp_string_escaped ~tab_width ~code_block ~code_quote ~html out s =
  (* TODO: benchmark if writing to a buffer first would be more efficient. *)
  let open Format in
  if code_block then pp_print_string out s
  else
    (* Inside "white-space: pre", we shouldn't need &nbsp; at all,
       but e.g. in VS Code Markdown Preview we need it for every other space. *)
    let len = String.length s in
    let opt_char i = if i < len then Some s.[i] else None in
    let print_spaces n_spaces =
      let halfsp = Array.to_list @@ Array.make ((n_spaces + 1) / 2) " " in
      let trailing = if n_spaces mod 2 = 0 then "&nbsp;" else "" in
      fprintf out "%s%s" (String.concat "&nbsp;" halfsp) trailing in
    let print_tab () = print_spaces tab_width in
    let print_next_chars =
      if html then
        fun i ->
          match opt_char i, opt_char (i+1), opt_char (i+2) with
          | Some '<', _, _ -> pp_print_string out "&lt;"; 1
          | Some '>', _, _ -> pp_print_string out "&gt;"; 1
          | Some '&', _, _ -> pp_print_string out "&amp;"; 1
          | Some '\t', _, _ -> print_tab (); 1
          | Some ' ', Some ' ', Some ' ' -> pp_print_string out " &nbsp; "; 3
          | Some ' ', Some ' ', _ -> pp_print_string out " &nbsp;"; 2
          | Some c, _, _ -> pp_print_char out c; 1
          | _ -> len
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
          | Some '\t', _, _ -> print_tab (); 1
          | Some ' ', Some ' ', Some ' ' -> pp_print_string out " &nbsp; "; 3
          | Some ' ', Some ' ', _ -> pp_print_string out " &nbsp;"; 2
          | Some c, _, _ -> pp_print_char out c; 1
          | _ -> len
    in
    if code_quote then
      let code = String.trim (s ^ "`") in
      let n_spaces = len - String.length code + 1 in
      if n_spaces > 0 then
        let spaces = Array.to_list @@ Array.make n_spaces "&nbsp;" in
        fprintf out {|<span style="font-family: monospace">%s</span>`%s|}
          (String.concat "" spaces) code
      else fprintf out "`%s" code
    else
      let i = ref 0 in
      while !i < len do i := !i + print_next_chars !i done

let rec multiline_heuristic b =
  match B.view b with
  | B.Empty -> false
  | B.Text {l=[]; _} -> false
  | B.Text {l=[s]; _} -> String.contains s '\n'
  | B.Text _ -> true
  | B.Frame b -> multiline_heuristic b
  | B.Pad (_, _) -> true
  | B.Align {inner; _} -> multiline_heuristic inner
  | B.Grid (_, rows) ->
    Array.length rows > 1 || Array.exists (Array.exists multiline_heuristic) rows
  | B.Tree (_, header, children) ->
    Array.length children > 0 || multiline_heuristic header
  | B.Link {inner; _} -> multiline_heuristic inner

let rec line_of_length_exn b =
  match B.view b with
  | B.Empty | B.Text {l=[]; _} -> 0
  | B.Text {l=[s]; _} ->
    if String.contains s '\n' then raise Not_found else String.length s
  | B.Text _ -> raise Not_found
  | B.Frame b -> line_of_length_exn b + 39
  | B.Pad (_, _) -> raise Not_found
  | B.Align {inner; _} -> line_of_length_exn inner
  | B.Grid (_, [||]) | B.Grid (_, [|[||]|]) -> 0
  | B.Grid (`None, [|row|]) ->
    (* "&nbsp;" *)
    (Array.length row - 1) * 6 + Array.fold_left (+) 0 (Array.map line_of_length_exn row)
  | B.Grid (`Bars, [|row|]) ->
    (* " | " *)
    (Array.length row - 1) * 3 + Array.fold_left (+) 0 (Array.map line_of_length_exn row)
  | B.Grid _ -> raise Not_found
  | B.Tree (_, header, [||]) -> line_of_length_exn header
  | B.Tree _ -> raise Not_found
  | B.Link {inner; uri} -> line_of_length_exn inner + String.length uri + 4

let is_native_table rows =
  let rec header h =
    match B.view h with
    | B.Text {l=[_]; style={B.Style.bold=true; _}} -> true
    | B.Frame b -> header b
    | _ -> false in
  Array.for_all header rows.(0) &&
  Array.for_all (fun row -> Array.for_all (Fun.negate multiline_heuristic) row) rows

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
  let rec loop ~in_span ~prefix b =
    match B.view b with
    | B.Empty -> ()
    | B.Text {l; style} ->
      let l = break_lines l in
      let multiline = List.length l > 1 in
      let sty_pre, sty_post, code_block, pre_block, code_quote, inline =
        style_format c ~in_span ~multiline style in
      let preformat =
        pp_string_escaped ~tab_width:c.Config.tab_width ~code_block ~code_quote ~html:in_span in
      pp_print_string out sty_pre;
      if not inline && String.length sty_pre > 0 then fprintf out "@,%s" prefix;
      if code_block then fprintf out "```@,%s" prefix;
      if pre_block then fprintf out {|<div style="white-space: pre">|};
      (* use html for gb_color, fg_color and md for bold, preformatted. *)
      pp_print_list
        ~pp_sep:(fun out () ->
           if not code_block && not pre_block then pp_print_string out "<br>";
           fprintf out "@,%s" prefix)
        preformat out l;
      if not inline && String.length sty_pre > 0 then fprintf out "@,%s" prefix;
      if pre_block then fprintf out "</div>";
      if code_block then fprintf out "@,%s```@,%s" prefix prefix;
      pp_print_string out sty_post
    | B.Frame b ->
      if in_span || c.Config.frames = `Stylized then
        let inline = in_span || not (multiline_heuristic b) in
        let spec_pre, spec_post =
          if inline
          then {|<span style="|}, "</span>"
          else {|<div style="|}, "</div>" in
        fprintf out {|%sborder:thin solid">|} spec_pre;
        if not inline then fprintf out "@,%s@,%s" prefix prefix;
        loop ~in_span ~prefix b;
        if not inline then fprintf out "@,%s" prefix;
        pp_print_string out spec_post
      else fprintf out "> %a" (fun _out -> loop ~in_span ~prefix:(prefix ^ "> ")) b
    | B.Pad (_, b) -> 
      (* NOT IMPLEMENTED YET *)
      loop ~in_span ~prefix b
    | B.Align {h = _; v=_; inner} ->
      (* NOT IMPLEMENTED YET *)
      loop ~in_span ~prefix inner
    | B.Grid (bars, rows)
          when c.Config.vlists <> `As_table &&
               Array.for_all (fun row -> Array.length row = 1) rows -> (
      let len = Array.length rows in
      match c.Config.vlists with
      | `As_table -> assert false
      | `List ->
        Array.iteri (fun i r ->
            pp_print_string out "- ";
            loop ~in_span ~prefix:(prefix ^ "  ") r.(0);
            if i < len - 1 then (
              if bars = `Bars then fprintf out "@,%s  > ---" prefix;
              fprintf out "@,%s" prefix))
          rows
      | `Line_break ->
        let br = if bars = `Bars then "</div>" else "<br>" in
        Array.iteri (fun i r ->
            if i < len - 1 && bars = `Bars
            then fprintf out {|<div style="border-bottom:thin solid">@,%s|} prefix;
            loop ~in_span ~prefix r.(0);
            if i < len - 1 then fprintf out "%s@,%s" br prefix)
          rows)
    | B.Grid (_, [||]) -> ()
    | B.Grid (bars, rows) when bars <> `None && is_native_table rows ->
      let lengths =
        Array.fold_left (Array.map2 (fun len b -> max len @@ line_of_length_exn b))
          (Array.map (fun _ -> 0) rows.(0)) rows in
      let n_rows = Array.length rows and n_cols = Array.length rows.(0) in
      Array.iteri (fun i header ->
          loop ~in_span:true ~prefix:"" @@ remove_bold header;
          if i < n_rows - 1 then
            let len = line_of_length_exn header in
            fprintf out "%s|" (String.make (lengths.(i) - len) ' ')
        ) rows.(0);
      fprintf out "@,%s" prefix;
      Array.iteri (fun j _ ->
          pp_print_string out @@ String.make lengths.(j) '-';
          if j < n_cols - 1 then pp_print_char out '|'
        ) rows.(0);
      Array.iteri (fun i row ->
          if i > 0 then Array.iteri (fun j c ->
              loop ~in_span:true ~prefix:"" c;
              if j < n_cols - 1 then
                let len = line_of_length_exn c in
                fprintf out "%s|" (String.make (lengths.(j) - len) ' ')
            ) row;
          if i < n_rows - 1 then fprintf out "@,%s" prefix;
        ) rows
    | B.Grid (_, _) when c.Config.tables = `Html && String.length prefix = 0 ->
      PrintBox_html.pp ~indent:(not in_span) () out b
    | B.Grid (_, _) -> (
      match c.Config.tables with
      | `Text ->
          let style = B.Style.preformatted in
          let l = break_lines [PrintBox_text.to_string b] in
          loop ~in_span ~prefix (B.lines_with_style style l)
      | `Html ->
        let table = PrintBox_html.(if in_span then to_string else to_string_indent) b in
        let lines = break_lines [table] in
        pp_print_list
          ~pp_sep:(fun out () -> if not in_span then fprintf out "@,%s" prefix)
          pp_print_string out lines)
    | B.Tree (_extra_indent, header, [||]) ->
      loop ~in_span ~prefix header
    | B.Tree (extra_indent, header, body) ->
      if c.Config.foldable_trees
      then
        fprintf out "<details><summary>%a</summary>@,%s@,%s- "
          (fun _out -> loop ~in_span:true ~prefix) header prefix prefix
      else (loop ~in_span ~prefix header; fprintf out "@,%s- " prefix);
      let pp_sep out () = fprintf out "@,%s- " prefix in
      let subprefix = prefix ^ String.make (2 + extra_indent) ' ' in
      pp_print_list
        ~pp_sep
        (fun _out sub -> loop ~in_span ~prefix:subprefix sub)
        out @@ Array.to_list body;
      if c.Config.foldable_trees then fprintf out "@,%s</details>" prefix
    | B.Link {uri; inner} ->
      pp_print_string out "[";
      loop ~in_span ~prefix:(prefix ^ " ") inner;
      fprintf out "](%s)" uri in
  pp_open_vbox out 0;
  loop ~in_span:false ~prefix:"" b;
  pp_close_box out ()

let to_string c b =
  Format.asprintf "%a@." (pp c) b
