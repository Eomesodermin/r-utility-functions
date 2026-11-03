make_raw <- function() {
  data.frame(
    gene_id = c("E1", "E2", "E3", "E4", "E5"),
    gene_name = c("NKG7", "NKG7", "GZMB", "MIR1", "ACTB"),
    gene_type = c("protein_coding", "protein_coding", "protein_coding", "miRNA", "protein_coding"),
    unstranded_TCGA.AB.0001.01A = c(10, 90, 5, 1, 100),
    tpm_unstranded_TCGA.AB.0001.01A = c(1, 9, 2, 0.1, 50),
    tpm_unstranded_TCGA.AB.0002.01A = c(2, 8, 4, 0.2, 60),
    stringsAsFactors = FALSE
  )
}

test_that("select_tcga_tpm keeps coding genes, TPM columns, and the strongest duplicate", {
  tpm <- select_tcga_tpm(make_raw())
  expect_setequal(rownames(tpm), c("NKG7", "GZMB", "ACTB"))
  expect_true(all(grepl("^tpm_unstranded_", names(tpm))))
  expect_equal(unname(tpm["NKG7", 1]), 9)            # the duplicate with the larger total signal
  expect_error(select_tcga_tpm(data.frame(a = 1)), "must contain columns")
  expect_error(select_tcga_tpm(make_raw()[, 1:4]), "tpm_unstranded")
})

test_that("stratify_by_expression splits on quartiles of a single gene", {
  expr <- matrix(1:8, nrow = 1, dimnames = list("G", paste0("s", 1:8)))
  strata <- stratify_by_expression(expr, "G")
  expect_equal(strata$high, c("s7", "s8"))
  expect_equal(strata$low, c("s1", "s2"))
})

test_that("low-expressed genes are not all called high (regression for floor() thresholds)", {
  set.seed(2)
  expr <- matrix(runif(40, 0, 0.5), nrow = 1, dimnames = list("G", paste0("s", 1:40)))
  strata <- stratify_by_expression(expr, "G")
  expect_lt(length(strata$high), 20)
  expect_gt(length(strata$high), 0)
  expect_false(any(strata$high %in% strata$low))
})

test_that("a multi-gene signature ranks samples by mean z-score", {
  expr <- rbind(A = 1:8, B = 1:8, C = 8:1)
  colnames(expr) <- paste0("s", 1:8)
  strata <- stratify_by_expression(expr, c("A", "B"))
  expect_equal(strata$high, c("s7", "s8"))
  expect_equal(strata$low, c("s1", "s2"))
  expect_equal(names(strata$score), colnames(expr))
})

test_that("stratify_by_expression validates its input", {
  expr <- matrix(1:8, nrow = 1, dimnames = list("G", paste0("s", 1:8)))
  expect_error(stratify_by_expression(expr, "H"), "not found")
  expect_error(stratify_by_expression(expr, "G", quantile = 0.6), "between 0 and 0.5")
})

test_that("patient_barcode reduces sample barcodes to unique patients", {
  ids <- c("tpm_unstranded_TCGA-AB-0001-01A-11R", "TCGA-AB-0001-06A", "TCGA-CD-0002-01A")
  expect_equal(patient_barcode(ids), c("TCGA-AB-0001", "TCGA-CD-0002"))
})

test_that("label_signature_groups labels patients and leaves ambiguous ones unlabelled", {
  clinical <- data.frame(bcr_patient_barcode = c("TCGA-AB-0001", "TCGA-AB-0002", "TCGA-AB-0003", "TCGA-AB-0004"))
  expect_message(
    out <- label_signature_groups(
      clinical,
      high = c("TCGA-AB-0001-01A", "TCGA-AB-0003-01A"),
      low = c("TCGA-AB-0002-01A", "TCGA-AB-0003-06A")
    ),
    "both groups"
  )
  expect_equal(out$Signature, c("High", "Low", NA, NA))
})

test_that("load_rda returns the first stored object", {
  path <- tempfile(fileext = ".rda")
  stored <- data.frame(x = 1:3)
  save(stored, file = path)
  expect_equal(load_rda(path), stored)
})

test_that("tcga_survival runs end to end with the TCGAbiolinks calls mocked", {
  skip_if_not_installed("TCGAbiolinks")
  raw_path <- tempfile(fileext = ".rda")
  raw <- make_raw()
  save(raw, file = raw_path)
  clinical <- data.frame(bcr_patient_barcode = c("TCGA-AB-0001", "TCGA-AB-0002"))
  plotted <- NULL
  local_mocked_bindings(
    normalise_tcga = function(tpm, ...) {
      names(tpm) <- c("TCGA-AB-0001-01A", "TCGA-AB-0002-01A")
      tpm
    },
    plot_overall_survival = function(clinical, ...) {
      plotted <<- clinical
      invisible("plot.pdf")
    }
  )
  local_mocked_bindings(GDCquery_clinic = function(...) clinical, .package = "TCGAbiolinks")
  out <- suppressMessages(tcga_survival("TCGA-XX", "ACTB", rda.file.path = raw_path,
                                        data.dir = paste0(tempfile("tcga"), "/"),
                                        plot.dir = tempdir()))
  expect_equal(out$Signature, c("Low", "High"))
  expect_identical(plotted, out)
})
