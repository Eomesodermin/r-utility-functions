#' Basic clustered heatmap
#'
#' Draws a log2-scaled, hierarchically-clustered heatmap via [gplots::heatmap.2()].
#'
#' @param df A numeric data frame or matrix (features x samples).
#' @param Col.cluster,Row.cluster Logical; whether to cluster columns / rows.
#' @param title.var Plot title.
#' @param colsepvar Optional column indices at which to draw separators.
#' @param row.size Row-label size (`cex`).
#' @param scale.var One of `"row"`, `"column"`, `"none"`.
#' @param dist.method Distance metric, see [stats::dist()].
#' @param hclust.method Agglomeration method, see [stats::hclust()].
#' @return Called for its side effect (draws a heatmap); invisibly returns the
#'   [gplots::heatmap.2()] object.
#' @examples
#' \dontrun{
#' basic_heatmap(my_matrix, Col.cluster = TRUE, Row.cluster = TRUE)
#' }
#' @export
basic_heatmap <- function(df, Col.cluster = FALSE, Row.cluster = FALSE,
                          title.var = "", colsepvar = NULL, row.size = 0.4,
                          scale.var = "row", dist.method = "euclidean",
                          hclust.method = "ward.D") {
  if (!requireNamespace("gplots", quietly = TRUE)) {
    stop("Package 'gplots' is required for basic_heatmap(); ",
         "install it with install.packages('gplots').", call. = FALSE)
  }
  dissimfun  <- function(x) stats::dist(x, method = dist.method)
  clusterfun <- function(x) stats::hclust(x, method = hclust.method)
  gplots::heatmap.2(as.matrix(log2(df + 1)),
    col = grDevices::colorRampPalette(c("blue", "white", "red"))(100),
    scale = scale.var, na.rm = TRUE, trace = "none",
    Rowv = Row.cluster, Colv = Col.cluster,
    distfun = dissimfun, hclustfun = clusterfun, dendrogram = "both",
    margins = c(10, 7), cexCol = 0.8, cexRow = row.size, main = title.var,
    key = TRUE, keysize = 1.3, na.color = "yellow", sepcolor = "black",
    colsep = colsepvar, srtCol = 90)
}
