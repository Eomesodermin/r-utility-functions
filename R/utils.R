# Internal helpers -----------------------------------------------------------

#' @importFrom rlang %||%
NULL

# Stop with a helpful message when an optional dependency is missing.
require_pkg <- function(pkg, fn) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    stop("Package '", pkg, "' is required for ", fn, "; install it first.", call. = FALSE)
  }
  invisible(TRUE)
}

# Create a directory (and parents) if it does not exist; returns it unchanged.
ensure_dir <- function(path) {
  if (!dir.exists(path)) dir.create(path, recursive = TRUE)
  path
}

# Print a plot to a PDF file.
save_pdf <- function(plot, path, width = 7, height = 7) {
  grDevices::pdf(path, width = width, height = height)
  on.exit(grDevices::dev.off(), add = TRUE)
  print(plot)
  invisible(path)
}
