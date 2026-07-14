#' Moving average of a numeric vector
#'
#' Computes a moving average, handling `NA` values gracefully. Adapted from
#' Riesenberg et al., Nat. Commun. 2015 (doi:10.1038/ncomms9755) and cookbook-r.com.
#'
#' @param x A numeric vector.
#' @param n Window size (number of values to average over).
#' @param centered If `TRUE`, centre the window on each point; otherwise use a
#'   trailing window.
#' @return A numeric vector the same length as `x`.
#' @details `n` must be a positive integer; `x` must be numeric.
#' @examples
#' moving_average(c(1, 2, 3, 4, 5), n = 3)
#' moving_average(c(1, NA, 3, 4, 5), n = 2, centered = TRUE)
#' @export
moving_average <- function(x, n = 1, centered = FALSE) {
  if (!is.numeric(x)) stop("`x` must be numeric.", call. = FALSE)
  if (length(n) != 1 || n < 1 || n != round(n)) {
    stop("`n` must be a positive integer.", call. = FALSE)
  }
  if (centered) {
    before <- floor((n - 1) / 2)
    after  <- ceiling((n - 1) / 2)
  } else {
    before <- n - 1
    after  <- 0
  }
  s     <- rep(0, length(x))
  count <- rep(0, length(x))
  new <- x
  count <- count + !is.na(new)
  new[is.na(new)] <- 0
  s <- s + new
  i <- 1
  while (i <= before) {
    new <- c(rep(NA, i), x[1:(length(x) - i)])
    count <- count + !is.na(new)
    new[is.na(new)] <- 0
    s <- s + new
    i <- i + 1
  }
  i <- 1
  while (i <= after) {
    new <- c(x[(i + 1):length(x)], rep(NA, i))
    count <- count + !is.na(new)
    new[is.na(new)] <- 0
    s <- s + new
    i <- i + 1
  }
  s / count
}
