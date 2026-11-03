#' Deprecated dot.case function names
#'
#' The package originally used dot.case names. They are kept so that existing
#' scripts keep working, but each call now warns once per session and forwards
#' to its snake_case replacement. Use the new name in new code.
#'
#' | Old name | Use instead |
#' |---|---|
#' | `makeTransparent()` | [make_transparent()] |
#' | `Get.batlow()` | [get_batlow()] |
#' | `calc.moving.average()` | [moving_average()] |
#' | `basic.heatmap()` | [basic_heatmap()] |
#' | `dendrogram()` | [dendrogram_samples()] |
#' | `convert.mouse.to.human()` | [convert_mouse_to_human()] |
#' | `convert.human.to.mouse()` | [convert_human_to_mouse()] |
#' | `GO.function()` | [go_enrichment()] |
#' | `UMAP.optimise()` | [umap_optimise()] |
#' | `clean.data.volcano()` | [clean_volcano_data()] |
#' | `colour.points.volcano()` | [colour_volcano_points()] |
#' | `alpha.points.volcano()` | [alpha_volcano_points()] |
#' | `size.points.volcano()` | [size_volcano_points()] |
#' | `custom.enhanced.volcano()` | [custom_enhanced_volcano()] |
#' | `sc.correlation()` | [sc_correlation()] |
#' | `correlation.heatmaps()` | [correlation_heatmaps()] |
#' | `download.TCGA.RNAseq()` | [download_tcga_rnaseq()] |
#' | `TCGA.OS()` | [tcga_survival()] |
#'
#' @param ... Passed to the replacement function.
#' @return The result of the replacement function.
#' @name legacy_aliases
#' @keywords internal
NULL

# Build a function that warns once and forwards to the exported replacement.
legacy_alias <- function(old, new) {
  force(old)
  force(new)
  function(...) {
    rlang::warn(
      paste0("`", old, "()` is deprecated; use `", new, "()` instead."),
      .frequency = "once", .frequency_id = paste0("usefulfunctions-", old)
    )
    getExportedValue("usefulfunctions", new)(...)
  }
}

#' @rdname legacy_aliases
#' @export
makeTransparent <- legacy_alias("makeTransparent", "make_transparent")

#' @rdname legacy_aliases
#' @export
Get.batlow <- legacy_alias("Get.batlow", "get_batlow")

#' @rdname legacy_aliases
#' @export
calc.moving.average <- legacy_alias("calc.moving.average", "moving_average")

#' @rdname legacy_aliases
#' @export
basic.heatmap <- legacy_alias("basic.heatmap", "basic_heatmap")

#' @rdname legacy_aliases
#' @export
dendrogram <- legacy_alias("dendrogram", "dendrogram_samples")

#' @rdname legacy_aliases
#' @export
convert.mouse.to.human <- legacy_alias("convert.mouse.to.human", "convert_mouse_to_human")

#' @rdname legacy_aliases
#' @export
convert.human.to.mouse <- legacy_alias("convert.human.to.mouse", "convert_human_to_mouse")

#' @rdname legacy_aliases
#' @export
GO.function <- legacy_alias("GO.function", "go_enrichment")

#' @rdname legacy_aliases
#' @export
UMAP.optimise <- legacy_alias("UMAP.optimise", "umap_optimise")

#' @rdname legacy_aliases
#' @export
clean.data.volcano <- legacy_alias("clean.data.volcano", "clean_volcano_data")

#' @rdname legacy_aliases
#' @export
colour.points.volcano <- legacy_alias("colour.points.volcano", "colour_volcano_points")

#' @rdname legacy_aliases
#' @export
alpha.points.volcano <- legacy_alias("alpha.points.volcano", "alpha_volcano_points")

#' @rdname legacy_aliases
#' @export
size.points.volcano <- legacy_alias("size.points.volcano", "size_volcano_points")

#' @rdname legacy_aliases
#' @export
custom.enhanced.volcano <- legacy_alias("custom.enhanced.volcano", "custom_enhanced_volcano")

#' @rdname legacy_aliases
#' @export
sc.correlation <- legacy_alias("sc.correlation", "sc_correlation")

#' @rdname legacy_aliases
#' @export
correlation.heatmaps <- legacy_alias("correlation.heatmaps", "correlation_heatmaps")

#' @rdname legacy_aliases
#' @export
download.TCGA.RNAseq <- legacy_alias("download.TCGA.RNAseq", "download_tcga_rnaseq")

#' @rdname legacy_aliases
#' @export
TCGA.OS <- legacy_alias("TCGA.OS", "tcga_survival")

