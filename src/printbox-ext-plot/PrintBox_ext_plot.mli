(* This file is free software. See file "license" for more details. *)

(** {1 Extend [PrintBox.t] with plots of scatter graphs and line graphs} *)

type plot_spec =
  | Scatterplot of {
      points: (float * float) array;
      pixel: string;
    }
  | Line_plot of {
      points: float array;
      pixel: string;
    }
  | Boundary_map of {
      callback: float * float -> bool;
      pixel_true: string;
      pixel_false: string;
    }
  | Line_plot_adaptive of {
      callback: float -> float;
      cache: (float, float) Hashtbl.t;
      pixel: string;
    }
[@@deriving sexp_of]

type graph = {
  specs: plot_spec list;
  x_label: string;
  y_label: string;
  size: int * int;
  no_axes: bool;
  prec: int;
}

val default_config : graph

type PrintBox.ext += Plot of graph
