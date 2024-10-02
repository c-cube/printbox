
## 0.12

- Remove fallback to and dependency on `printbox-html` from `printbox-md` (@lukstafi)
- introduce notion of extensions (@lukstafi)
- add `printbox-ext-plot` extension for text and HTML plots (@lukstafi)
- feat: add `?stretch` param to `frame`

- fix #45, problem with nested frames

## 0.11

- Anchors (with self-links if inner is non-empty)
- Support `hlist` and `vlist` inside summaries Implemented as poor-man's support of arbitrary grids.

## 0.10

- Fixes #10: ANSI encoded hyperlinks for printbox-text
- Fixes #39: more compact markdown output Remove double empty lines after `</details>`.
- More compact html output: no empty class annotations
- Provide context for the `line` exception

## 0.9

- fix `PrintBox.text` will correctly handle newlines
- new `printbox-md` backend, generating markdown (by @lukstafi)

## 0.8

- require dune 3.0
- Fixes #28: no misleading uptick for empty tree nodes
- HTML: Allow frames in the summary / tree header
- Output frames as div borders in HTML

## 0.7

- move to 4.08 as lower bound
- `preformatted` text style instead of global setting
- PrintBox_html:
  * Optionally wrap text with the `<pre>` HTML element
  * Output text consistently as `<span>`, not `<div>`
  * Use `<details><summary>` for collapsible trees

- fix: Tree connectors touching frames (#26)

## 0.6.1

- compat with dune 3

## 0.6

- move text rendering into a new printbox-text library
- Changing visuals for hlines and vlines connections, and tree structure
  using unicode characters for box borders

## 0.5

- reenable mdx for tests
- custom classes/attributes for html translation in `PrintBox_html`
- add `link` case
- examples: add lambda.ml

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
