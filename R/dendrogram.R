#' Sample dendrogram
#'
#' Hierarchically clusters the samples (columns of `data.matrix`) and writes a
#' dendrogram to PDF; optionally also a phylogeny-style plot.
#'
#' @param data.matrix Numeric matrix (features x samples).
#' @param hc_metric.var Distance metric for clustering (e.g. `"euclidean"`).
#' @param hc_method.var Agglomeration method (e.g. `"ward.D2"`).
#' @param type.var Optional [ape::plot.phylo()] layout (`"phylogram"`, `"fan"`,
#'   `"unrooted"`, `"radial"`); if `NULL` only the standard dendrogram is drawn.
#' @param output.dir Directory to write the PDF(s) into (created if needed). Use
#'   `NULL` to skip writing.
#' @return Invisibly, a list with the `hclust` object and the dendrogram `plot`.
#' @examples
#' \dontrun{
#' dendrogram_samples(my_matrix, type.var = "unrooted")
#' }
#' @export
dendrogram_samples <- function(data.matrix, hc_metric.var = "euclidean",
                               hc_method.var = "ward.D2", type.var = NULL,
                               output.dir = "results/figures/") {
  require_pkg("factoextra", "dendrogram_samples()")
  distances <- factoextra::get_dist(scale(t(data.matrix)), method = hc_metric.var)
  res.hc <- stats::hclust(distances, method = hc_method.var)
  if (!is.null(type.var)) require_pkg("ape", "dendrogram_samples(type.var = )")
  plt <- factoextra::fviz_dend(stats::as.dendrogram(res.hc), show_labels = TRUE,
        color_labels_by_k = FALSE, type = "rectangle", rect = TRUE, rect_border = "black",
        rect_lty = "solid", rect_lwd = 1, main = "Sample Dendrogram",
        xlab = paste0("Dist = ", hc_metric.var, " & Clust = ", hc_method.var), cex = 0.6)
  if (!is.null(output.dir)) {
    ensure_dir(output.dir)
    save_pdf(plt, file.path(output.dir, "Dendrogram.pdf"), width = 7, height = 7)
    if (!is.null(type.var)) {
      grDevices::pdf(file.path(output.dir, paste0("Dendrogram_", type.var, ".pdf")))
      graphics::plot(ape::as.phylo(res.hc), type = type.var, cex = 0.6, no.margin = TRUE)
      grDevices::dev.off()
    }
  }
  invisible(list(hclust = res.hc, plot = plt))
}
