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
(** A suggested configuration for plotting, with intended use:
   [Plot {default_config with specs = ...; ...}]. The default values are:
   [{ specs = []; x_label = "x"; y_label = "y"; size = 800, 800; no_axes = false; prec = 3 }] *)

type PrintBox.ext += Plot of graph

val concise_float : (prec:int -> float -> string) ref
(** The conversion function for labeling axes. Defaults to [sprintf "%.*g"]. *)

val scale_size_for_text : (float * float) ref
(** To provide a unified experience across the text and html backends, we treat
    the size specification as measured in pixels, and scale it by [!scale_size_for_text]
    to get a size measured in characters. The default value is [(0.125, 0.05)]. *)
