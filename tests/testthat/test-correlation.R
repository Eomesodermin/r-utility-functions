test_that("sc_correlation returns ranked correlations incl. self-correlation", {
  set.seed(1)
  m <- matrix(rnorm(100), nrow = 10,
              dimnames = list(paste0("g", 1:10), paste0("c", 1:10)))
  res <- sc_correlation(m, goi = "g1", remove.quantile = 0,
                        output.tables = paste0(tempfile("cor"), "/"))
  expect_true(all(c("GeneID", "Cor.val", "P.val", "FDR") %in% names(res)))
  expect_equal(res$Cor.val[res$GeneID == "g1"], 1)          # gene correlates 1 with itself
})
