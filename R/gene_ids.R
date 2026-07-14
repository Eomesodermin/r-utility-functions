#' Convert gene symbols between mouse and human
#'
#' Maps orthologous gene symbols between mouse (MGI) and human (HGNC) using
#' Ensembl BioMart, or the Jackson Laboratory homology report as an offline
#' fallback.
#'
#' @param genes Character vector of gene symbols to convert.
#' @param use.jax If `TRUE`, use the JAX `HOM_MouseHumanSequence` report instead
#'   of BioMart (useful when the Ensembl servers are unreachable).
#' @return A data frame (BioMart) or character vector (JAX) of converted symbols.
#' @name convert_genes
#' @examples
#' \dontrun{
#' convert_mouse_to_human(c("Gzma", "Gzmb", "Xcl1"))
#' convert_human_to_mouse(c("GZMA", "GZMB", "XCL1"))
#' }
NULL

#' @rdname convert_genes
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @export
convert_mouse_to_human <- function(genes, use.jax = FALSE) {
  if (use.jax) {
    mouse_human_genes <- utils::read.csv(
      "http://www.informatics.jax.org/downloads/reports/HOM_MouseHumanSequence.rpt",
      sep = "\t")
    output.df <- c()
    for (gene.i in genes) {
      class_key <- (mouse_human_genes %>%
        dplyr::filter(.data$Symbol == gene.i &
          .data$Common.Organism.Name == "mouse, laboratory"))[["DB.Class.Key"]]
      if (!identical(class_key, integer(0))) {
        human_genes <- (mouse_human_genes %>%
          dplyr::filter(.data$DB.Class.Key == class_key &
            .data$Common.Organism.Name == "human"))[, "Symbol"]
        output.df <- append(output.df, human_genes)
      }
    }
    return(output.df)
  }
  if (!requireNamespace("biomaRt", quietly = TRUE)) {
    stop("Package 'biomaRt' is required (or use `use.jax = TRUE`).", call. = FALSE)
  }
  human <- biomaRt::useMart("ensembl", dataset = "hsapiens_gene_ensembl")
  mouse <- biomaRt::useMart("ensembl", dataset = "mmusculus_gene_ensembl")
  genes.new <- biomaRt::getLDS(attributes = "mgi_symbol", filters = "mgi_symbol",
    values = genes, mart = mouse, attributesL = "hgnc_symbol", martL = human,
    uniqueRows = TRUE)
  genes.new %>%
    dplyr::distinct(.data$MGI.symbol, .keep_all = TRUE) %>%
    dplyr::distinct(.data$HGNC.symbol, .keep_all = TRUE)
}

#' @rdname convert_genes
#' @export
convert_human_to_mouse <- function(genes, use.jax = FALSE) {
  if (use.jax) {
    return(convert_mouse_to_human(genes, use.jax = TRUE))
  }
  if (!requireNamespace("biomaRt", quietly = TRUE)) {
    stop("Package 'biomaRt' is required (or use `use.jax = TRUE`).", call. = FALSE)
  }
  human <- biomaRt::useMart("ensembl", dataset = "hsapiens_gene_ensembl")
  mouse <- biomaRt::useMart("ensembl", dataset = "mmusculus_gene_ensembl")
  genes.new <- biomaRt::getLDS(attributes = "hgnc_symbol", filters = "hgnc_symbol",
    values = genes, mart = human, attributesL = "mgi_symbol", martL = mouse,
    uniqueRows = TRUE)
  genes.new %>%
    dplyr::distinct(.data$HGNC.symbol, .keep_all = TRUE) %>%
    dplyr::distinct(.data$MGI.symbol, .keep_all = TRUE)
}
