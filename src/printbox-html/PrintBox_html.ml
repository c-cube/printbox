(* This file is free software. See file "license" for more details. *)

(** {1 Output HTML} *)

open Tyxml

module B = PrintBox
module H = Html

type 'a html = 'a Html.elt

let prelude =
  let l =
    [ "table, th, td { border-collapse: collapse; }"
    ; "table.framed { border: 2px solid black; }"
    ; "table.framed th, table.framed td { border: 1px solid black; }"
    ; "th, td { padding: 3px; }"
    ; "tr:nth-child(even) { background-color: #eee; }"
    ; "tr:nth-child(odd) { background-color: #fff; }"
    ; ".align-right { text-align: right; }"
    ; ".center { text-align: center; }"
    ]
  in
  H.style (List.map H.pcdata l)

let prelude_str =
  Format.asprintf "%a@." (H.pp_elt ()) prelude

let attrs_of_style (s:B.Style.t) : _ list * _ =
  let open B.Style in
  let {bold;bg_color;fg_color;preformatted} = s in
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
    (if preformatted then ["font-family", "monospace"] else [])
  in
  let a = match s with
    | [] -> []
    | s -> [H.a_style @@ String.concat ";" @@ List.map (fun (k,v) -> k ^ ": " ^ v) s] in
  a, bold

module Config = struct
  type t = {
    cls_table: string list;
    a_table: Html_types.table_attrib Html.attrib list;
    cls_text: string list;
    a_text: Html_types.span_attrib Html.attrib list;
    cls_row: string list;
    a_row: Html_types.div_attrib Html.attrib list;
    cls_col: string list;
    a_col: Html_types.div_attrib Html.attrib list;
    tree_summary: bool;
  }

  let default : t = {
    cls_table=[];
    a_table=[];
    cls_text=[];
    a_text=[];
    cls_row=[];
    a_row=[];
    cls_col=[];
    a_col=[];
    tree_summary=false;
  }

  let cls_table x c = {c with cls_table=x}
  let a_table x c = {c with a_table=x}
  let cls_text x c = {c with cls_text=x}
  let a_text x c = {c with a_text=x}
  let cls_row x c = {c with cls_row=x}
  let a_row x c = {c with a_row=x}
  let cls_col x c = {c with cls_col=x}
  let a_col x c = {c with a_col=x}
  let tree_summary x c = {c with tree_summary=x}
end

let to_html_rec ~config (b: B.t) =
  let open Config in
  let text_to_html ?(border=false) ~l ~style () =
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
      | B.Text {l; style} when style.B.Style.preformatted -> H.pre [text_to_html ~l ~style ()]
      | B.Text {l; style} -> text_to_html ~l ~style ()
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
  let rec to_html_rec b =
    match B.view b with
    | B.Tree (_, b, l) when config.tree_summary ->
      let l = Array.to_list l in
      (match B.view b with
      | B.Text {l=tl; style} ->
        H.details (H.summary [text_to_html ~l:tl ~style ()])
        [ H.ul (List.map (fun x -> H.li [to_html_rec x]) l) ]
      | B.Frame b ->
        (match B.view b with
        | (B.Text {l=tl; style}) ->
          H.details (H.summary [text_to_html ~border:true ~l:tl ~style ()])
            [ H.ul (List.map (fun x -> H.li [to_html_rec x]) l) ]
        | _ ->
          H.div
            [ to_html_rec b
            ; H.ul (List.map (fun x -> H.li [to_html_rec x]) l)
            ])
      | _ ->
        H.div
          [ to_html_rec b
          ; H.ul (List.map (fun x -> H.li [to_html_rec x]) l)
          ])
    | B.Link {uri; inner} ->
      H.div [H.a ~a:[H.a_href uri] [to_html_nondet_rec inner]]
    | _ -> loop to_html_rec b
  and to_html_nondet_rec b =
    match B.view b with
    | B.Link {uri; inner} ->
      H.div [H.a ~a:[H.a_href uri] [to_html_nondet_rec inner]]
    | _ -> loop to_html_nondet_rec b
  in
  to_html_rec b

let to_html ?(config=Config.default) b = H.div [to_html_rec ~config b]

let to_string ?config b =
  Format.asprintf "@[%a@]@." (H.pp_elt ()) (to_html ?config b)

let to_string_indent ?config b =
  Format.asprintf "@[%a@]@." (H.pp_elt ~indent:true ()) (to_html ?config b)

let pp ?config ?indent () pp b =
    Format.fprintf pp "@[%a@]@." (H.pp_elt ?indent ()) (to_html ?config b)
  
let to_string_doc ?config b =
  let meta_str = "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">" in
  let footer_str =
    "<script> \
     [...document.querySelectorAll('p')].forEach(el => \
       el.addEventListener('click', () => el.nextSibling.style.display = \
       el.nextSibling.style.display === 'none' ? 'block' : 'none')); \
     [...document.querySelectorAll('ul ul')].forEach(el => \
       el.style.display = 'none'); \
     </script>"
  in
  Format.asprintf "<head>%s%s</head><body>@[%a@]%s</body>@."
    meta_str prelude_str (H.pp_elt ()) (to_html ?config b) footer_str
