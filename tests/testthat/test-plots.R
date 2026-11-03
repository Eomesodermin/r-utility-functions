make_matrix <- function() {
  set.seed(3)
  matrix(rexp(60, rate = 0.1), nrow = 6,
         dimnames = list(paste0("gene", 1:6), paste0("sample", 1:10)))
}

test_that("basic_heatmap draws and validates input", {
  skip_if_not_installed("gplots")
  grDevices::pdf(NULL)
  on.exit(grDevices::dev.off())
  expect_no_error(basic_heatmap(make_matrix(), Col.cluster = TRUE, Row.cluster = TRUE))
  expect_error(basic_heatmap(matrix(letters[1:4], 2)), "numeric")
})

test_that("dendrogram_samples returns the clustering and writes PDFs", {
  skip_if_not_installed("factoextra")
  skip_if_not_installed("ape")
  out_dir <- tempfile("dend")
  res <- suppressMessages(dendrogram_samples(make_matrix(), type.var = "phylogram", output.dir = out_dir))
  expect_s3_class(res$hclust, "hclust")
  expect_s3_class(res$plot, "ggplot")
  expect_true(all(file.exists(file.path(out_dir, c("Dendrogram.pdf", "Dendrogram_phylogram.pdf")))))
  expect_length(res$hclust$labels, 10)
})

test_that("dendrogram_samples can skip writing files", {
  skip_if_not_installed("factoextra")
  out <- suppressMessages(dendrogram_samples(make_matrix(), output.dir = NULL))
  expect_s3_class(out$plot, "ggplot")
})
