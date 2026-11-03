# Gene Ontology over-representation analysis

Runs a GO over-representation test (via
[`clusterProfiler::enrichGO()`](https://rdrr.io/pkg/clusterProfiler/man/enrichGO.html))
on the top-ranked genes of a marker table, and either plots the top
terms or returns the full result.

## Usage

``` r
go_enrichment(
  markers,
  topn = 1000,
  org = c("human", "mouse"),
  title.var = "",
  plot = TRUE,
  ontology.type = "BP",
  ...
)
```

## Arguments

- markers:

  Data frame with a `gene` (SYMBOL) column and an `FDR` column.

- topn:

  Number of top genes (by `FDR`) to test.

- org:

  Either `"human"` or `"mouse"`.

- title.var:

  Plot title.

- plot:

  If `TRUE`, return a ggplot of the top terms; if `FALSE`, return the
  `enrichResult` object.

- ontology.type:

  GO ontology to test: `"BP"`, `"MF"`, or `"CC"`.

- ...:

  Further arguments passed to
  [`clusterProfiler::enrichGO()`](https://rdrr.io/pkg/clusterProfiler/man/enrichGO.html).

## Value

A ggplot (if `plot = TRUE`) or a clusterProfiler `enrichResult`.

## Examples

``` r
if (FALSE) { # \dontrun{
go_enrichment(my_markers, org = "human", ontology.type = "BP")
} # }
```
