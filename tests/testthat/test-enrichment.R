test_that("go_enrichment validates its inputs", {
  skip_if_not_installed("clusterProfiler")
  expect_error(go_enrichment(data.frame(a = 1)), "'gene' and 'FDR'")
  expect_error(go_enrichment(data.frame(gene = "A", FDR = 0.1), org = "zebrafish"))
})

test_that("go_enrichment runs on a cytotoxic gene set and returns a plot or result", {
  skip_on_cran()
  skip_if_not_installed("clusterProfiler")
  skip_if_not_installed("org.Hs.eg.db")
  markers <- data.frame(
    gene = c("GZMA", "GZMB", "GZMH", "GZMK", "PRF1", "GNLY", "NKG7", "CTSW", "KLRD1", "KLRF1",
             "KLRB1", "FGFBP2", "CST7", "CCL5", "CD247", "TYROBP", "FCER1G", "NCAM1"),
    FDR = seq(1e-10, 1e-3, length.out = 18)
  )
  res <- suppressMessages(go_enrichment(markers, topn = 18, org = "human", plot = FALSE,
                                        pvalueCutoff = 1, qvalueCutoff = 1))
  expect_s4_class(res, "enrichResult")
  plt <- suppressMessages(go_enrichment(markers, topn = 18, org = "human", plot = TRUE,
                                        pvalueCutoff = 1, qvalueCutoff = 1))
  expect_s3_class(plt, "ggplot")
})
