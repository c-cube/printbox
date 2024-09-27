(* This file is free software. See file "license" for more details. *)

(** {1 Extend {!PrintBox.t} with plots of scatter graphs and line graphs} *)

type plot_spec =
  | Scatterplot of {
      points: (float * float) array;
      content: PrintBox.t;
    }
  | Scatterbag of { points: ((float * float) * PrintBox.t) array }
  | Line_plot of {
      points: float array;
      content: PrintBox.t;
    }
  | Boundary_map of {
      callback: float * float -> bool;
      content_true: PrintBox.t;
      content_false: PrintBox.t;
    }
  | Map of { callback: float * float -> PrintBox.t }
  | Line_plot_adaptive of {
      callback: float -> float;
      cache: (float, float) Hashtbl.t;
      content: PrintBox.t;
    }
[@@deriving sexp_of]

type graph = {
  specs: plot_spec list;
      (** Earlier plots in the list take precedence: in case of overlap, their contents
          are on top. For HTML, we ensure that framed boxes and grids with bars are opaque. *)
  x_label: string;  (** Horizontal axis label. *)
  y_label: string;  (** Vertical axis label. *)
  size: int * int;
      (** Size of the graphing area in pixels. Scale for characters is configured by
          {!scale_size_for_text}. *)
  no_axes: bool;
      (** If true, only the graphing area is output (skipping the axes box). *)
  prec: int;  (** Precision for numerical labels on axes. *)
}

val default_config : graph
(** A suggested configuration for plotting, with intended use:
   [Plot {default_config with specs = ...; ...}]. The default values are:
   [{ specs = []; x_label = "x"; y_label = "y"; size = 800, 800; no_axes = false; prec = 3 }] *)

type PrintBox.ext +=
  | Plot of graph
        (** PrintBox extension for plotting: scatterplots, linear graphs, decision boundaries...
            See {!graph} and {!plot_spec} for details. *)

val concise_float : (prec:int -> float -> string) ref
(** The conversion function for labeling axes. Defaults to [sprintf "%.*g"]. *)

val scale_size_for_text : (float * float) ref
(** To provide a unified experience across the text and html backends, we treat
    the size specification as measured in pixels, and scale it by [!scale_size_for_text]
    to get a size measured in characters. The default value is [(0.125, 0.05)]. *)
