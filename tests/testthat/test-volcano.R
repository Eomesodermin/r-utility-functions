test_that("volcano point helpers return one value per row", {
  df <- data.frame(FDR = c(0.01, 0.5, 0.001), logFC = c(2, 0, -3),
                   row.names = c("NKG7", "B", "GZMB"))
  expect_length(alpha_volcano_points(df, "NKG7"), 3)
  expect_length(size_volcano_points(df, "NKG7"), 3)
  kv <- colour_volcano_points(df)
  expect_length(kv, 3)
  expect_equal(unname(kv[1]), "Red")     # NKG7: up + significant
  expect_equal(names(kv)[2], "NS")       # B: not significant
})

test_that("clean_volcano_data filters and selects", {
  df <- data.frame(FDR = c(0.01, 0.2), logFC = c(2, -0.3),
                   row.names = c("A", "B"))
  expect_equal(nrow(clean_volcano_data(df, sig.only = TRUE)), 1)
  expect_named(clean_volcano_data(df, sig.only = FALSE), c("FDR", "logFC"))
})

test_that("volcano legacy aliases forward", {
  expect_identical(colour.points.volcano, colour_volcano_points)
  expect_identical(custom.enhanced.volcano, custom_enhanced_volcano)
})

test_that("clean_volcano_data requires FDR and logFC columns", {
  expect_error(clean_volcano_data(data.frame(a = 1, b = 2)))
})
