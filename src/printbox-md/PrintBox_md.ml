(* This file is free software. See file "license" for more details. *)

module B = PrintBox

(* This is a bare-bones implementation that will hopefully evolve over time. *)
(* 
let to_md_rec ~tables ~trees (b: B.t) =
  let text_to_md ?(border=false) ~l ~style () =
    let a, bold = attrs_of_style style in
    let l = List.map H.txt l in
    let l = if bold then List.map (fun x->H.b [x]) l else l in
    let a_border = if border then [H.a_style  "border:thin solid"] else [] in
    H.span ~a:(H.a_class config.cls_text :: a_border @ (a @ config.a_text)) l in
  let loop :
    'tags. (B.t -> ([< Html_types.flow5 > `Pre `Span `Div `Ul `Table `P] as 'tags) html) -> B.t -> 'tags html =
    fun fix b ->
      match B.view b with
      | B.Empty -> (H.div [] :> [< Html_types.flow5 > `Pre `Span `Div `P `Table `Ul ] html)
      | B.Text {l; style} when style.B.Style.preformatted -> H.pre [text_to_md ~l ~style ()]
      | B.Text {l; style} -> text_to_md ~l ~style ()
      | B.Pad (_, b) -> fix b
      | B.Frame b ->
         H.div ~a:[H.a_style "border:thin solid"] [ fix b ]
      | B.Align {h=`Right;inner=b;v=_} ->
        H.div ~a:[H.a_class ["align-right"]] [ fix b ]
      | B.Align {h=`Center;inner=b;v=_} ->
        H.div ~a:[H.a_class ["center"]] [ fix b ]
      | B.Align {inner=b;_} -> fix b
      | B.Grid (bars, a) ->
        let class_ = match bars with
          | `Bars -> "framed"
          | `None -> "non-framed"
        in
        let to_row a =
          Array.to_list a
          |> List.map
            (fun b -> H.td ~a:(H.a_class config.cls_col :: config.a_col) [fix b])
          |> (fun x -> H.tr ~a:(H.a_class config.cls_row :: config.a_row) x)
        in
        let rows =
          Array.to_list a |> List.map to_row
        in
        H.table ~a:(H.a_class (class_ :: config.cls_table)::config.a_table) rows
      | B.Tree (_, b, l) ->
        let l = Array.to_list l in
        H.div
          [ fix b
          ; H.ul (List.map (fun x -> H.li [fix x]) l)
          ]
      | B.Link _ -> assert false
  in
  let rec to_md_rec b =
    match B.view b with
    | B.Tree (_, b, l) when config.tree_summary ->
      let l = Array.to_list l in
      (match B.view b with
      | B.Text {l=tl; style} ->
        H.details (H.summary [text_to_md ~l:tl ~style ()])
        [ H.ul (List.map (fun x -> H.li [to_md_rec x]) l) ]
      | B.Frame b ->
        (match B.view b with
        | (B.Text {l=tl; style}) ->
          H.details (H.summary [text_to_md ~border:true ~l:tl ~style ()])
            [ H.ul (List.map (fun x -> H.li [to_md_rec x]) l) ]
        | _ ->
          H.div
            [ to_md_rec b
            ; H.ul (List.map (fun x -> H.li [to_md_rec x]) l)
            ])
      | _ ->
        H.div
          [ to_md_rec b
          ; H.ul (List.map (fun x -> H.li [to_md_rec x]) l)
          ])
    | B.Link {uri; inner} ->
      H.div [H.a ~a:[H.a_href uri] [to_md_nondet_rec inner]]
    | _ -> loop to_md_rec b
  and to_md_nondet_rec b =
    match B.view b with
    | B.Link {uri; inner} ->
      H.div [H.a ~a:[H.a_href uri] [to_md_nondet_rec inner]]
    | _ -> loop to_md_nondet_rec b
  in
  to_md_rec b
 *)

 let style_format ~in_html (s:B.Style.t) =
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
  let s =
    (match bg_color with None -> [] | Some c -> ["background-color", encode_color c]) @
    (match fg_color with None -> [] | Some c -> ["color", encode_color c]) @
    (if in_html && preformatted then ["font-family", "monospace"] else [])
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
  bold_pre ^ sty_pre, sty_post ^ bold_post

let pp ~tables ~foldable_trees out b =
  let open Format in
  (* We cannot use Format for indentation, because we need to insert ">" at the right places. *)
  let rec loop ~in_html ~prefix b =
    match B.view b with
    | B.Empty -> ()
    | B.Text {l; style} ->
      let sty_pre, sty_post = style_format ~in_html style in
      pp_print_string out sty_pre;
      (* use html for gb_color, fg_color and md for bold, preformatted. *)
      pp_print_list
        ~pp_sep:(fun out () ->
           pp_print_string out "<br>"; pp_print_cut out (); pp_print_string out prefix)
        (fun out s ->
          if not in_html && style.B.Style.preformatted
          then fprintf out"`%s`" s
          else pp_print_string out s
        ) out l;
        pp_print_string out sty_post
    | B.Frame b ->
      if in_html then
        fprintf out {|<span style="border:thin solid">%a</span>|}
          (fun _out -> loop ~in_html ~prefix) b
      else fprintf out "> %a" (fun _out -> loop ~in_html ~prefix:(prefix ^ "> ")) b
    | B.Pad (_, b) -> 
      (* NOT IMPLEMENTED YET *)
      loop ~in_html ~prefix b
    | B.Align {h = _; v=_; inner} ->
      (* NOT IMPLEMENTED YET *)
      loop ~in_html ~prefix inner
    | B.Grid (_, _) when tables = `Html && String.length prefix = 0 ->
      PrintBox_html.pp ~indent:(not in_html) () out b
    | B.Grid (_, _) ->
      let table =
        if tables = `Text then PrintBox_text.to_string b
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
      if foldable_trees
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
      if foldable_trees then fprintf out "@,%s</details>" prefix
    | B.Link {uri; inner} ->
      pp_print_string out "[";
      loop ~in_html ~prefix:(prefix ^ " ") inner;
      fprintf out "](%s)" uri in
  pp_open_vbox out 0;
  loop ~in_html:false ~prefix:"" b;
  pp_close_box out ()

let to_string ~tables ~foldable_trees b =
  Format.asprintf "%a@." (pp ~tables ~foldable_trees) b
