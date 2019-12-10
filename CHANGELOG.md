# Changes

## 0.4

- remove `<p>` in rendering text to html
- add `grid_map_l` and `v_record`
- add another test

## 0.3

- improve code readability in text rendering
- add `align` and `center`
- add basic styling for text (ansi codes/html styles)
- add `printbox_unicode` for setting up proper unicode printing
- add `grid_l`, `grid_text_l`, and `record` helpers

- use a more accurate length estimate for unicode, add test
- remove mdx as a test dep
- fix rendering bugs related to align right, and padding

## 0.2

- make the box type opaque, with a view function
- require OCaml 4.03

- add `PrintBox_text.pp`
- expose a few new functions to build boxes
- change `Text` type, work on string slices when rendering

- automatic testing using dune and mdx
- migrate to dune and opam 2

## 0.1

initial release
