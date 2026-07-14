test_that("moving_average trailing window is correct", {
  expect_equal(moving_average(c(1, 2, 3, 4, 5), n = 1), c(1, 2, 3, 4, 5))
  expect_equal(moving_average(c(2, 4, 6), n = 2), c(2, 3, 5))
})

test_that("moving_average centred window averages available (non-NA) neighbours", {
  # centred n=3 at position 2 averages positions 1 and 3 (NA skipped)
  expect_equal(moving_average(c(2, NA, 4), n = 3, centered = TRUE)[2], 3)
})

test_that("calc.moving.average alias matches new function", {
  expect_identical(calc.moving.average(c(1, 2, 3), n = 2),
                   moving_average(c(1, 2, 3), n = 2))
})
