#' Make a colour transparent
#'
#' Adds an alpha channel to a named or hex colour.
#'
#' @param color A colour, e.g. `"red"` or `"#FF0000"`.
#' @param percent Numeric in `[0, 100]`; percentage transparency (0 = opaque).
#' @param name Optional name for the returned colour.
#' @return A hex colour string with alpha.
#' @author Adapted from Ricardo Oliveros-Ramos.
#' @examples
#' make_transparent("red", percent = 50)
#' @export
make_transparent <- function(color, percent = 50, name = NULL) {
  if (percent < 0 || percent > 100) {
    stop("`percent` must be between 0 and 100.", call. = FALSE)
  }
  rgb.val <- grDevices::col2rgb(color)
  grDevices::rgb(rgb.val[1], rgb.val[2], rgb.val[3],
                 max = 255,
                 alpha = (100 - percent) * 255 / 100,
                 names = name)
}

#' Batlow colour palette
#'
#' Returns `n` colours from the perceptually-uniform \pkg{scico} "batlow" palette.
#'
#' @param n Number of colours to return.
#' @return A character vector of hex colours.
#' @examples
#' get_batlow(5)
#' @export
get_batlow <- function(n = 100) {
  scico::scico(n, palette = "batlow")
}
