#' Optimise UMAP hyper-parameters for a Seurat object
#'
#' Sweeps `min.dist` and `n.neighbors`, saving a UMAP plot PDF for each
#' combination so the best-looking embedding can be chosen.
#'
#' @param input.seurat A Seurat object with a `pca` reduction.
#' @param output.dir Directory to write the PDFs into (created if needed).
#' @param init.min.dist Starting `min.dist` (sensible range 0.001-0.5).
#' @param init.neigh Starting `n.neighbors` (sensible range 5-50).
#' @param min.dist.step Multiplicative step for `min.dist`.
#' @param neigh.step Additive step for `n.neighbors`.
#' @return Invisibly `NULL`; called for the PDFs it writes.
#' @examples
#' \dontrun{
#' umap_optimise(pbmc_small)
#' }
#' @export
umap_optimise <- function(input.seurat, output.dir = "results/optimising_UMAP/",
                          init.min.dist = 0.001, init.neigh = 5,
                          min.dist.step = 2, neigh.step = 20) {
  if (!requireNamespace("Seurat", quietly = TRUE)) {
    stop("Package 'Seurat' is required for umap_optimise(); install it.", call. = FALSE)
  }
  if (!dir.exists(output.dir)) dir.create(output.dir, recursive = TRUE)
  min.dist.val <- init.min.dist
  while (min.dist.val < 1) {
    n.neigh.val <- init.neigh
    while (n.neigh.val <= 50) {
      message("Calculating UMAP for min.dist = ", min.dist.val,
              " & n.neighbors = ", n.neigh.val)
      temp <- Seurat::RunUMAP(object = input.seurat, reduction = "pca", dims = 1:20,
                              umap.method = "uwot", n.neighbors = n.neigh.val,
                              min.dist = min.dist.val, seed.use = 42)
      print(Seurat::UMAPPlot(object = temp, label = TRUE, label.size = 4) +
              ggplot2::ggtitle(paste0("UMAP min.dist = ", min.dist.val,
                                      " n = ", n.neigh.val)) +
              Seurat::NoLegend())
      grDevices::dev.copy(grDevices::pdf,
        paste0(output.dir, "UMAP_Min_dist_", min.dist.val, "_neighval_", n.neigh.val, ".pdf"))
      grDevices::dev.off()
      n.neigh.val <- n.neigh.val + neigh.step
    }
    min.dist.val <- min.dist.val * min.dist.step
  }
  invisible(NULL)
}
