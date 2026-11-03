#' Download a TCGA RNA-seq dataset
#'
#' Queries, downloads and prepares a TCGA gene-expression dataset (STAR counts)
#' via TCGAbiolinks, saving the prepared table to an `.rda` file.
#'
#' @param dataset.name TCGA project id, e.g. `"TCGA-LAML"`.
#' @param raw.data.dir Directory for the raw GDC download.
#' @param rda.dir Directory to save the prepared `.rda` into.
#' @return The prepared expression table from [TCGAbiolinks::GDCprepare()].
#' @examples
#' \dontrun{
#' download_tcga_rnaseq("TCGA-LAML")
#' }
#' @export
download_tcga_rnaseq <- function(dataset.name, raw.data.dir = "GDCdata/", rda.dir = "data/") {
  require_pkg("TCGAbiolinks", "download_tcga_rnaseq()")
  for (dir in c(raw.data.dir, rda.dir)) {
    if (!dir.exists(dir)) dir.create(dir, recursive = TRUE)
  }
  message("Downloading dataset ", dataset.name)
  query <- TCGAbiolinks::GDCquery(
    project = dataset.name,
    data.category = "Transcriptome Profiling",
    workflow.type = "STAR - Counts",
    data.type = "Gene Expression Quantification",
    experimental.strategy = "RNA-Seq"
  )
  TCGAbiolinks::GDCdownload(query, files.per.chunk = 6, directory = raw.data.dir)
  TCGAbiolinks::GDCprepare(
    query = query,
    summarizedExperiment = FALSE,
    save = TRUE,
    save.filename = file.path(rda.dir, paste0(dataset.name, "_Transcriptome_Profiling_raw_counts.rda"))
  )
}

# Load the first object stored in an .rda file.
load_rda <- function(path) {
  env <- new.env()
  objects <- load(path, envir = env)
  if (length(objects) == 0) stop("No objects found in ", path, call. = FALSE)
  get(objects[1], envir = env)
}

# Reduce a prepared TCGA table to protein-coding genes and their TPM columns.
# Where several rows share a gene symbol, the one with the highest total signal
# is kept. Returns a data frame with gene symbols as row names.
select_tcga_tpm <- function(raw) {
  id_cols <- c("gene_id", "gene_name", "gene_type")
  if (!all(id_cols %in% names(raw))) {
    stop("`raw` must contain columns: ", paste(id_cols, collapse = ", "), call. = FALSE)
  }
  coding <- as.data.frame(raw)[raw$gene_type == "protein_coding", , drop = FALSE]
  value_cols <- setdiff(names(coding), id_cols)
  coding <- coding[order(rowSums(coding[, value_cols, drop = FALSE]), decreasing = TRUE), , drop = FALSE]
  coding <- coding[!duplicated(coding$gene_name), , drop = FALSE]
  tpm <- coding[, grepl("^tpm_unstranded_", names(coding)), drop = FALSE]
  if (ncol(tpm) == 0) stop("No 'tpm_unstranded_*' columns found in `raw`.", call. = FALSE)
  rownames(tpm) <- coding$gene_name
  tpm
}

# GC-content normalisation and quantile filtering (TCGAbiolinks).
normalise_tcga <- function(tpm, quantile_filter = TRUE) {
  normed <- TCGAbiolinks::TCGAanalyze_Normalization(
    tabDF = tpm, geneInfo = TCGAbiolinks::geneInfo, method = "gcContent"
  )
  if (quantile_filter) {
    normed <- TCGAbiolinks::TCGAanalyze_Filtering(tabDF = normed, method = "quantile", qnt.cut = 0.25)
  }
  normed
}

#' Split samples into high and low expressers of a gene or signature
#'
#' Ranks samples by the expression of one gene, or by a signature score for
#' several genes (the mean of each gene's z-score across samples), and returns
#' the samples in the top and bottom quantile.
#'
#' @param expr Numeric matrix or data frame of expression (genes x samples), with
#'   gene symbols as row names and sample identifiers as column names.
#' @param genes One or more gene symbols present in `rownames(expr)`.
#' @param quantile Fraction of samples in each tail; `0.25` gives the upper and
#'   lower quartiles.
#' @return A list with the sample names in `high` and `low`, and the per-sample
#'   `score` used for ranking.
#' @examples
#' set.seed(1)
#' expr <- matrix(rexp(200), nrow = 4,
#'                dimnames = list(c("NKG7", "GZMB", "CD3E", "ACTB"), paste0("s", 1:50)))
#' strata <- stratify_by_expression(expr, "NKG7")
#' lengths(strata[c("high", "low")])
#' stratify_by_expression(expr, c("NKG7", "GZMB"))$high
#' @export
stratify_by_expression <- function(expr, genes, quantile = 0.25) {
  expr <- as.matrix(expr)
  missing_genes <- setdiff(genes, rownames(expr))
  if (length(missing_genes)) {
    stop("Gene(s) not found in `expr`: ", paste(missing_genes, collapse = ", "), call. = FALSE)
  }
  if (length(quantile) != 1 || quantile <= 0 || quantile >= 0.5) {
    stop("`quantile` must be between 0 and 0.5.", call. = FALSE)
  }
  if (length(genes) == 1) {
    score <- expr[genes, ]
  } else {
    z <- t(scale(t(expr[genes, , drop = FALSE])))
    score <- colMeans(z, na.rm = TRUE)
  }
  cutoffs <- stats::quantile(score, probs = c(quantile, 1 - quantile), na.rm = TRUE)
  list(
    high = names(score)[!is.na(score) & score >= cutoffs[[2]]],
    low = names(score)[!is.na(score) & score <= cutoffs[[1]]],
    score = score
  )
}

