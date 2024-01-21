(* This file is free software. See file "license" for more details. *)

module B = PrintBox

module Config = struct
  type preformatted = Code_quote | Code_block | Stylized
  type t = {
    tables: [`Text | `Html];
    foldable_trees: bool;
    multiline_preformatted: preformatted;
    one_line_preformatted: preformatted;
    frames: [`Quotation | `Stylized];
    tab_width: int;
  }

  let default = {
    tables=`Html;
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
end

 let style_format c ~in_html ~multiline (s:B.Style.t) =
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
  let stylized = in_html || preformatted_conf = Config.Stylized in
  let s =
    (match bg_color with None -> [] | Some c -> ["background-color", encode_color c]) @
    (match fg_color with None -> [] | Some c -> ["color", encode_color c]) @
    (if stylized && preformatted then ["font-family", "monospace"] else [])
  in
  let sty_pre, sty_post =
    match s with
      | [] -> "", ""
      | s ->
        {|<span style="|} ^ String.concat ";" (List.map (fun (k,v) -> k ^ ": " ^ v) s) ^ {|">|},
        "</span>" in
  let bold_pre, bold_post =
    match bold, in_html with
    | false, _ -> "", ""
    | true, false -> "**", "**"
    | true, true -> "<b>", "</b>" in
  let code_block =
    preformatted && not stylized && preformatted_conf = Config.Code_block in
  let code_quote =
    preformatted && not stylized && preformatted_conf = Config.Code_quote in
  bold_pre ^ sty_pre, sty_post ^ bold_post, code_block, code_quote

let pp_indented ~code_block ~code_quote ~infix out s =
  let open Format in
  if code_block then pp_print_string out s
  else
    let print_sp () =
      if code_quote then pp_print_string out "&nbsp; "
      else pp_print_string out "&nbsp;" in
    let i = ref 0 in
    while !i < String.length s && (s.[!i] = ' ' || s.[!i] = '\t') do
      print_sp ();
      if s.[!i] = '\t' then print_sp ();
      incr i
    done;
    fprintf out "%s%s" infix @@ String.sub s !i (String.length s - !i)

let pp c out b =
  let open Format in
  (* We cannot use Format for indentation, because we need to insert ">" at the right places. *)
  let rec loop ~in_html ~prefix b =
    match B.view b with
    | B.Empty -> ()
    | B.Text {l; style} ->
      let multiline = List.length l > 1 in
      let sty_pre, sty_post, code_block, code_quote =
        style_format c ~in_html ~multiline style in
      pp_print_string out sty_pre;
      if code_block then fprintf out "```@,%s" prefix;
      (* use html for gb_color, fg_color and md for bold, preformatted. *)
      pp_print_list
        ~pp_sep:(fun out () ->
           if not code_block then pp_print_string out "<br>";
           fprintf out "@,%s" prefix)
        (fun out s ->
           if code_quote then
             fprintf out "%a`" (pp_indented ~code_block ~code_quote ~infix:"`") s
           else pp_indented ~code_block ~code_quote ~infix:"" out s)
        out l;
      if code_block then fprintf out "@,%s```@,%s" prefix prefix;
      pp_print_string out sty_post
    | B.Frame b ->
      if in_html || c.Config.frames = `Stylized then
        fprintf out {|<span style="border:thin solid">%a</span>|}
          (fun _out -> loop ~in_html ~prefix) b
      else fprintf out "> %a" (fun _out -> loop ~in_html ~prefix:(prefix ^ "> ")) b
    | B.Pad (_, b) -> 
      (* NOT IMPLEMENTED YET *)
      loop ~in_html ~prefix b
    | B.Align {h = _; v=_; inner} ->
      (* NOT IMPLEMENTED YET *)
      loop ~in_html ~prefix inner
    | B.Grid (_, _) when c.Config.tables = `Html && String.length prefix = 0 ->
      PrintBox_html.pp ~indent:(not in_html) () out b
    | B.Grid (_, _) ->
      let table =
        if c.Config.tables = `Text then PrintBox_text.to_string b
        else PrintBox_html.(if in_html then to_string else to_string_indent) b in
      let lines = String.split_on_char '\n' table in
      let lines =
         List.map (fun s ->
           if s.[String.length s - 1] = '\r'
           then String.sub s 0 (String.length s - 1) else s) lines in
      pp_print_list
        ~pp_sep:(fun out () ->
           pp_print_string out "<br>"; 
           if not in_html then fprintf out "@,%s" prefix)
        pp_print_string out lines
    | B.Tree (_extra_indent, header, [||]) ->
      loop ~in_html ~prefix header
    | B.Tree (extra_indent, header, body) ->
      if c.Config.foldable_trees
      then
        fprintf out "<details><summary>%a</summary>@,%s@,%s- "
          (fun _out -> loop ~in_html:true ~prefix) header prefix prefix
      else (loop ~in_html ~prefix header; fprintf out "@,%s- " prefix);
      let pp_sep out () = fprintf out "@,%s- " prefix in
      let subprefix = prefix ^ String.make (2 + extra_indent) ' ' in
      pp_print_list
        ~pp_sep
        (fun _out sub -> loop ~in_html ~prefix:subprefix sub)
        out @@ Array.to_list body;
      if c.Config.foldable_trees then fprintf out "@,%s</details>" prefix
    | B.Link {uri; inner} ->
      pp_print_string out "[";
      loop ~in_html ~prefix:(prefix ^ " ") inner;
      fprintf out "](%s)" uri in
  pp_open_vbox out 0;
  loop ~in_html:false ~prefix:"" b;
  pp_close_box out ()

let to_string c b =
  Format.asprintf "%a@." (pp c) b
