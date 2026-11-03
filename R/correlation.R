# Per-gene correlation of every row of `expr` against the row named `goi`.
# Returns a data frame of correlation, p-value and FDR, sorted by correlation.
correlate_with_gene <- function(expr, goi, method) {
  target <- expr[goi, ]
  cors <- vapply(rownames(expr), function(g) {
    suppressWarnings(stats::cor(expr[g, ], target, method = method))
  }, numeric(1))
  pvals <- vapply(rownames(expr), function(g) {
    suppressWarnings(tryCatch(stats::cor.test(expr[g, ], target, method = method)$p.value,
                              error = function(e) NA_real_))
  }, numeric(1))
  out <- data.frame(GeneID = rownames(expr), Cor.val = unname(cors), P.val = unname(pvals),
                    stringsAsFactors = FALSE)
  out <- out[!is.na(out$Cor.val), , drop = FALSE]
  out$FDR <- stats::p.adjust(out$P.val, method = "fdr")
  out <- out[order(out$Cor.val, decreasing = TRUE), , drop = FALSE]
  rownames(out) <- NULL
  out
}

#' Gene-gene correlation across single cells
#'
#' Correlates a gene of interest against all (sufficiently expressed) genes in a
#' normalised expression matrix, returning correlation, p-value and FDR.
#'
#' @param data.slot Numeric expression matrix (genes x cells), e.g. a downsampled
#'   Seurat `data` layer as a matrix.
#' @param goi Gene of interest (a rowname of `data.slot`).
#' @param remove.quantile Drop genes whose mean expression is in the lowest
#'   fraction before testing.
#' @param output.tables Directory to write the results CSV into (created if
#'   needed). Use `NULL` to skip writing.
#' @param debug.mode Deprecated and ignored.
#' @param method Correlation method: "pearson" (default), "spearman" or "kendall".
#' @return A data frame with `GeneID`, `Cor.val`, `P.val` and `FDR`, sorted by
#'   decreasing correlation. Genes with undefined correlation (zero variance) are
#'   dropped.
#' @examples
#' m <- matrix(rnorm(50), nrow = 5,
#'             dimnames = list(paste0("g", 1:5), paste0("c", 1:10)))
#' sc_correlation(m, goi = "g1", output.tables = NULL)
#' @export
sc_correlation <- function(data.slot, goi = "NKG7", remove.quantile = 0.3,
                           output.tables = "results/tables/Correlation_analysis/",
                           debug.mode = FALSE,
                           method = c("pearson", "spearman", "kendall")) {
  method <- match.arg(method)
  data.slot <- as.matrix(data.slot)
  if (!goi %in% rownames(data.slot)) {
    stop("`goi` (", goi, ") is not a rowname of `data.slot`.", call. = FALSE)
  }
  cutoff <- stats::quantile(rowMeans(data.slot), probs = remove.quantile)
  kept <- data.slot[rowMeans(data.slot) >= cutoff | rownames(data.slot) == goi, , drop = FALSE]
  result <- correlate_with_gene(kept, goi, method)
  if (!is.null(output.tables)) {
    ensure_dir(output.tables)
    utils::write.csv(result, file.path(output.tables, paste0("Correlation_values_", goi, ".csv")),
                     row.names = FALSE)
  }
  result
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
#' @param output.dir Directory to write the PDFs into (created if needed). Use
#'   `NULL` to skip writing.
#' @return Invisibly, a list with the `up` and `down` heatmap plots.
#' @examples
#' \dontrun{
#' correlation_heatmaps(small_seurat, cor_df, up.n = 20, goi = "NKG7")
#' }
#' @export
correlation_heatmaps <- function(seurat.object, correlation.df, up.n = 20, dn.n = 20, goi = "NKG7",
                                 output.dir = "results/figures/Correlation_analysis/") {
  require_pkg("Seurat", "correlation_heatmaps()")
  significant <- correlation.df[!is.na(correlation.df$FDR) & correlation.df$FDR < 0.05, , drop = FALSE]
  ranked <- significant[order(significant$Cor.val, decreasing = TRUE), ]
  up_genes <- unique(c(goi, utils::head(ranked$GeneID, up.n)))
  down_genes <- unique(c(goi, utils::tail(ranked$GeneID, dn.n)))
  heatmap_for <- function(genes) {
    Seurat::DoHeatmap(seurat.object, features = genes, angle = 90, size = 3, raster = FALSE) +
      scico::scale_fill_scico(palette = "batlow", direction = 1, na.value = "white")
  }
  plots <- list(up = heatmap_for(up_genes), down = heatmap_for(down_genes))
  if (!is.null(output.dir)) {
    ensure_dir(output.dir)
    save_pdf(plots$up, file.path(output.dir, paste0("Heatmap_top", up.n, "_corr_genes.pdf")))
    save_pdf(plots$down, file.path(output.dir, paste0("Heatmap_bottom", dn.n, "_corr_genes.pdf")))
  }
  invisible(plots)
}

#' Plot a correlation ranking
#'
#' Line plot of ranked correlation values from [sc_correlation()], highlighting a
#' gene of interest, plus a zoom on the top-correlated genes.
#'
#' @param cor.df Output of [sc_correlation()].
#' @param output.dir Directory to write the PDFs into (created if needed). Use
#'   `NULL` to skip writing.
#' @param goi Gene(s) of interest to highlight.
#' @param top.n.val Number of top-correlated genes to show in the zoom plot.
#' @return Invisibly, a list with the `ranking` and `top` ggplots.
#' @examples
#' m <- matrix(rnorm(400), nrow = 20,
#'             dimnames = list(paste0("g", 1:20), paste0("c", 1:20)))
#' cor_df <- sc_correlation(m, goi = "g1", remove.quantile = 0, output.tables = NULL)
#' plot_correlation(cor_df, output.dir = NULL, goi = "g1", top.n.val = 5)
#' @importFrom rlang .data
#' @export
plot_correlation <- function(cor.df, output.dir = "output/figures/", goi = "NKG7", top.n.val = 30) {
  ranked <- cor.df[order(cor.df$Cor.val, decreasing = TRUE), , drop = FALSE]
  ranked$rank <- seq_len(nrow(ranked))
  top <- utils::head(ranked, top.n.val)
  highlighted <- ranked[ranked$GeneID %in% goi, , drop = FALSE]

  ranking <- ggplot2::ggplot(ranked, ggplot2::aes(x = .data$Cor.val, y = .data$rank)) +
    ggplot2::geom_line() +
    ggplot2::geom_line(data = top, colour = "blue", linewidth = 1) +
    ggplot2::geom_point(data = highlighted) +
    ggplot2::geom_text(data = highlighted, ggplot2::aes(label = .data$GeneID), vjust = 1.5) +
    ggplot2::scale_y_reverse() +
    ggplot2::labs(x = "Correlation", y = "Rank") +
    ggplot2::theme_classic()
  zoom <- ggplot2::ggplot(top, ggplot2::aes(x = .data$Cor.val, y = .data$rank)) +
    ggplot2::geom_line(colour = "blue", linewidth = 1) +
    ggplot2::geom_point() +
    ggplot2::geom_text(ggplot2::aes(label = .data$GeneID), hjust = -0.1) +
    ggplot2::scale_y_reverse() +
    ggplot2::labs(x = "Correlation", y = "Rank") +
    ggplot2::theme_classic()
  plots <- list(ranking = ranking, top = zoom)
  if (!is.null(output.dir)) {
    ensure_dir(output.dir)
    save_pdf(ranking, file.path(output.dir, "correlation.pdf"), width = 5, height = 9)
    save_pdf(zoom, file.path(output.dir, paste0("correlation_top_", top.n.val, ".pdf")), width = 3, height = 6)
  }
  invisible(plots)
}
