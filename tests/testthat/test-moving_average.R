test_that("moving_average trailing window is correct", {
  expect_equal(moving_average(c(1, 2, 3, 4, 5), n = 1), c(1, 2, 3, 4, 5))
  expect_equal(moving_average(c(2, 4, 6), n = 2), c(2, 3, 5))
})

test_that("moving_average centred window averages available (non-NA) neighbours", {
  expect_equal(moving_average(c(2, NA, 4), n = 3, centered = TRUE)[2], 3)
})

test_that("moving_average validates its inputs", {
  expect_error(moving_average("a", n = 2))
  expect_error(moving_average(1:5, n = 0))
  expect_error(moving_average(1:5, n = 2.5))
})

test_that("moving_average handles windows larger than the vector and all-NA windows", {
  expect_equal(moving_average(c(1, 2), n = 5), c(1, 1.5))
  expect_true(is.nan(moving_average(c(NA_real_, NA_real_), n = 2)[2]))
  expect_equal(moving_average(numeric(0), n = 3), numeric(0))
})
