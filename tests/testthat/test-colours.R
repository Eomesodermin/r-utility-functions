test_that("make_transparent adds alpha and validates input", {
  col <- make_transparent("red", percent = 50)
  expect_match(col, "^#FF0000")
  expect_equal(nchar(col), 9L)               # #RRGGBBAA
  expect_error(make_transparent("red", percent = 150))
  expect_error(make_transparent("red", percent = -1))
})

test_that("makeTransparent alias matches new function", {
  expect_identical(makeTransparent, make_transparent)
})

test_that("get_batlow returns n colours", {
  skip_if_not_installed("scico")
  expect_length(get_batlow(5), 5L)
  expect_true(all(grepl("^#", get_batlow(3))))
})
