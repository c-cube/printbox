(* This file is free software. See file "license" for more details. *)

(** {1 Output HTML} *)

open Tyxml
module B = PrintBox
module H = Html

type 'a html = 'a Html.elt
type toplevel_html = Html_types.li_content_fun html
type summary_html = Html_types.span_content_fun html
type link_html = Html_types.flow5_without_interactive html
type PrintBox.ext += Embed_html of toplevel_html | Embed_summary_html of summary_html | Embed_link_html of link_html

let prelude =
  let l =
    [
      "table, th, td { border-collapse: collapse; }";
      "table.framed { border: 2px solid black; }";
      "table.framed th, table.framed td { border: 1px solid black; }";
      "th, td { padding: 3px; }";
      "tr:nth-child(even) { background-color: #eee; }";
      "tr:nth-child(odd) { background-color: #fff; }";
      ".align-right { text-align: right; }";
      ".center { text-align: center; }";
    ]
  in
  H.style (List.map H.pcdata l)

let prelude_str = Format.asprintf "%a@." (H.pp_elt ()) prelude

let attrs_of_style (s : B.Style.t) : _ list * _ =
  let open B.Style in
  let { bold; bg_color; fg_color; preformatted } = s in
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
    (match bg_color with
    | None -> []
    | Some c -> [ "background-color", encode_color c ])
    @ (match fg_color with
      | None -> []
      | Some c -> [ "color", encode_color c ])
    @
    if preformatted then
      [ "font-family", "monospace" ]
    else
      []
  in
  let a =
    match s with
    | [] -> []
    | s ->
      [
        H.a_style @@ String.concat ";"
        @@ List.map (fun (k, v) -> k ^ ": " ^ v) s;
      ]
  in
  a, bold

let a_class l =
  if List.exists (fun s -> s <> "") l then
    [ H.a_class l ]
  else
    []

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

  let default : t =
    {
      cls_table = [];
      a_table = [];
      cls_text = [];
      a_text = [];
      cls_row = [];
      a_row = [];
      cls_col = [];
      a_col = [];
      tree_summary = false;
    }

  let cls_table x c = { c with cls_table = x }
  let a_table x c = { c with a_table = x }
  let cls_text x c = { c with cls_text = x }
  let a_text x c = { c with a_text = x }
  let cls_row x c = { c with cls_row = x }
  let a_row x c = { c with a_row = x }
  let cls_col x c = { c with cls_col = x }
  let a_col x c = { c with a_col = x }
  let tree_summary x c = { c with tree_summary = x }
end

let extensions_toplevel : (string, Config.t -> PrintBox.ext -> toplevel_html) Hashtbl.t =
  Hashtbl.create 4

let extensions_summary : (string, Config.t -> PrintBox.ext -> summary_html) Hashtbl.t =
  Hashtbl.create 4

let extensions_link : (string, Config.t -> PrintBox.ext -> link_html) Hashtbl.t =
  Hashtbl.create 4

let register_extension ~key handler =
  if Hashtbl.mem extensions_toplevel key then
    invalid_arg @@ "PrintBox_html.register_extension: already registered " ^ key;
  Hashtbl.add extensions_toplevel key handler

let register_summary_extension ~key handler =
  if Hashtbl.mem extensions_summary key then
    invalid_arg @@ "PrintBox_html.register_summary_extension: already registered " ^ key;
  Hashtbl.add extensions_summary key handler

let register_link_extension ~key handler =
  if Hashtbl.mem extensions_link key then
    invalid_arg @@ "PrintBox_html.register_link_extension: already registered " ^ key;
  Hashtbl.add extensions_link key handler

let embed_html html = B.extension ~key:"Embed_html" (Embed_html html)
let embed_summary_html html = B.extension ~key:"Embed_summary_html" (Embed_summary_html html)
let embed_link_html html = B.extension ~key:"Embed_link_html" (Embed_link_html html)
let sep_spans sep l =
  let len = List.length l in
  List.concat
  @@ List.mapi
       (fun i x ->
         x
         ::
         (if i < len - 1 then
            [ sep () ]
          else
            []))
       l

let br_lines ~bold l =
  sep_spans (H.br ?a:None)
  @@ List.map (fun x ->
         if bold then
           H.b [ H.txt x ]
         else
           H.txt x)
  @@ List.concat
  @@ List.map (String.split_on_char '\n') l

exception Summary_not_supported
exception Link_not_supported

