#' Moving average of a numeric vector
#'
#' Computes a moving average that ignores `NA` values inside each window, so a
#' window containing some missing values still returns the mean of the observed
#' ones. Adapted from Riesenberg et al., Nat. Commun. 2015
#' (doi:10.1038/ncomms9755) and cookbook-r.com.
#'
#' @param x A numeric vector.
#' @param n Window size: a positive integer number of values to average over.
#' @param centered If `TRUE`, centre the window on each point; otherwise use a
#'   trailing window that ends at each point.
#' @return A numeric vector the same length as `x`. Positions whose whole window
#'   is `NA` return `NaN`.
#' @examples
#' moving_average(c(1, 2, 3, 4, 5), n = 3)
#' moving_average(c(1, NA, 3, 4, 5), n = 2, centered = TRUE)
#' @export
moving_average <- function(x, n = 1, centered = FALSE) {
  if (!is.numeric(x)) stop("`x` must be numeric.", call. = FALSE)
  if (length(n) != 1 || n < 1 || n != round(n)) {
    stop("`n` must be a positive integer.", call. = FALSE)
  }
  before <- if (centered) floor((n - 1) / 2) else n - 1
  after <- if (centered) ceiling((n - 1) / 2) else 0
  len <- length(x)
  vapply(seq_len(len), function(i) {
    window <- x[max(1, i - before):min(len, i + after)]
    mean(window, na.rm = TRUE)
  }, numeric(1))
}
