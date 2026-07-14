test_that("make_transparent adds alpha and validates input", {
  col <- make_transparent("red", percent = 50)
  expect_match(col, "^#FF0000")
  expect_equal(nchar(col), 9L)                 # #RRGGBBAA
  expect_error(make_transparent("red", percent = 150))
  expect_error(make_transparent("red", percent = -1))
})

test_that("make_transparent is vectorised over colours and percent", {
  out <- make_transparent(c("red", "blue", "green"), percent = c(0, 50, 100))
  expect_length(out, 3L)
  expect_match(out[1], "FF$", ignore.case = TRUE)   # 0% transparent -> full alpha
  expect_match(out[3], "00$")                        # 100% transparent -> zero alpha
})

test_that("makeTransparent alias equals new function", {
  expect_identical(makeTransparent, make_transparent)
})

test_that("get_batlow returns n colours and reverses", {
  skip_if_not_installed("scico")
  expect_length(get_batlow(5), 5L)
  expect_identical(get_batlow(5, rev = TRUE), rev(get_batlow(5)))
  expect_error(get_batlow(0))
})
