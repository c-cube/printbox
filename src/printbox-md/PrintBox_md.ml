(* This file is free software. See file "license" for more details. *)

module B = PrintBox

module Config = struct
  type preformatted = Code_block | Code_quote | Stylized
  type t = {
    tables: [`Text | `Html];
    foldable_trees: bool;
    multiline_preformatted: preformatted;
    one_line_preformatted: preformatted;
    frames: [`Quotation | `Stylized];
    tab_width: int;
  }

  let default = {
    tables=`Text;
    foldable_trees=false;
    multiline_preformatted=Code_block;
    one_line_preformatted=Code_quote;
    frames=`Quotation;
    tab_width=4;
  }
  let uniform = {
    tables=`Html;
    foldable_trees=true;
    multiline_preformatted=Stylized;
    one_line_preformatted=Stylized;
    frames=`Stylized;
    tab_width=4;
  }

  let html_tables c = {c with tables=`Html}
  let text_tables c = {c with tables=`Text}
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
  let s =
    (match bg_color with None -> [] | Some c -> ["background-color", encode_color c]) @
    (match fg_color with None -> [] | Some c -> ["color", encode_color c]) @
    (if stylized && preformatted then ["font-family", "monospace"] else [])
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
  let code_block =
    preformatted && not stylized && preformatted_conf = Config.Code_block in
  let code_quote =
    preformatted && not stylized && preformatted_conf = Config.Code_quote in
  bold_pre ^ sty_pre, sty_post ^ bold_post, code_block, code_quote, inline

let break_lines l =
  let lines = List.concat @@ List.map (String.split_on_char '\n') l in
  List.filter_map (fun s ->
      let len = String.length s in
      if len = 0 then None
      else if s.[len - 1] = '\r' then Some (String.sub s 0 (len - 1))
      else Some s)
    lines

let pp_string_nbsp ~tab_width ~code_block ~code_quote ~infix out s =
  let open Format in
  if code_block then pp_print_string out s
  else
    let print_sp nbsp =
      pp_print_string out (if nbsp then "&nbsp;" else " ") in
    let len = String.length s in
    let check i = i < len && (s.[i] = ' ' || s.[i] = '\t') in
    let i = ref 0 in
    let k = ref 0 in
    while !i < len do
      k := !i;
      while check !i do
        print_sp (!i > !k || check (!i + 1));
        if s.[!i] = '\t' then for _ = 1 to tab_width - 1 do print_sp true done;
        incr i
      done;
      if !k = 0 then pp_print_string out infix;
      k := !i;
      if code_quote then (
        i := len;
        pp_print_string out @@ String.sub s !k (len - !k);)
      else (
        while !i < len && (not @@ check !i) do incr i done;
        if !k < len then pp_print_string out @@ String.sub s !k (!i - !k);
      )
    done

let rec multiline_heuristic b =
  match B.view b with
  | B.Empty -> false
  | B.Text {l=[]; _} -> false
  | B.Text {l=[s]; _} -> String.contains s '\n'
  | B.Text _ -> true
  | B.Frame b -> multiline_heuristic b
  | B.Pad (_, _) -> true
  | B.Align _ -> false
  | B.Grid (_, arr) -> Array.length arr > 1
  | B.Tree (_, header, children) ->
    Array.length children > 0 || multiline_heuristic header
  | B.Link {inner; _} -> multiline_heuristic inner
  

let pp c out b =
  let open Format in
  (* We cannot use Format for indentation, because we need to insert ">" at the right places. *)
  let rec loop ~in_span ~prefix b =
    match B.view b with
    | B.Empty -> ()
    | B.Text {l; style} ->
      let l = break_lines l in
      let multiline = List.length l > 1 in
      let sty_pre, sty_post, code_block, code_quote, inline =
        style_format c ~in_span ~multiline style in
      let preformat = pp_string_nbsp ~tab_width:c.Config.tab_width ~code_block ~code_quote in
      pp_print_string out sty_pre;
      if not inline && String.length sty_pre > 0 then fprintf out "@,%s" prefix;
      if code_block then fprintf out "```@,%s" prefix;
      (* use html for gb_color, fg_color and md for bold, preformatted. *)
      pp_print_list
        ~pp_sep:(fun out () ->
           if not code_block then pp_print_string out "<br>";
           fprintf out "@,%s" prefix)
        (fun out s ->
           if code_quote then fprintf out "%a`" (preformat ~infix:"`") s
           else preformat ~infix:"" out s)
        out l;
      if not inline && String.length sty_pre > 0 then fprintf out "@,%s" prefix;
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
