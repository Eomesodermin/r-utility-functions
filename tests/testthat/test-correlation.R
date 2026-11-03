make_expr <- function() {
  set.seed(1)
  m <- matrix(rnorm(100), nrow = 10, dimnames = list(paste0("g", 1:10), paste0("c", 1:10)))
  m["g2", ] <- m["g1", ] * 2 + 0.01 * rnorm(10)     # strongly correlated with g1
  m["g3", ] <- -m["g1", ]                           # perfectly anti-correlated
  m
}

test_that("sc_correlation returns sorted correlations with self at the top", {
  res <- sc_correlation(make_expr(), goi = "g1", remove.quantile = 0, output.tables = NULL)
  expect_named(res, c("GeneID", "Cor.val", "P.val", "FDR"))
  expect_equal(res$GeneID[1], "g1")
  expect_equal(res$Cor.val[1], 1)
  expect_false(is.unsorted(rev(res$Cor.val)))
  expect_equal(res$GeneID[2], "g2")
  expect_equal(res$Cor.val[res$GeneID == "g3"], -1)
  expect_true(all(res$FDR >= res$P.val - 1e-12))
})

test_that("sc_correlation supports spearman, writes a CSV, and validates goi", {
  out_dir <- file.path(tempfile("cor"), "tables")
  res <- sc_correlation(make_expr(), goi = "g2", remove.quantile = 0, method = "spearman",
                        output.tables = out_dir)
  expect_equal(res$Cor.val[res$GeneID == "g2"], 1)
  written <- read.csv(file.path(out_dir, "Correlation_values_g2.csv"))
  expect_equal(nrow(written), nrow(res))
  expect_error(sc_correlation(make_expr(), goi = "not_a_gene", output.tables = NULL), "not a rowname")
})

test_that("sc_correlation filters low-expression genes but always keeps the gene of interest", {
  m <- make_expr()
  m["g4", ] <- m["g4", ] - 100                      # very low mean expression
  res <- sc_correlation(m, goi = "g4", remove.quantile = 0.3, output.tables = NULL)
  expect_true("g4" %in% res$GeneID)
  expect_lt(nrow(res), nrow(m) + 1)
})

test_that("sc_correlation drops zero-variance genes instead of failing", {
  m <- make_expr()
  m["g5", ] <- 1
  res <- sc_correlation(m, goi = "g1", remove.quantile = 0, output.tables = NULL)
  expect_false("g5" %in% res$GeneID)
})

test_that("plot_correlation returns ggplots and writes PDFs", {
  res <- sc_correlation(make_expr(), goi = "g1", remove.quantile = 0, output.tables = NULL)
  out_dir <- tempfile("plots")
  plots <- plot_correlation(res, output.dir = out_dir, goi = "g1", top.n.val = 4)
  expect_s3_class(plots$ranking, "ggplot")
  expect_s3_class(plots$top, "ggplot")
  expect_true(all(file.exists(file.path(out_dir, c("correlation.pdf", "correlation_top_4.pdf")))))
  expect_no_error(ggplot2::ggplot_build(plots$ranking))
})

test_that("correlation_heatmaps draws heatmaps for a Seurat object", {
  skip_if_not_installed("Seurat")
  pbmc <- suppressWarnings(Seurat::ScaleData(SeuratObject::pbmc_small,
                                             features = rownames(SeuratObject::pbmc_small), verbose = FALSE))
  expr <- as.matrix(SeuratObject::GetAssayData(pbmc))
  goi <- rownames(expr)[1]
  cor_df <- sc_correlation(expr, goi = goi, remove.quantile = 0, output.tables = NULL)
  cor_df$FDR <- 0.01                                 # make every gene "significant"
  out_dir <- tempfile("heat")
  plots <- suppressWarnings(correlation_heatmaps(pbmc, cor_df, up.n = 5, dn.n = 5, goi = goi,
                                                 output.dir = out_dir))
  expect_named(plots, c("up", "down"))
  expect_true(file.exists(file.path(out_dir, "Heatmap_top5_corr_genes.pdf")))
})
