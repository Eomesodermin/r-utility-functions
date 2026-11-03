make_de <- function() {
  data.frame(
    FDR = c(0.001, 0.5, 0.01, 0.04, 0.9),
    logFC = c(2.5, 0.1, -3, 0.2, 1.5),
    row.names = c("NKG7", "ACTB", "GZMB", "CD3E", "IL7R")
  )
}

test_that("colour/alpha/size helpers return one value per row", {
  df <- make_de()
  expect_length(alpha_volcano_points(df, "NKG7"), 5)
  expect_length(size_volcano_points(df, "NKG7"), 5)
  kv <- colour_volcano_points(df, logFC.cutoff = 1)
  expect_length(kv, 5)
  expect_equal(unname(kv["NKG7" == rownames(df)]), "Red")
  expect_equal(names(kv)[rownames(df) == "GZMB"], "Decreased")
  expect_equal(names(kv)[rownames(df) == "ACTB"], "NS")
})

test_that("colour_volcano_points recolours highlighted genes", {
  kv <- colour_volcano_points(make_de(), highlight.selected = TRUE, highlight.genes = "NKG7",
                              selected.cols = c("Green", "Orange"))
  expect_equal(unname(kv[1]), "Green")
  expect_equal(names(kv)[1], "selected_up")
})

test_that("highlighted genes get their own alpha and size", {
  df <- make_de()
  expect_equal(alpha_volcano_points(df, "NKG7", baseline.alpha = 0.1, highlight.alpha = 1)[1:2], c(1, 0.1))
  expect_equal(size_volcano_points(df, "ACTB", baseline.size = 2, highlight.size = 9)[1:2], c(2, 9))
})

test_that("clean_volcano_data filters, selects and validates", {
  df <- make_de()
  expect_equal(rownames(clean_volcano_data(df, sig.only = TRUE)), c("NKG7", "GZMB", "CD3E"))
  expect_named(clean_volcano_data(df, sig.only = FALSE), c("FDR", "logFC"))
  expect_equal(rownames(clean_volcano_data(df, sig.only = FALSE)), rownames(df))
  expect_error(clean_volcano_data(data.frame(a = 1, b = 2)), "FDR")
})

test_that("volcano_plot returns a ggplot with the expected groups", {
  plt <- volcano_plot(make_de(), fc_cutoff = 1, p_cutoff = 0.05)
  expect_s3_class(plt, "ggplot")
  expect_equal(as.character(plt$data$group),
               c("FC + P", "NS", "FC + P", "P", "FC"))
  expect_no_error(ggplot2::ggplot_build(plt))
})

test_that("volcano_plot labels only the requested genes", {
  plt <- volcano_plot(make_de(), fc_cutoff = 1, label_genes = "GZMB")
  built <- ggplot2::ggplot_build(plt)
  label_layer <- built$data[[length(built$data)]]
  expect_equal(as.character(label_layer$label), "GZMB")
})

test_that("volcano_plot accepts per-point colours", {
  df <- make_de()
  plt <- volcano_plot(df, point_colours = colour_volcano_points(df), alpha = alpha_volcano_points(df),
                      point_size = size_volcano_points(df))
  expect_no_error(ggplot2::ggplot_build(plt))
  expect_error(volcano_plot(df, point_colours = c("red", "blue")), "one value per row")
})

test_that("volcano_plot copes with zero p-values and validates input", {
  df <- make_de()
  df$FDR[1] <- 0
  expect_warning(plt <- volcano_plot(df), "adjusted p-values is 0")
  expect_true(all(is.finite(plt$data$y_val)))
  expect_error(volcano_plot(df, x = "nope"), "must contain columns")
  expect_error(volcano_plot(df, colours = "red"), "four values")
  df$logFC <- as.character(df$logFC)
  expect_error(volcano_plot(df), "numeric")
})

test_that("custom_enhanced_volcano forwards to volcano_plot and warns about ignored arguments", {
  rlang::reset_warning_verbosity("usefulfunctions-cev")
  warnings <- testthat::capture_warnings(
    plt <- custom_enhanced_volcano(make_de(), FCcutoff = 1, drawConnectors = FALSE)
  )
  expect_match(warnings, "deprecated", all = FALSE)
  expect_match(warnings, "Ignoring unsupported arguments: drawConnectors", all = FALSE)
  expect_s3_class(plt, "ggplot")
})
