test_that("umap_optimise writes one PDF per parameter combination", {
  skip_on_cran()
  skip_if_not_installed("Seurat")
  pbmc <- SeuratObject::pbmc_small
  out_dir <- tempfile("umap")
  paths <- suppressWarnings(suppressMessages(
    umap_optimise(pbmc, output.dir = out_dir, init.min.dist = 0.4, min.dist.step = 4,
                  init.neigh = 5, neigh.step = 10, max.neigh = 15, dims = 1:10)
  ))
  expect_length(paths, 2)                           # min.dist 0.4 only (1.6 >= 1) x n.neighbors 5, 15
  expect_true(all(file.exists(paths)))
})

test_that("umap_optimise validates its step arguments", {
  skip_if_not_installed("Seurat")
  expect_error(umap_optimise(NULL, min.dist.step = 1), "greater than 1")
  expect_error(umap_optimise(NULL, neigh.step = 0), "positive")
})
