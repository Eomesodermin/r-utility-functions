#' Row-wise robust standardisation
#'
#' Centres each row of a matrix by its median and scales by its median absolute
#' deviation (MAD) — a robust alternative to a z-score, useful before plotting
#' expression heatmaps.
#'
#' @param z A numeric matrix (features x samples).
#' @return A matrix the same shape as `z`, robustly standardised by row.
#' @examples
#' m <- matrix(c(1, 2, 3, 10, 20, 30), nrow = 2, byrow = TRUE)
#' standardize(m)
#' @export
standardize <- function(z) {
  rowmed <- apply(z, 1, stats::median)
  rowmad <- apply(z, 1, stats::mad)
  rv <- sweep(z, 1, rowmed)
  sweep(rv, 1, rowmad, "/")
}
