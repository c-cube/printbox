# PrintBox [![Build Status](https://travis-ci.org/c-cube/printbox.svg?branch=master)](https://travis-ci.org/c-cube/printbox)

Allows to print nested boxes, lists, arrays, tables in several formats,
including:

- text (assuming monospace font)
- HTML (using [tyxml](https://github.com/ocsigen/tyxml/) )
- LaTeX (*not implemented yet*)


## Documentation

See https://c-cube.github.io/printbox/

## Build

Ideally, use [opam](http://opam.ocaml.org/):

```sh non-deterministic=command
$ opam install printbox
```

Manually:

```sh non-deterministic=command
$ make install
```

## A few examples

<details>

#### importing the module

```ocaml
# #require "printbox";;

# module B = PrintBox;;
module B = PrintBox
```

#### simple box

```ocaml
# let box = B.(hlist [ text "hello"; text "world"; ]);;
val box : B.t = <abstr>

# PrintBox_text.output stdout box;;
hello|world
- : unit = ()
```

#### less simple boxes

```ocaml
# let box =
  B.(hlist
  [ text "I love\nto\npress\nenter";
    grid_text [| [|"a"; "bbb"|];
    [|"c"; "hello world"|] |]
  ])
  |> B.frame;;
val box : B.t = <abstr>

# PrintBox_text.output stdout box;;
+--------------------+
|I love|a|bbb        |
|to    |-+-----------|
|press |c|hello world|
|enter | |           |
+--------------------+
- : unit = ()
```

#### printing a table

```ocaml
# let square n =
  (* function to make a square *)
  Array.init n
    (fun i -> Array.init n (fun j -> B.sprintf "(%d,%d)" i j))
  |> B.grid ;;
val square : int -> B.t = <fun>

# let sq = square 5;;
val sq : B.t = <abstr>
# PrintBox_text.output stdout sq;;
(0,0)|(0,1)|(0,2)|(0,3)|(0,4)
-----+-----+-----+-----+-----
(1,0)|(1,1)|(1,2)|(1,3)|(1,4)
-----+-----+-----+-----+-----
(2,0)|(2,1)|(2,2)|(2,3)|(2,4)
-----+-----+-----+-----+-----
(3,0)|(3,1)|(3,2)|(3,3)|(3,4)
-----+-----+-----+-----+-----
(4,0)|(4,1)|(4,2)|(4,3)|(4,4)
- : unit = ()
```

#### frame

Why not put a frame around this? That's easy.

```ocaml
# let sq2 = square 3 |> B.frame ;;
val sq2 : B.t = <abstr>

# PrintBox_text.output stdout sq2;;
+-----------------+
|(0,0)|(0,1)|(0,2)|
|-----+-----+-----|
|(1,0)|(1,1)|(1,2)|
|-----+-----+-----|
|(2,0)|(2,1)|(2,2)|
+-----------------+
- : unit = ()
```

> +-----------------+
> |(0,0)|(0,1)|(0,2)|
> |-----------------|
> |(1,0)|(1,1)|(1,2)|
> |-----------------|
> |(2,0)|(2,1)|(2,2)|
> +-----------------+- : unit = ()

#### tree

We can also create trees and display them using indentation:

```ocaml
let tree =
  B.tree (B.text "root")
    [ B.tree (B.text "a") [B.text "a1\na1"; B.text "a2\na2\na2"];
      B.tree (B.text "b") [B.text "b1\nb1"; B.text "b2"; B.text "b3"];
    ];;

PrintBox_text.output stdout tree;;
```
>  root
>  `+- a
>   |  `+- a1
>   |   |  a1
>   |   +- a2
>   |      a2
>   |      a2
>   +- b
>      `+- b1
>       |  b1
>       +- b2
>       +- b3

#### HTML output (with `tyxml`)

```ocaml
# #require "printbox.html";;

# let out = open_out "/tmp/foo.html";;
val out : out_channel = <abstr>
# output_string out (PrintBox_html.to_string_doc (square 5));;
- : unit = ()
```

which prints some HTML in the file [foo.html](docs/foo.html).
Note that trees are printed in HTML using nested lists, and
that `PrintBox_html.to_string_doc` will insert some javascript to
make sub-lists fold/unfold on click (this is useful to display very large
trees compactly and exploring them incrementally).

</details>
