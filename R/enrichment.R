#' Gene Ontology over-representation analysis
#'
#' Runs a GO over-representation test (via [clusterProfiler::enrichGO()]) on the
#' top-ranked genes of a marker table, and either plots the top terms or returns
#' the full result.
#'
#' @param markers Data frame with a `gene` (SYMBOL) column and an `FDR` column.
#' @param topn Number of top genes (by `FDR`) to test.
#' @param org Either `"human"` or `"mouse"`.
#' @param title.var Plot title.
#' @param plot If `TRUE`, return a ggplot of the top terms; if `FALSE`, return the
#'   `enrichResult` object.
#' @param ontology.type GO ontology to test: `"BP"`, `"MF"`, or `"CC"`.
#' @param ... Further arguments passed to [clusterProfiler::enrichGO()].
#' @return A ggplot (if `plot = TRUE`) or a clusterProfiler `enrichResult`.
#' @import ggplot2
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @examples
#' \dontrun{
#' go_enrichment(my_markers, org = "human", ontology.type = "BP")
#' }
#' @export
go_enrichment <- function(markers, topn = 1000, org = c("human", "mouse"),
                          title.var = "", plot = TRUE, ontology.type = "BP", ...) {
  org <- match.arg(org)
  if (!requireNamespace("clusterProfiler", quietly = TRUE)) {
    stop("Package 'clusterProfiler' (Bioconductor) is required for go_enrichment().",
         call. = FALSE)
  }
  gene_list <- markers %>%
    dplyr::arrange(.data$FDR) %>%
    utils::head(topn) %>%
    dplyr::pull(.data$gene)
  if (org == "human") {
    if (!requireNamespace("org.Hs.eg.db", quietly = TRUE)) {
      stop("Package 'org.Hs.eg.db' (Bioconductor) is required for org = 'human'.", call. = FALSE)
    }
    db <- org.Hs.eg.db::org.Hs.eg.db
  } else {
    if (!requireNamespace("org.Mm.eg.db", quietly = TRUE)) {
      stop("Package 'org.Mm.eg.db' (Bioconductor) is required for org = 'mouse'.", call. = FALSE)
    }
    db <- org.Mm.eg.db::org.Mm.eg.db
  }
  res <- clusterProfiler::enrichGO(gene = gene_list, OrgDb = db,
                                   ont = ontology.type, keyType = "SYMBOL", ...)
  if (!plot) return(res)
  df <- tibble::as_tibble(res@result) %>%
    dplyr::arrange(.data$p.adjust) %>%
    utils::head(10) %>%
    dplyr::mutate(Description = as.factor(.data$Description)) %>%
    dplyr::mutate(Description = forcats::fct_reorder(.data$Description,
                                                     dplyr::desc(.data$p.adjust)))
  ggplot(df, aes(x = .data$Description, y = -log10(.data$p.adjust))) +
    geom_bar(aes(fill = .data$Count), stat = "identity") +
    scale_fill_gradient2("Gene Count", low = "lightgrey", mid = "#feb24c", high = "#bd0026") +
    coord_flip() +
    geom_hline(yintercept = -log10(0.05), linetype = "dashed") +
    xlab("Gene Ontology") +
    ylab(bquote("-log"[10] ~ " adjusted p-value")) +
    theme_bw() +
    theme(axis.text = element_text(size = 10), axis.title = element_text(size = 12)) +
    ggtitle(title.var)
}
