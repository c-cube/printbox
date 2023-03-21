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
  let {bold;bg_color;fg_color} = s in
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
    (match fg_color with None -> [] | Some c -> ["color", encode_color c])
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
    a_text: Html_types.div_attrib Html.attrib list;
    cls_row: string list;
    a_row: Html_types.div_attrib Html.attrib list;
    cls_col: string list;
    a_col: Html_types.div_attrib Html.attrib list;
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
  }

  let cls_table x c = {c with cls_table=x}
  let a_table x c = {c with a_table=x}
  let cls_text x c = {c with cls_text=x}
  let a_text x c = {c with a_text=x}
  let cls_row x c = {c with cls_row=x}
  let a_row x c = {c with a_row=x}
  let cls_col x c = {c with cls_col=x}
  let a_col x c = {c with a_col=x}
end

let rec to_html_rec ~config (b: B.t) : [< Html_types.flow5 > `Div `Ul `Table `P] html =
  let open Config in
  let to_html_rec = to_html_rec ~config in
  match B.view b with
  | B.Empty -> H.div []
  | B.Text rt ->
    let module RT = B.Rich_text in
    let rec conv_rt style rt =
      match RT.view rt with
      | RT.RT_str s ->
        let a, bold = attrs_of_style style in
        let s = H.txt s in
        let s = if bold then H.b [s] else s in
        H.div [s]
          ~a:(H.a_class config.cls_text :: (a @ config.a_text))
      | RT.RT_cat l -> H.div (List.map (conv_rt style) l)
      | RT.RT_style (style, sub) -> conv_rt style sub
    in
    conv_rt B.Style.default rt
  | B.Pad (_, b)
  | B.Frame b -> to_html_rec b
  | B.Align {h=`Right;inner=b;v=_} ->
    H.div ~a:[H.a_class ["align-right"]] [ to_html_rec b ]
  | B.Align {h=`Center;inner=b;v=_} ->
    H.div ~a:[H.a_class ["center"]] [ to_html_rec b ]
  | B.Align {inner=b;_} -> to_html_rec b
  | B.Grid (bars, a) ->
    let class_ = match bars with
      | `Bars -> "framed"
      | `None -> "non-framed"
    in
    let to_row a =
      Array.to_list a
      |> List.map
        (fun b -> H.td ~a:(H.a_class config.cls_col :: config.a_col) [to_html_rec b])
      |> (fun x -> H.tr ~a:(H.a_class config.cls_row :: config.a_row) x)
    in
    let rows =
      Array.to_list a |> List.map to_row
    in
    H.table ~a:(H.a_class (class_ :: config.cls_table)::config.a_table) rows
  | B.Tree (_, b, l) ->
    let l = Array.to_list l in
    H.div
      [ to_html_rec b
      ; H.ul (List.map (fun x -> H.li [to_html_rec x]) l)
      ]
  | B.Link {uri; inner} ->
    H.div [H.a ~a:[H.a_href uri] [to_html_rec inner]]

let to_html ?(config=Config.default) b = H.div [to_html_rec ~config b]

let to_string ?config b =
  Format.asprintf "@[%a@]@." (H.pp_elt ()) (to_html ?config b)

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
