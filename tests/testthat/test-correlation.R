make_expr <- function() {
  set.seed(1)
  matrix(rnorm(100), nrow = 10,
         dimnames = list(paste0("g", 1:10), paste0("c", 1:10)))
}

test_that("sc_correlation returns ranked correlations incl. self-correlation", {
  res <- sc_correlation(make_expr(), goi = "g1", remove.quantile = 0,
                        output.tables = paste0(tempfile("cor"), "/"))
  expect_true(all(c("GeneID", "Cor.val", "P.val", "FDR") %in% names(res)))
  expect_equal(res$Cor.val[res$GeneID == "g1"], 1)
})

test_that("sc_correlation supports spearman and validates goi", {
  res <- sc_correlation(make_expr(), goi = "g2", remove.quantile = 0,
                        method = "spearman", output.tables = paste0(tempfile("cor"), "/"))
  expect_equal(res$Cor.val[res$GeneID == "g2"], 1)
  expect_error(sc_correlation(make_expr(), goi = "not_a_gene",
                              output.tables = paste0(tempfile("cor"), "/")))
})
