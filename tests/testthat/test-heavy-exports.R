test_that("heavy-dependency functions are exported with legacy aliases", {
  for (f in c("go_enrichment", "umap_optimise")) expect_true(is.function(get(f)))
  expect_identical(GO.function, go_enrichment)
  expect_identical(UMAP.optimise, umap_optimise)
})
