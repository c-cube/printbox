(* This file is free software. See file "license" for more details. *)

(** {1 Extend {!PrintBox.t} with plots of scatter graphs and line graphs} *)

(** Specifies a layer of plotting to be rendered on a graph, where all layers share
    the same coordinate space. A coordinate pair has the horizontal position first. *)
type plot_spec =
  | Scatterplot of {
      points: (float * float) array;
      content: PrintBox.t;
    }  (** Places the [content] box at each of the [points] coordinates. *)
  | Scatterbag of { points: ((float * float) * PrintBox.t) array }
      (** For each element of [points], places the given box at the given coordinates. *)
  | Line_plot of {
      points: float array;
      content: PrintBox.t;
    }
      (** Places the [content] box at vertical coordinates [points],
          evenly horizontally spread. *)
  | Boundary_map of {
      callback: float * float -> bool;
      content_true: PrintBox.t;
      content_false: PrintBox.t;
    }
      (** At evenly and densely spread coordinates across the graph, places either
          [content_true] or [content_false], depending on the result of [callback]. *)
  | Map of { callback: float * float -> PrintBox.t }
      (** At evenly and densely spread coordinates across the graph, places the box
          returned by [callback]. *)
  | Line_plot_adaptive of {
      callback: float -> float;
      cache: (float, float) Hashtbl.t;
      content: PrintBox.t;
    }
      (** At evenly and densely spread horizontal coordinates, places the [content] box
          at the vertical coordinate returned by [callback] for the horizontal coordinate
          of the placement position. *)
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
(** A graph of plot layers, with a fixed rendering size but a coordinate window
    that adapts to the specified points. *)

val default_config : graph
(** A suggested configuration for plotting, with intended use:
   [Plot {default_config with specs = ...; ...}]. The default values are:
   [{ specs = []; x_label = "x"; y_label = "y"; size = 800, 800; no_axes = false; prec = 3 }] *)

type PrintBox.ext +=
  | Plot of graph
        (** PrintBox extension for plotting: scatterplots, linear graphs, decision boundaries...
            See {!graph} and {!plot_spec} for details. *)

val box : graph -> PrintBox.t
(** [box graph] is the same as [PrintBox.extension ~key:"Plot" (Plot graph)]. *)

val concise_float : (prec:int -> float -> string) ref
(** The conversion function for labeling axes. Defaults to [sprintf "%.*g"]. *)

val scale_size_for_text : (float * float) ref
(** To provide a unified experience across the text and html backends, we treat
    the size specification as measured in pixels, and scale it by [!scale_size_for_text]
    to get a size measured in characters. The default value is [(0.125, 0.05)]. *)
