#' Make a colour transparent
#'
#' Adds an alpha channel to one or more colours. Vectorised over `color`.
#'
#' @param color A colour or vector of colours (names or hex).
#' @param percent Numeric in `[0, 100]`; percentage transparency (0 = opaque).
#'   Recycled against `color`.
#' @param name Optional name(s) for the returned colour(s).
#' @return A character vector of hex colours with alpha, one per `color`.
#' @author Adapted from Ricardo Oliveros-Ramos.
#' @examples
#' make_transparent("red", percent = 50)
#' make_transparent(c("red", "blue", "green"), percent = c(25, 50, 75))
#' @export
make_transparent <- function(color, percent = 50, name = NULL) {
  if (any(percent < 0 | percent > 100)) {
    stop("`percent` must be between 0 and 100.", call. = FALSE)
  }
  rgb.val <- grDevices::col2rgb(color)          # 3 x length(color)
  grDevices::rgb(rgb.val[1, ], rgb.val[2, ], rgb.val[3, ],
                 max = 255,
                 alpha = (100 - percent) * 255 / 100,
                 names = name)
}

#' Batlow colour palette
#'
#' Returns `n` colours from the perceptually-uniform \pkg{scico} "batlow" palette.
#'
#' @param n Number of colours to return (>= 1).
#' @param rev If `TRUE`, reverse the palette order.
#' @return A character vector of hex colours.
#' @examples
#' get_batlow(5)
#' get_batlow(5, rev = TRUE)
#' @export
get_batlow <- function(n = 100, rev = FALSE) {
  if (length(n) != 1 || n < 1) stop("`n` must be a single value >= 1.", call. = FALSE)
  pal <- scico::scico(n, palette = "batlow")
  if (rev) rev(pal) else pal
}
