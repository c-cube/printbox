
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
    ]
  in
  H.style (List.map H.pcdata l)

let prelude_str =
  Format.asprintf "%a@." (H.pp_elt ()) prelude

let rec to_html_rec (b: B.t) : [< Html_types.flow5 > `Div `Ul `Table `P] html = 
  match B.view b with
  | B.Empty -> H.div []
  | B.Text s -> H.p (List.map H.txt s)
  | B.Pad (_, b)
  | B.Frame b -> to_html_rec b
  | B.Grid (bars, a) ->
    let class_ = match bars with
      | `Bars -> "framed"
      | `None -> "non-framed"
    in
    let to_row a =
      Array.to_list a
      |> List.map (fun b -> H.td [to_html_rec b])
      |> (fun x -> H.tr x)
    in
    let rows =
      Array.to_list a
      |> List.map to_row
    in
    H.table ~a:[H.a_class [class_]] rows
  | B.Tree (_, b, l) ->
    let l = Array.to_list l in
    H.div
      [ to_html_rec b
      ; H.ul (List.map (fun x -> H.li [to_html_rec x]) l)
      ]

let to_html b = H.div [to_html_rec b]

let to_string b =
  Format.asprintf "@[%a@]@." (H.pp_elt ()) (to_html b)

let to_string_doc b =
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
    meta_str prelude_str (H.pp_elt ()) (to_html b) footer_str

