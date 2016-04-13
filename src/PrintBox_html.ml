
(* This file is free software. See file "license" for more details. *)

(** {1 Output HTML} *)

module B = PrintBox

type html = string

let prelude = "
<style>
table, th, td {
  border-collapse: collapse;
}
table.framed {
  border: 2px solid black;
}
table.framed th, table.framed td {
  border: 1px solid black;
}
th, td {
  padding: 3px;
}
tr:nth-child(even) {
  background-color: #eee;
}
tr:nth-child(odd) {
  background-color: #fff;
}
</style>
"
let pp_list ?(sep=", ") pp out l =
  let rec pp_list out l = match l with
    | x::((_::_) as l) ->
      Format.fprintf out "%a%s@, %a" pp x sep pp_list l
    | x::[] -> pp out x
    | [] -> ()
  in
  pp_list out l

let to_string b =
  let buf = Buffer.create 256 in
  let out = Format.formatter_of_buffer buf in
  let rec aux out = function
    | B.Empty -> ()
    | B.Text s ->
      Format.fprintf out "<p>%s</p>@," s
    | B.Frame b -> aux out b (* TODO *)
    | B.Pad (_, b) -> aux out b
    | B.Grid (bars, a) ->
      let head = match bars with
        | `Bars -> "framed"
        | `None -> "non-framed"
      in
      let pp_cell out b =
        Format.fprintf out "@[<hv><td>@   @[<v>%a@]@ </td>@]" aux b
      in
      let pp_row out r =
        Format.fprintf out
          "@[<v><tr>@,  @[<v>%a@]@,</tr>@]"
          (pp_list ~sep:"" pp_cell) (Array.to_list r)
      in
      Format.fprintf out
        "@[<v><table id=\"%s\">@,  @[<v>%a@]@,</table>@]"
        head (pp_list ~sep:"" pp_row) (Array.to_list a)
    | B.Tree (_, b, a) ->
      let l = Array.to_list a in
      let pp_li out = Format.fprintf out "@[<hv2><li>@ %a@ </li>@]" aux in
      Format.fprintf out
        "@[<v>@[%a@]@,<ul>@,  @[<v>%a@]@,</ul>@]"
        aux b (pp_list ~sep:"" pp_li) l


  in
  Format.fprintf out "@[<2>%a@]@." aux b;
  Buffer.contents buf

