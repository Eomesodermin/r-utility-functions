# Internal correlation helpers (adapted from M. Hoelzel).
probe_cor <- function(em, gp, method = "pearson") {
  apply(em, 1, stats::cor, em[gp, ], method = method)
}
probe_cor_test <- function(em, gp, method = "pearson") {
  apply(em, 1, stats::cor.test, em[gp, ], method = method)
}

#' Gene-gene correlation across single cells
#'
#' Correlates a gene of interest against all (sufficiently expressed) genes in a
#' normalised expression matrix, returning correlation, p-value and FDR.
#'
#' @param data.slot Numeric expression matrix (genes x cells), e.g. a downsampled
#'   Seurat `data` slot as a matrix.
#' @param goi Gene of interest (a rowname of `data.slot`).
#' @param remove.quantile Drop the lowest-expressed fraction of genes before testing.
#' @param output.tables Directory to write the results CSV into (created if needed).
#' @param debug.mode Unused; retained for backwards compatibility.
#' @return A data frame with `GeneID`, `Cor.val`, `P.val` and `FDR`.
#' @examples
#' m <- matrix(rnorm(50), nrow = 5,
#'             dimnames = list(paste0("g", 1:5), paste0("c", 1:10)))
#' sc_correlation(m, goi = "g1", output.tables = tempfile("cor"))
#' @export
sc_correlation <- function(data.slot, goi = "NKG7", remove.quantile = 0.3,
                           output.tables = "results/tables/Correlation_analysis/",
                           debug.mode = FALSE) {
  if (!dir.exists(output.tables)) dir.create(output.tables, recursive = TRUE)
  q.val <- stats::quantile(rowMeans(data.slot), probs = remove.quantile)
  filt.data <- data.slot[rowMeans(data.slot) >= q.val, ]
  cor.res <- as.data.frame(sort(probe_cor(filt.data, gp = goi), decreasing = TRUE))
  colnames(cor.res) <- "Cor.val"
  pv <- probe_cor_test(filt.data, gp = goi)
  pv <- unlist(sapply(pv, "[", "p.value"))
  names(pv) <- gsub(".p.value", "", names(pv))
  pv <- as.data.frame(sort(pv, decreasing = FALSE)); colnames(pv) <- "P.val"
  cor.df <- merge(cor.res, pv, by = "row.names")
  colnames(cor.df)[1] <- "GeneID"
  cor.df$FDR <- stats::p.adjust(cor.df$P.val, method = "fdr")
  utils::write.csv(cor.df, paste0(output.tables, "Correlation_values_", goi, ".csv"))
  cor.df
}

#' Heatmaps of top correlated genes
#'
#' Draws Seurat heatmaps of the most positively and negatively correlated genes
#' from [sc_correlation()], using the batlow palette.
#'
#' @param seurat.object A Seurat object (idents/assay pre-set, ideally downsampled).
#' @param correlation.df Output of [sc_correlation()].
#' @param up.n,dn.n Number of up / down correlated genes to show.
#' @param goi Gene of interest.
#' @param output.dir Directory to write the PDFs into.
#' @return Invisibly `NULL`; called for the PDFs it writes.
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @examples
#' \dontrun{
#' correlation_heatmaps(small_seurat, cor_df, up.n = 20, goi = "NKG7")
#' }
#' @export
correlation_heatmaps <- function(seurat.object, correlation.df, up.n = 20,
                                 dn.n = 20, goi = "NKG7",
                                 output.dir = "results/figures/Correlation_analysis/") {
  if (!requireNamespace("Seurat", quietly = TRUE)) {
    stop("Package 'Seurat' is required for correlation_heatmaps(); install it.", call. = FALSE)
  }
  if (!dir.exists(output.dir)) dir.create(output.dir, recursive = TRUE)
  up.genes <- correlation.df %>% dplyr::filter(.data$FDR < 0.05) %>%
    dplyr::top_n(up.n, .data$Cor.val) %>% dplyr::pull(.data$GeneID)
  up.genes <- unique(c(goi, up.genes))
  print(Seurat::DoHeatmap(seurat.object, features = up.genes, angle = 90, size = 3,
                          raster = FALSE) +
        scico::scale_fill_scico(palette = "batlow", direction = 1, na.value = "white"))
  grDevices::dev.copy(grDevices::pdf, paste0(output.dir, "Heatmap_top", up.n, "_corr_genes.pdf"))
  grDevices::dev.off()
  dn.genes <- correlation.df %>% dplyr::filter(.data$FDR < 0.05) %>%
    dplyr::top_n(-dn.n, .data$Cor.val) %>% dplyr::pull(.data$GeneID)
  dn.genes <- unique(c(goi, dn.genes))
  print(Seurat::DoHeatmap(seurat.object, features = dn.genes) +
        scico::scale_fill_scico(palette = "batlow", direction = 1, na.value = "white"))
  grDevices::dev.copy(grDevices::pdf, paste0(output.dir, "Heatmap_bottom", dn.n, "_corr_genes.pdf"))
  grDevices::dev.off()
  invisible(NULL)
}

#' Plot a correlation ranking
#'
#' Line plot of ranked correlation values from [sc_correlation()], highlighting a
#' gene of interest and the top hits.
#'
#' @param cor.df Output of [sc_correlation()].
#' @param output.dir Directory to write the PDFs into.
#' @param goi Gene(s) of interest to highlight.
#' @param top.n.val Number of top-correlated genes to inset.
#' @return Invisibly `NULL`; called for the PDFs it writes.
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @examples
#' \dontrun{
#' plot_correlation(cor_df, goi = "NKG7", top.n.val = 30)
#' }
#' @export
plot_correlation <- function(cor.df, output.dir = "output/figures/",
                             goi = "NKG7", top.n.val = 30) {
  if (!dir.exists(output.dir)) dir.create(output.dir, recursive = TRUE)
  ordered.cor <- cor.df %>% dplyr::arrange(dplyr::desc(.data$Cor.val))
  ordered.cor$Ypos <- seq(nrow(ordered.cor), 1)
  top.corr <- ordered.cor[1:top.n.val, ]
  grDevices::pdf(paste0(output.dir, "correlation.pdf"), width = 5, height = 9)
  graphics::plot(ordered.cor$Cor.val, ordered.cor$Ypos, type = "l")
  for (i in seq_along(goi)) {
    sel <- ordered.cor$GeneID == goi[i]
    graphics::points(ordered.cor$Cor.val[sel], ordered.cor$Ypos[sel])
    graphics::text(ordered.cor$Cor.val[sel], ordered.cor$Ypos[sel], labels = goi[i], pos = 1)
  }
  graphics::lines(top.corr$Cor.val, max(top.corr$Ypos):min(top.corr$Ypos), lwd = 2, col = "blue")
  grDevices::dev.off()
  grDevices::pdf(paste0(output.dir, "correlation_top_", top.n.val, ".pdf"), width = 3, height = 6)
  graphics::plot(top.corr$Cor.val, max(top.corr$Ypos):min(top.corr$Ypos), type = "l",
                 xlim = c(0.1, 1), col = "blue", lwd = 2)
  graphics::points(top.corr$Cor.val, max(top.corr$Ypos):min(top.corr$Ypos), pch = 20)
  graphics::text(top.corr$Cor.val, max(top.corr$Ypos):min(top.corr$Ypos), top.corr$GeneID, pos = 4)
  grDevices::dev.off()
  invisible(NULL)
}
