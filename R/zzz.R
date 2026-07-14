# Deprecated legacy aliases (dot.case) -------------------------------------
# Kept so existing scripts keep working; new code should use the snake_case
# names. In zzz.R so every function is defined before these bindings are made.

#' @rdname make_transparent
#' @export
makeTransparent <- make_transparent

#' @rdname get_batlow
#' @export
Get.batlow <- get_batlow

#' @rdname moving_average
#' @export
calc.moving.average <- moving_average

#' @rdname basic_heatmap
#' @export
basic.heatmap <- basic_heatmap

#' @rdname dendrogram_samples
#' @export
dendrogram <- dendrogram_samples
