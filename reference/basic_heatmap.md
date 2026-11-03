# Basic clustered heatmap

Draws a log2-scaled, hierarchically-clustered heatmap via
[`gplots::heatmap.2()`](https://talgalili.github.io/gplots/reference/heatmap.2.html).

## Usage

``` r
basic_heatmap(
  df,
  Col.cluster = FALSE,
  Row.cluster = FALSE,
  title.var = "",
  colsepvar = NULL,
  row.size = 0.4,
  scale.var = "row",
  dist.method = "euclidean",
  hclust.method = "ward.D"
)
```

## Arguments

- df:

  A numeric data frame or matrix (features x samples).

- Col.cluster, Row.cluster:

  Logical; whether to cluster columns / rows.

- title.var:

  Plot title.

- colsepvar:

  Optional column indices at which to draw separators.

- row.size:

  Row-label size (`cex`).

- scale.var:

  One of `"row"`, `"column"`, `"none"`.

- dist.method:

  Distance metric, see
  [`stats::dist()`](https://rdrr.io/r/stats/dist.html).

- hclust.method:

  Agglomeration method, see
  [`stats::hclust()`](https://rdrr.io/r/stats/hclust.html).

## Value

Called for its side effect (draws a heatmap); invisibly returns the
[`gplots::heatmap.2()`](https://talgalili.github.io/gplots/reference/heatmap.2.html)
object.

## Examples

``` r
if (FALSE) { # \dontrun{
basic_heatmap(my_matrix, Col.cluster = TRUE, Row.cluster = TRUE)
} # }
```
