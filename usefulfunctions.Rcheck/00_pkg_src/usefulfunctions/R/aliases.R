# Deprecated legacy aliases -------------------------------------------------
# The package originally used dot.case names. These are kept so existing
# scripts keep working; new code should use the snake_case names.

#' @rdname make_transparent
#' @export
makeTransparent <- function(color, percent = 50, name = NULL) {
  make_transparent(color = color, percent = percent, name = name)
}

#' @rdname get_batlow
#' @export
Get.batlow <- function(n = 100) get_batlow(n = n)

#' @rdname moving_average
#' @export
calc.moving.average <- function(x, n = 1, centered = FALSE) {
  moving_average(x = x, n = n, centered = centered)
}
