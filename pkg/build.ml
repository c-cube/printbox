#!/usr/bin/env ocaml

#directory "pkg";;
#use "topkg.ml";;

let html = Env.bool "html"

let () =
  Pkg.describe "printbox" ~builder:(`OCamlbuild [])
    [ Pkg.lib "pkg/META"
    ; Pkg.lib ~exts:Exts.library "src/printbox"
    ; Pkg.lib ~exts:Exts.interface "src/PrintBox"
    ; Pkg.lib ~exts:Exts.interface "src/PrintBox_text"
    ; Pkg.lib ~exts:Exts.library ~cond:html "src/html/printbox_html"
    ; Pkg.lib ~exts:Exts.interface "src/html/PrintBox_html"
    ; Pkg.doc "README.md"
    ]


