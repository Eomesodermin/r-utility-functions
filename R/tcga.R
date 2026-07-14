#' Download a TCGA RNA-seq dataset
#'
#' Queries, downloads and prepares a TCGA gene-expression dataset (STAR counts)
#' via TCGAbiolinks, saving the raw counts to an `.rda` file.
#'
#' @param dataset.name TCGA project id, e.g. `"TCGA-LAML"`.
#' @param raw.data.dir Directory for the raw GDC download.
#' @param rda.dir Directory to save the prepared `.rda` into.
#' @return The prepared raw-count object from [TCGAbiolinks::GDCprepare()].
#' @examples
#' \dontrun{
#' download_tcga_rnaseq("TCGA-LAML")
#' }
#' @export




download_tcga_rnaseq <- function(dataset.name,
                                 raw.data.dir = "GDCdata/",
                                 rda.dir = "data/"){
  if (!requireNamespace("TCGAbiolinks", quietly = TRUE)) {
    stop("Package 'TCGAbiolinks' (Bioconductor) is required for this function.", call. = FALSE)
  }

  # create directories
  if(!dir.exists(raw.data.dir)){
    dir.create(raw.data.dir, recursive = TRUE)
  }

  if(!dir.exists(rda.dir)){
    dir.create(rda.dir, recursive = TRUE)
  }


  print(paste0("downloading dataset ", dataset.name))


  query.raw.expression.hg38 <- TCGAbiolinks::GDCquery(project = dataset.name,
                                                      data.category = "Transcriptome Profiling",
                                                      workflow.type = "STAR - Counts",
                                                      data.type = "Gene Expression Quantification",
                                                      experimental.strategy = "RNA-Seq")

  TCGAbiolinks::GDCdownload(query.raw.expression.hg38,
                            files.per.chunk = 6,
                            directory = raw.data.dir)

  TCGA.raw.counts <- TCGAbiolinks::GDCprepare(query = query.raw.expression.hg38,
                                              summarizedExperiment = FALSE,
                                              save = TRUE,
                                              save.filename = paste0(rda.dir, dataset.name, "_Transcriptome_Profiling_raw_counts.rda"))

  return(TCGA.raw.counts)

}



load.rda <- function(path.to.rda){

  load(file = path.to.rda)
  TCGA.raw.counts <- data

  return(TCGA.raw.counts)

}








preprocess.TCGA <- function(input.data,
                            dataset.name = NULL,
                            quantile.filt = TRUE,
                            save.normed.data = TRUE,
                            output.dir = "data/"){


  # check that data.set name is defined if save.normed.data is set to TRUE
  if(save.normed.data & is.null(dataset.name)){
    stop("save.normed.data is set to TRUE but dataset.name is NULL, please define a dataset.name as this will be used in saving the file")
  }



  # filtering dataset
  print("Filtering dataset for protein coding etc.")

  filt.data <- input.data %>%
    dplyr::filter(.data$gene_type == "protein_coding") %>%
    dplyr::mutate(gene_sum = rowSums(dplyr::select(., -c(gene_id, gene_name, gene_type)))) %>%
    dplyr::arrange(dplyr::desc(.data$gene_sum)) %>%
    dplyr::distinct(.data$gene_name, .keep_all = TRUE) %>%
    tibble::column_to_rownames(var = "gene_name") %>%
    dplyr::select(-c(gene_id, gene_type, gene_sum)) %>%
    dplyr::select(tidyselect::matches("tpm_unstranded_.*"))

  # note that dataset contains unstranded, stranded_first, stranded_second, tpm_unstranded, fpkm_unstranded, fpkm_uq_unstranded counts for each sample
  # use tpm as tpm is best for comparing expression between samples

  print("Normalising by GC content")

  normed.data <- TCGAbiolinks::TCGAanalyze_Normalization(tabDF = filt.data,
                                                         geneInfo = TCGAbiolinks::geneInfo, # geneInfo or geneInfoHT
                                                         method = "gcContent")


  if(quantile.filt){
    # filter genes to reduce low expressed genes and false positive results
    # quantile filter of genes
    print("Quantile Filtering dataset")

    normed.data <- TCGAbiolinks::TCGAanalyze_Filtering(tabDF = normed.data,
                                                       method = "quantile",
                                                       qnt.cut =  0.25)

  }




  if(save.normed.data){
    print("Writing normalised & Filtered data to file")

    # Writing Normalised data
    utils::write.table(normed.data, paste0(output.dir, "Normalised_filtered_", dataset.name, "_RNAseq_data.txt"),
                sep = "\t", row.names = T, quote = F)


  }

  return(normed.data)

}






