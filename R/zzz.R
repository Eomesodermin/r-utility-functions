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

#' @rdname convert_genes
#' @export
convert.mouse.to.human <- convert_mouse_to_human

#' @rdname convert_genes
#' @export
convert.human.to.mouse <- convert_human_to_mouse

#' @rdname go_enrichment
#' @export
GO.function <- go_enrichment

#' @rdname umap_optimise
#' @export
UMAP.optimise <- umap_optimise

#' @rdname clean_volcano_data
#' @export
clean.data.volcano <- clean_volcano_data

#' @rdname colour_volcano_points
#' @export
colour.points.volcano <- colour_volcano_points

#' @rdname alpha_volcano_points
#' @export
alpha.points.volcano <- alpha_volcano_points

#' @rdname size_volcano_points
#' @export
size.points.volcano <- size_volcano_points

#' @rdname custom_enhanced_volcano
#' @export
custom.enhanced.volcano <- custom_enhanced_volcano
