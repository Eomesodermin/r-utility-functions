test_that("legacy names forward to the new functions and warn once", {
  rlang::reset_warning_verbosity("usefulfunctions-makeTransparent")
  expect_warning(out <- makeTransparent("red", percent = 50), "deprecated; use `make_transparent")
  expect_equal(out, make_transparent("red", percent = 50))
  expect_no_warning(makeTransparent("red", percent = 50))   # only once per session
})

test_that("every legacy alias points at an exported function", {
  ns <- asNamespace("usefulfunctions")
  exported <- getNamespaceExports("usefulfunctions")
  legacy <- c("makeTransparent", "Get.batlow", "calc.moving.average", "basic.heatmap", "dendrogram",
              "convert.mouse.to.human", "convert.human.to.mouse", "GO.function", "UMAP.optimise",
              "clean.data.volcano", "colour.points.volcano", "alpha.points.volcano",
              "size.points.volcano", "custom.enhanced.volcano", "sc.correlation",
              "correlation.heatmaps", "download.TCGA.RNAseq", "TCGA.OS")
  expect_true(all(legacy %in% exported))
  expect_true(all(vapply(legacy, function(f) is.function(get(f, envir = ns)), logical(1))))
})

test_that("a legacy alias forwards its arguments", {
  rlang::reset_warning_verbosity("usefulfunctions-calc.moving.average")
  out <- suppressWarnings(calc.moving.average(c(2, 4, 6), n = 2))
  expect_equal(out, c(2, 3, 5))
})
