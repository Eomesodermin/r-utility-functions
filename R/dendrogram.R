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
#' @param output.dir Directory to write the PDF(s) into (created if needed).
#' @return Invisibly `NULL`; called for the PDF file(s) it writes.
#' @examples
#' \dontrun{
#' dendrogram_samples(my_matrix, type.var = "unrooted")
#' }
#' @export
dendrogram_samples <- function(data.matrix, hc_metric.var = "euclidean",
                               hc_method.var = "ward.D2", type.var = NULL,
                               output.dir = "results/figures/") {
  if (!requireNamespace("factoextra", quietly = TRUE)) {
    stop("Package 'factoextra' is required for dendrogram_samples(); install it.",
         call. = FALSE)
  }
  if (!dir.exists(output.dir)) dir.create(output.dir, recursive = TRUE)
  graphics::par(mar = c(6, 4.1, 4.1, 2.1))
  res.hc <- factoextra::eclust(t(data.matrix), stand = TRUE, FUNcluster = "hclust",
                               hc_metric = hc_metric.var, hc_method = hc_method.var,
                               k = 1, verbose = TRUE, graph = FALSE)
  x <- stats::as.dendrogram(res.hc)
  grDevices::pdf(paste0(output.dir, "Dendrogram.pdf"))
  print(factoextra::fviz_dend(x, show_labels = TRUE, color_labels_by_k = FALSE,
        type = "rectangle", rect = TRUE, rect_border = "black", rect_lty = "solid",
        rect_lwd = 1, main = "Sample Dendrogram",
        xlab = paste0("Dist = ", hc_metric.var, " & Clust = ", hc_method.var),
        cex = 0.6))
  grDevices::dev.off()
  if (!is.null(type.var)) {
    if (!requireNamespace("ape", quietly = TRUE)) {
      stop("Package 'ape' is required for `type.var` plots; install it.", call. = FALSE)
    }
    grDevices::pdf(paste0(output.dir, "Dendrogram_", type.var, ".pdf"))
    print(graphics::plot(ape::as.phylo(res.hc), type = type.var, cex = 0.6,
                         no.margin = TRUE))
    grDevices::dev.off()
  }
  invisible(NULL)
}