threshold.goi <- function(input.data, goi){


if(length(goi) == 1){

# extract goi expression data
  goi.expression <- input.data[goi, ]

  # get some expression summary statistics
  summary.value <- summary(goi.expression)

  # define upper and lower quartiles of expression
  upper.quartile <- floor(summary.value[5])
  lower.quartile <- ceiling(summary.value[2])

# use threshold to define high expressing patients
  High.exp.logic <- goi.expression >= upper.quartile
  print(paste0("n with high expression of ", goi, " = ", sum(High.exp.logic)))

  # use threshold to define low expressing patients
  Low.exp.logic <- goi.expression <= lower.quartile
  print(paste0("n with low expression of ", goi, " = ", sum(Low.exp.logic)))

  # extract patient IDs
  patients.high <- names(goi.expression)[High.exp.logic]
  patients.low <- names(goi.expression)[Low.exp.logic]

  # create list for exporting
  output.list <- list(patients.high = patients.high,
                      patients.low = patients.low)

  return(output.list)

}else if(length(goi) > 1){


  print("need to add code for multiple goi thresholding")
}

}





annotate.clinical.data <- function(patients.list,
                                   dataset.name){

  print("Downloading clinical data")

  clin.data <- TCGAbiolinks::GDCquery_clinic(dataset.name, "clinical")

  print("Identifying samples by Gene expression signature")

  # identifying samples by signature
  high.patients <- stringr::str_extract(patients.list[["patients.high"]],
                                        pattern = "TCGA-..-....")

  # ensure only unique entries of patients
  high.patients <- unique(high.patients)

  patients.high.logic <- clin.data$bcr_patient_barcode %in% high.patients


  low.patients <- stringr::str_extract(patients.list[["patients.low"]],
                                       pattern = "TCGA-..-....")

  # ensure only unique entries of patients
  low.patients <- unique(low.patients)

  patients.low.logic <- clin.data$bcr_patient_barcode %in% low.patients

  # sanity checks
  # ensure number of patients clinical data recovered is similar to number of patients data requested

  print(paste0("length of patients annotated as high signature score = ", length(high.patients)))

  print(paste0("length of patients annotated as low signature score = ", length(low.patients)))

  print(paste0("retrieved clinical data for ", sum(patients.high.logic), " patients annotated as high goi"))

  print(paste0("retrieved clinical data for ", sum(patients.low.logic), " patients annotated as high goi"))

  # Add annotation to clinical data table
  print("Add annotation to clinical data table")

  clin.data$Signature[patients.high.logic] <- paste0("High")

  clin.data$Signature[patients.low.logic] <- paste0("Low")


  return(clin.data)

}




