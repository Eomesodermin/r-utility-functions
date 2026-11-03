# Sample dendrogram

Hierarchically clusters the samples (columns of `data.matrix`) and
writes a dendrogram to PDF; optionally also a phylogeny-style plot.

## Usage

``` r
dendrogram_samples(
  data.matrix,
  hc_metric.var = "euclidean",
  hc_method.var = "ward.D2",
  type.var = NULL,
  output.dir = "results/figures/"
)
```

## Arguments

- data.matrix:

  Numeric matrix (features x samples).

- hc_metric.var:

  Distance metric for clustering (e.g. `"euclidean"`).

- hc_method.var:

  Agglomeration method (e.g. `"ward.D2"`).

- type.var:

  Optional
  [`ape::plot.phylo()`](https://rdrr.io/pkg/ape/man/plot.phylo.html)
  layout (`"phylogram"`, `"fan"`, `"unrooted"`, `"radial"`); if `NULL`
  only the standard dendrogram is drawn.

- output.dir:

  Directory to write the PDF(s) into (created if needed). Use `NULL` to
  skip writing.

## Value

Invisibly, a list with the `hclust` object and the dendrogram `plot`.

## Examples

``` r
if (FALSE) { # \dontrun{
dendrogram_samples(my_matrix, type.var = "unrooted")
} # }
```