# Reduce TCGA sample barcodes to patient barcodes (TCGA-XX-XXXX).
patient_barcode <- function(ids) {
  matches <- regmatches(ids, regexpr("TCGA-[A-Za-z0-9]{2}-[A-Za-z0-9]{4}", ids))
  unique(matches)
}

# Add a High / Low `Signature` column to GDC clinical data. A patient with
# samples in both groups is ambiguous and left unlabelled.
label_signature_groups <- function(clinical, high, low) {
  high_patients <- patient_barcode(high)
  low_patients <- patient_barcode(low)
  ambiguous <- intersect(high_patients, low_patients)
  if (length(ambiguous)) {
    message(length(ambiguous), " patient(s) have samples in both groups and are left unlabelled.")
  }
  is_high <- clinical$bcr_patient_barcode %in% setdiff(high_patients, ambiguous)
  is_low <- clinical$bcr_patient_barcode %in% setdiff(low_patients, ambiguous)
  clinical$Signature <- NA_character_
  clinical$Signature[is_high] <- "High"
  clinical$Signature[is_low] <- "Low"
  message("Clinical data matched for ", sum(is_high), " high and ", sum(is_low), " low patients (",
          length(high_patients), " and ", length(low_patients), " requested).")
  clinical
}

# Kaplan-Meier overall-survival plot via TCGAbiolinks.
plot_overall_survival <- function(clinical, dataset.name, goi, output.dir = "figures/",
                                  with.risk = TRUE, with.conf = TRUE) {
  if (!dir.exists(output.dir)) dir.create(output.dir, recursive = TRUE)
  suffix <- paste0(if (!with.risk) "_noRisk", if (!with.conf) "_noCI")
  filename <- file.path(output.dir, paste0(dataset.name, "_overall_survival", suffix, ".pdf"))
  TCGAbiolinks::TCGAanalyze_survival(
    clinical,
    clusterCol = "Signature",
    filename = filename,
    risk.table = with.risk,
    color = c("Red", "Blue"),
    main = paste0("Kaplan-Meier Overall Survival ", dataset.name, " ", paste(goi, collapse = "+"),
                  " High vs. Low"),
    conf.int = with.conf,
    height = 10,
    width = 10
  )
  message("Survival plot saved to ", filename)
  invisible(filename)
}

#' Overall-survival analysis of a TCGA cohort
#'
#' Downloads (or loads) a TCGA dataset, normalises it, stratifies patients into
#' high and low expressers of a gene or signature (upper vs lower quartile), and
#' runs a Kaplan-Meier overall-survival analysis.
#'
#' @param TCGA.dataset TCGA project id, e.g. `"TCGA-LAML"`.
#' @param gene.signature Gene, or vector of genes, defining the signature. With
#'   several genes the ranking score is the mean z-score (see
#'   [stratify_by_expression()]).
#' @param gene.name Optional label (defaults to `gene.signature`).
#' @param rda.file.path Optional path to a prepared `.rda` from
#'   [download_tcga_rnaseq()]; if `NULL`, the data are downloaded.
#' @param plot.dir Directory to save the survival plot into.
#' @param data.dir Directory for downloaded and normalised data.
#' @return Invisibly, the clinical table with the `Signature` (High / Low)
#'   assignment. The survival plot is written to `plot.dir`.
#' @examples
#' \dontrun{
#' tcga_survival("TCGA-LAML", gene.signature = "TLR2")
#' }
#' @export
tcga_survival <- function(TCGA.dataset, gene.signature, gene.name = NULL, rda.file.path = NULL,
                          plot.dir = "figures/", data.dir = "data/") {
  require_pkg("TCGAbiolinks", "tcga_survival()")
  gene.name <- gene.name %||% gene.signature
  raw <- if (is.null(rda.file.path)) {
    download_tcga_rnaseq(TCGA.dataset, raw.data.dir = file.path(data.dir, "GDCdata/"), rda.dir = data.dir)
  } else {
    load_rda(rda.file.path)
  }

  message("Selecting protein-coding TPM values and normalising")
  normed <- normalise_tcga(select_tcga_tpm(raw))
  if (!dir.exists(data.dir)) dir.create(data.dir, recursive = TRUE)
  utils::write.table(normed, file.path(data.dir, paste0("Normalised_filtered_", TCGA.dataset, "_RNAseq_data.txt")),
                     sep = "\t", row.names = TRUE, quote = FALSE)

  strata <- stratify_by_expression(normed, gene.signature)
  message("n high = ", length(strata$high), ", n low = ", length(strata$low))

  clinical <- TCGAbiolinks::GDCquery_clinic(TCGA.dataset, "clinical")
  clinical <- label_signature_groups(clinical, strata$high, strata$low)
  plot_overall_survival(clinical, TCGA.dataset, gene.name, output.dir = plot.dir)
  invisible(clinical)
}