let to_html_funs ~config =
  let open Config in
  let br_text_to_html ?(border = false) ~l ~style () =
    let a, bold = attrs_of_style style in
    let l = br_lines ~bold l in
    let a_border =
      if border then
        [ H.a_style "border:thin solid" ]
      else
        []
    in
    H.span ~a:(a_class config.cls_text @ a_border @ a @ config.a_text) l
  in
  let v_text_to_html ?(border = false) ~l ~style () =
    let a, bold = attrs_of_style style in
    let a_border =
      if border then
        [ H.a_style "border:thin solid" ]
      else
        []
    in
    if style.B.Style.preformatted then
      H.pre
        ~a:(a_class config.cls_text @ a_border @ a @ config.a_text)
        [ H.txt @@ String.concat "\n" l ]
    else (
      (* TODO: remove possible trailing '\r' *)
      let l = br_lines ~bold l in
      H.div ~a:(a_class config.cls_text @ a_border @ a @ config.a_text) l
    )
  in
  let rec to_html_summary b =
    match B.view b with
    | B.Empty ->
      (* Not really a case of unsupported summarization,
         but rather a request to not summarize. *)
      raise Summary_not_supported
    | B.Text { l; style } -> br_text_to_html ~l ~style ()
    | B.Pad (_, b) ->
      (* FIXME: not implemented yet *)
      to_html_summary b
    | B.Frame { sub = b; stretch = _ } ->
      H.span ~a:[ H.a_style "border:thin solid" ] [ to_html_summary b ]
    | B.Align { h = `Right; inner = b; v = _ } ->
      H.span ~a:[ H.a_class [ "align-right" ] ] [ to_html_summary b ]
    | B.Align { h = `Center; inner = b; v = _ } ->
      H.span ~a:[ H.a_class [ "center" ] ] [ to_html_summary b ]
    | B.Align { inner = b; _ } -> to_html_summary b
    | B.Grid (bars, a) ->
      (* TODO: support selected table styles. *)
      let a_border =
        if bars = `Bars then
          [ H.a_style "border:thin dotted" ]
        else
          []
      in
      let to_row a =
        let cols =
          Array.to_list a
          |> List.map (fun b ->
                 H.span
                   ~a:(a_class config.cls_col @ config.a_col @ a_border)
                   [ to_html_summary b ])
        in
        H.span ~a:a_border @@ sep_spans H.space cols
      in
      let rows = Array.to_list a |> List.map to_row in
      H.span @@ sep_spans (H.br ?a:None) rows
    | B.Anchor { id; inner } ->
      (match B.view inner with
      | B.Empty -> H.a ~a:[ H.a_id id ] []
      | _ -> raise Summary_not_supported)
    | B.Ext { key = _; ext = Embed_summary_html result } -> result
    | B.Ext { key = _; ext = Embed_link_html _ } -> raise Summary_not_supported
    | B.Ext { key = _; ext = Embed_html _ } -> raise Summary_not_supported
    | B.Ext { key; ext } ->
        (match Hashtbl.find_opt extensions_summary key with
        | Some handler -> handler config ext
        | None -> raise Summary_not_supported)
    | B.Tree _ | B.Link _ -> raise Summary_not_supported
  in
  let loop :
        'tags.
        (B.t ->
        ([< Html_types.flow5 > `Pre `Span `Div `Ul `Table `P ] as 'tags) html) ->
        B.t ->
        'tags html =
   fun fix b ->
    match B.view b with
    | B.Empty ->
      (H.div [] :> [< Html_types.flow5 > `Pre `Span `Div `P `Table `Ul ] html)
    | B.Text { l; style } when style.B.Style.preformatted ->
      v_text_to_html ~l ~style ()
    | B.Text { l; style } -> v_text_to_html ~l ~style ()
    | B.Pad (_, b) ->
      (* FIXME: not implemented yet *)
      fix b
    | B.Frame { sub = b; _ } ->
      H.div ~a:[ H.a_style "border:thin solid" ] [ fix b ]
    | B.Align { h = `Right; inner = b; v = _ } ->
      H.div ~a:[ H.a_class [ "align-right" ] ] [ fix b ]
    | B.Align { h = `Center; inner = b; v = _ } ->
      H.div ~a:[ H.a_class [ "center" ] ] [ fix b ]
    | B.Align { inner = b; _ } -> fix b
    | B.Grid (bars, a) ->
      let class_ =
        match bars with
        | `Bars -> "framed"
        | `None -> "non-framed"
      in
      let to_row a =
        Array.to_list a
        |> List.map (fun b ->
               H.td ~a:(a_class config.cls_col @ config.a_col) [ fix b ])
        |> fun x -> H.tr ~a:(a_class config.cls_row @ config.a_row) x
      in
      let rows = Array.to_list a |> List.map to_row in
      H.table ~a:(a_class (class_ :: config.cls_table) @ config.a_table) rows
    | B.Tree (_, b, l) ->
      let l = Array.to_list l in
      H.div [ fix b; H.ul (List.map (fun x -> H.li [ fix x ]) l) ]
    | B.Anchor _ -> assert false
    | B.Link _ -> assert false
    | B.Ext _ -> assert false
  in

  let rec to_html_rec b =
    match B.view b with
    | B.Tree (_, b, l) when config.tree_summary ->
      let l = Array.to_list l in
      let body = H.ul (List.map (fun x -> H.li [ to_html_rec x ]) l) in
      (try H.details (H.summary [ to_html_summary b ]) [ body ]
       with Summary_not_supported -> H.div [ to_html_rec b; body ])
    | B.Link { uri; inner } ->
      (try H.div [ H.a ~a:[ H.a_href uri ] [ to_html_nondet_rec inner ] ]
      with Link_not_supported ->
        H.div [ H.a ~a:[ H.a_href uri ] [ H.txt ("["^uri^"]") ];  to_html_rec inner ] )
    | B.Anchor { id; inner } ->
      (match B.view inner with
      | B.Empty -> H.a ~a:[ H.a_id id ] []
      | _ ->
        try H.a ~a:[ H.a_id id; H.a_href @@ "#" ^ id ] [ to_html_nondet_rec inner ]
        with Link_not_supported ->
          H.div [ H.a ~a:[ H.a_id id; H.a_href @@ "#" ^ id ] [ H.txt ("[#"^id^"]")] ; to_html_rec inner ])
    | B.Ext { key = _; ext = Embed_html result } -> result
    | B.Ext { key = _; ext = Embed_summary_html result } -> (result :> toplevel_html)
    | B.Ext { key; ext } ->
      (match Hashtbl.find_opt extensions_toplevel key with
      | Some handler -> handler config ext
      | None ->
        failwith @@ "PrintBox_html.to_html: missing extension handler for "
        ^ key)
    | _ -> loop to_html_rec b
  and to_html_nondet_rec b =
    match B.view b with
    | B.Empty -> H.span []
    | B.Text { l; style } -> v_text_to_html ~l ~style ()
    | B.Link { uri; inner } ->
      H.div [ H.a ~a:[ H.a_href uri ] [ to_html_nondet_rec inner ] ]
    | B.Ext { key = _; ext = Embed_link_html result } -> result
    | B.Ext { key = _; ext = Embed_summary_html _ } -> raise Link_not_supported
    | B.Ext { key = _; ext = Embed_html _ } -> raise Link_not_supported
    | B.Ext { key; ext } ->
        (match Hashtbl.find_opt extensions_link key with
        | Some handler -> handler config ext
        | None -> raise Link_not_supported)
    | _ -> loop to_html_nondet_rec b
  in
  to_html_rec, to_html_summary, to_html_nondet_rec

let to_html ?(config = Config.default) =
  let to_html_rec, _, _ = to_html_funs ~config in
  fun b -> H.div [ to_html_rec b ]

let to_summary_html ?(config = Config.default) =
  let _, to_html_summary, _ = to_html_funs ~config in
  to_html_summary

let to_link_html ?(config = Config.default) =
  let _, _, to_html_nondet_rec = to_html_funs ~config in
  to_html_nondet_rec

let to_string ?config b =
  Format.asprintf "@[%a@]@." (H.pp_elt ()) (to_html ?config b)

let to_string_indent ?config b =
  Format.asprintf "@[%a@]@." (H.pp_elt ~indent:true ()) (to_html ?config b)

let pp ?(flush = true) ?config ?indent () pp b =
  if flush then
    Format.fprintf pp "@[%a@]@." (H.pp_elt ?indent ()) (to_html ?config b)
  else
    Format.fprintf pp "@[%a@]" (H.pp_elt ?indent ()) (to_html ?config b)

let to_string_doc ?config b =
  let meta_str =
    "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"
  in
  let footer_str =
    "<script> [...document.querySelectorAll('p')].forEach(el => \
     el.addEventListener('click', () => el.nextSibling.style.display = \
     el.nextSibling.style.display === 'none' ? 'block' : 'none')); \
     [...document.querySelectorAll('ul ul')].forEach(el => el.style.display = \
     'none'); </script>"
  in
  Format.asprintf "<head>%s%s</head><body>@[%a@]%s</body>@." meta_str
    prelude_str (H.pp_elt ()) (to_html ?config b) footer_str
