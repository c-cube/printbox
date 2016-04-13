
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

let rec to_html_rec
  : B.t -> [< Html_types.flow5 > `Div `Ul `Table `P] html
  = function
  | B.Empty -> H.div []
  | B.Text s -> H.p [H.pcdata s]
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

