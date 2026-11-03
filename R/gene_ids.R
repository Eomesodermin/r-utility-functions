#' Convert gene symbols between mouse and human
#'
#' Maps orthologous gene symbols between mouse (MGI) and human (HGNC) using
#' Ensembl BioMart, or the Jackson Laboratory homology report as an alternative
#' when the Ensembl servers are unreachable.
#'
#' @param genes Character vector of gene symbols to convert.
#' @param use.jax If `TRUE`, use the JAX `HOM_MouseHumanSequence` report instead
#'   of BioMart.
#' @param jax.table Optional data frame holding the JAX report (as read by
#'   [utils::read.delim()]). If `NULL` the report is downloaded. Supplying it avoids the
#'   download and makes the conversion reproducible offline.
#' @return With BioMart, a data frame with one row per ortholog pair
#'   (`MGI.symbol`, `HGNC.symbol` or the reverse). With `use.jax = TRUE`, a
#'   character vector of the converted symbols.
#' @details Both directions keep one row per source symbol and per target symbol
#'   (the first match), so one-to-many orthologs are collapsed.
#' @name convert_genes
#' @examples
#' \dontrun{
#' convert_mouse_to_human(c("Gzma", "Gzmb", "Xcl1"))
#' convert_human_to_mouse(c("GZMA", "GZMB", "XCL1"))
#' }
NULL

jax_report_url <- "https://www.informatics.jax.org/downloads/reports/HOM_MouseHumanSequence.rpt"

# Look up orthologs in the JAX homology report. `from`/`to` are the NCBI-style
# organism names used in the report.
jax_orthologs <- function(genes, from, to, jax.table = NULL) {
  if (is.null(jax.table)) {
    jax.table <- utils::read.delim(jax_report_url, stringsAsFactors = FALSE)
  }
  needed <- c("DB.Class.Key", "Common.Organism.Name", "Symbol")
  if (!all(needed %in% names(jax.table))) {
    stop("`jax.table` must contain columns: ", paste(needed, collapse = ", "), call. = FALSE)
  }
  src <- jax.table[jax.table$Common.Organism.Name == from, c("DB.Class.Key", "Symbol")]
  dst <- jax.table[jax.table$Common.Organism.Name == to, c("DB.Class.Key", "Symbol")]
  keys <- src$DB.Class.Key[match(genes, src$Symbol)]
  keys <- keys[!is.na(keys)]
  unique(dst$Symbol[dst$DB.Class.Key %in% keys])
}

# BioMart ortholog lookup between the human and mouse Ensembl marts.
biomart_orthologs <- function(genes, from = c("mouse", "human")) {
  from <- match.arg(from)
  if (!requireNamespace("biomaRt", quietly = TRUE)) {
    stop("Package 'biomaRt' is required (or use `use.jax = TRUE`).", call. = FALSE)
  }
  human <- biomaRt::useMart("ensembl", dataset = "hsapiens_gene_ensembl")
  mouse <- biomaRt::useMart("ensembl", dataset = "mmusculus_gene_ensembl")
  if (from == "mouse") {
    res <- biomaRt::getLDS(attributes = "mgi_symbol", filters = "mgi_symbol", values = genes,
                           mart = mouse, attributesL = "hgnc_symbol", martL = human, uniqueRows = TRUE)
    keys <- c("MGI.symbol", "HGNC.symbol")
  } else {
    res <- biomaRt::getLDS(attributes = "hgnc_symbol", filters = "hgnc_symbol", values = genes,
                           mart = human, attributesL = "mgi_symbol", martL = mouse, uniqueRows = TRUE)
    keys <- c("HGNC.symbol", "MGI.symbol")
  }
  res <- res[!duplicated(res[[keys[1]]]), , drop = FALSE]
  res[!duplicated(res[[keys[2]]]), , drop = FALSE]
}

#' @rdname convert_genes
#' @export
convert_mouse_to_human <- function(genes, use.jax = FALSE, jax.table = NULL) {
  if (use.jax) {
    return(jax_orthologs(genes, from = "mouse, laboratory", to = "human", jax.table = jax.table))
  }
  biomart_orthologs(genes, from = "mouse")
}

#' @rdname convert_genes
#' @export
convert_human_to_mouse <- function(genes, use.jax = FALSE, jax.table = NULL) {
  if (use.jax) {
    return(jax_orthologs(genes, from = "human", to = "mouse, laboratory", jax.table = jax.table))
  }
  biomart_orthologs(genes, from = "human")
}
