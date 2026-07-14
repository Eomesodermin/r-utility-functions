test_that("standardize median-centres each row", {
  m <- matrix(c(1, 2, 3, 10, 20, 30), nrow = 2, byrow = TRUE)
  s <- standardize(m)
  expect_equal(unname(apply(s, 1, stats::median)), c(0, 0))
  expect_equal(dim(s), dim(m))
})

test_that("standardize is robust to constant (zero-MAD) rows", {
  s <- standardize(rbind(c(5, 5, 5), c(1, 2, 3)))
  expect_false(any(is.nan(s)))
  expect_equal(unname(s[1, ]), c(0, 0, 0))   # constant row -> all zero, not NaN
})
