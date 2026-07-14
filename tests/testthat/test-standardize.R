test_that("standardize median-centres each row", {
  m <- matrix(c(1, 2, 3, 10, 20, 30), nrow = 2, byrow = TRUE)
  s <- standardize(m)
  expect_equal(unname(apply(s, 1, stats::median)), c(0, 0))
  expect_equal(dim(s), dim(m))
})
