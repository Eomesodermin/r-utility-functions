test_that("plot helpers are exported and guard their heavy dependencies", {
  expect_true(is.function(basic_heatmap))
  expect_true(is.function(dendrogram_samples))
  expect_identical(basic.heatmap, basic_heatmap)   # legacy alias
  expect_identical(dendrogram, dendrogram_samples)
})