plot.OS <- function(annotated.clin.data,
                    dataset.name,
                    goi,
                    output.dir = "figures/",
                    with.risk = TRUE,
                    with.conf = TRUE){

  # create output directory
  if(!dir.exists(output.dir)){
    dir.create(output.dir, recursive = TRUE)
  }


  print("Generating OS plot")

  if(with.risk & with.conf){
    title.var <- ""
  }else if(!with.risk & with.conf){
    title.var <- "_noRisk"
  }else if(with.risk & !with.conf){
    title.var <- "_noCI"
  }else if(!with.risk & !with.conf){
    title.var <- "_noRisk_noCI"
  }


  # Full plot with CI and risk table
  TCGAbiolinks::TCGAanalyze_survival(annotated.clin.data,
                                     clusterCol = "Signature",
                                     filename = paste0(output.dir, dataset.name, "_overall_survival", title.var, ".pdf"),
                                     risk.table = with.risk,
                                     color = c("Red", "Blue"),
                                     main = paste0("Kaplan-Meier Overall Survival ", dataset.name, " ", goi, " High vs. Low"),
                                     conf.int = with.conf,
                                     height = 10,
                                     width = 10)


  print(paste0("OS Plot saved to file.path = ", output.dir))

}






#HNSC.raw.data <- load.rda("TCGA-HNSC_Transcriptome_Profiling_raw_counts.rda")
#normed.data <- preprocess.TCGA(input.data = HNSC.raw.data, save.normed.data = F)



#' Overall-survival analysis of a TCGA cohort
#'
#' Downloads (or loads) a TCGA dataset, normalises it, stratifies patients into
#' high vs low expression of a gene or signature, and runs a Kaplan-Meier overall
#' survival analysis.
#'
#' @param TCGA.dataset TCGA project id, e.g. `"TCGA-LAML"`.
#' @param gene.signature Gene, or vector of genes, defining the signature.
#' @param gene.name Optional label (defaults to `gene.signature`).
#' @param rda.file.path Optional path to a downloaded `.rda`; if `NULL`, data is downloaded.
#' @param plot.dir Directory to save the survival plot into.
#' @param data.dir Directory for downloaded / normalised data.
#' @return Called for its side effects (survival plot and tables).
#' @examples
#' \dontrun{
#' tcga_survival("TCGA-LAML", gene.signature = "TLR2")
#' }
#' @export
tcga_survival <- function(TCGA.dataset,
                    gene.signature,
                    gene.name = NULL,
                    rda.file.path = NULL,
                    plot.dir = "figures/",
                    data.dir = "data/"){
  if (!requireNamespace("TCGAbiolinks", quietly = TRUE)) {
    stop("Package 'TCGAbiolinks' (Bioconductor) is required for this function.", call. = FALSE)
  }

  # if gene.name is not defined then let gene.name = goi
  if(is.null(gene.name)){
    gene.name <- gene.signature
  }

  # Check if rda file path is provided, if yes then load data, if not then download data
  if(is.null(rda.file.path)){
    print("no file path provided, data will be downloaded")

    raw.data <- download_tcga_rnaseq(dataset.name = TCGA.dataset,
                                     raw.data.dir = paste0(data.dir, "GDCdata/"),
                                     rda.dir = data.dir)

  }else{
    print("file path provided, data will loaded from file")

    raw.data <- load.rda(path.to.rda = rda.file.path)

  }

  # process dataset
  print("Processing and normalising dataset")

  normed.data <- preprocess.TCGA(input.data = raw.data,
                                 dataset.name = TCGA.dataset,
                                 quantile.filt = TRUE,
                                 save.normed.data = TRUE,
                                 output.dir = data.dir)


  # Extract expression, define threshold, and annotate patients as high or low exp
  print("Threshold and define high and low expression patients")

  threshold.list <- threshold.goi(input.data = normed.data,
                                  goi = gene.signature)


  # get clinical data and annotate patients as high or low exp
  print("Getting clinical data and defining patients as high or low")

  clinical.data <- annotate.clinical.data(patients.list = threshold.list,
                                          dataset.name = TCGA.dataset)

  # plotting overall survival
  print("Plotting OS")

  plot.OS(annotated.clin.data = clinical.data,
          dataset.name = TCGA.dataset,
          goi = gene.signature,
          output.dir = plot.dir,
          with.risk = TRUE,
          with.conf = TRUE)

}





























