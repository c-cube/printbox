val pp :
  tables:[`Text | `Html] -> foldable_trees:bool -> Format.formatter ->
    PrintBox.t -> unit

val to_string :
  tables:[`Text | `Html] -> foldable_trees:bool -> PrintBox.t -> string
