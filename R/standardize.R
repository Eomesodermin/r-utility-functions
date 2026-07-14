#' Row-wise robust standardisation
#'
#' Centres each row of a matrix by its median and scales by its median absolute
#' deviation (MAD) — a robust alternative to a z-score. Rows with zero MAD
#' (constant values) are returned centred (all zero) instead of `NaN`.
#'
#' @param z A numeric matrix (features x samples).
#' @param na.rm Whether to ignore `NA`s when computing the median and MAD.
#' @return A matrix the same shape as `z`, robustly standardised by row.
#' @examples
#' m <- matrix(c(1, 2, 3, 10, 20, 30), nrow = 2, byrow = TRUE)
#' standardize(m)
#' # a constant row no longer produces NaN:
#' standardize(rbind(c(5, 5, 5), c(1, 2, 3)))
#' @export
standardize <- function(z, na.rm = TRUE) {
  if (!is.matrix(z)) z <- as.matrix(z)
  rowmed <- apply(z, 1, stats::median, na.rm = na.rm)
  rowmad <- apply(z, 1, stats::mad, na.rm = na.rm)
  rowmad[rowmad == 0 | is.na(rowmad)] <- 1     # avoid divide-by-zero on constant rows
  sweep(sweep(z, 1, rowmed), 1, rowmad, "/")
}
