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
#' @param dims Principal components used for the embedding.
#' @param max.neigh Largest `n.neighbors` to try.
#' @param seed Random seed for reproducible embeddings.
#' @return Invisibly, the paths of the PDFs written.
#' @examples
#' \dontrun{
#' umap_optimise(pbmc_small)
#' }
#' @export
umap_optimise <- function(input.seurat, output.dir = "results/optimising_UMAP/",
                          init.min.dist = 0.001, init.neigh = 5,
                          min.dist.step = 2, neigh.step = 20,
                          dims = 1:20, max.neigh = 50, seed = 42) {
  require_pkg("Seurat", "umap_optimise()")
  if (min.dist.step <= 1) stop("`min.dist.step` must be greater than 1.", call. = FALSE)
  if (neigh.step <= 0) stop("`neigh.step` must be positive.", call. = FALSE)
  ensure_dir(output.dir)
  paths <- character()
  min_dist <- init.min.dist
  while (min_dist < 1) {
    for (n_neigh in seq(init.neigh, max.neigh, by = neigh.step)) {
      message("Calculating UMAP for min.dist = ", min_dist, " & n.neighbors = ", n_neigh)
      embedded <- Seurat::RunUMAP(object = input.seurat, reduction = "pca", dims = dims,
                                  umap.method = "uwot", n.neighbors = n_neigh,
                                  min.dist = min_dist, seed.use = seed, verbose = FALSE)
      plt <- Seurat::DimPlot(embedded, reduction = "umap", label = TRUE, label.size = 4) +
        ggplot2::ggtitle(paste0("UMAP min.dist = ", min_dist, " n = ", n_neigh)) +
        Seurat::NoLegend()
      path <- file.path(output.dir, paste0("UMAP_Min_dist_", min_dist, "_neighval_", n_neigh, ".pdf"))
      save_pdf(plt, path)
      paths <- c(paths, path)
    }
    min_dist <- min_dist * min.dist.step
  }
  invisible(paths)
}
