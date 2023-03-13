
let b =
  let uid = ref 0 in
  let id() = incr uid; "["^Int.to_string !uid^"]" in
  let (!) v = `Subtree_with_ID (id(), `Text v) in
  let (+) x y = `Subtree_with_ID (id(), `Tree (`Text "+", [x; y])) in
  let ( * ) x y = `Subtree_with_ID (id(), `Tree (`Text "*", [x; y])) in
  let (/) x y = `Subtree_with_ID (id(), `Tree (`Text "/", [x; y])) in
  let (~-) x = `Subtree_with_ID (id(), `Tree (`Text "-", [x])) in
  let (-) x y = `Subtree_with_ID (id(), `Tree (`Text "-", [x; y])) in
  let f x = `Subtree_with_ID (id(), `Tree (`Text "f", [x])) in
  let a = !"a" in
  let b = !"b" in
  let c =  a + b in
  let d = a * b + b * b * b in
  let c = c + c + !"1" in
  let c = c + !"1" + c + ~-a in
  let d = d + d * !"2" + f (b + a) in
  let d = d + !"3" * d + f (b - a) in
  let e = c - d in
  let f = e * e in
  let g = f / !"2" in
  let g = g + !"10" / f in
  PrintBox.Simple.to_box_centered @@ PrintBox.Simple.reformat_dag 9 g

let () = print_endline @@ PrintBox_text.to_string b
