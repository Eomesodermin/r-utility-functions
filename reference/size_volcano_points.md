# Per-point size for a volcano plot

Per-point size for a volcano plot

## Usage

``` r
size_volcano_points(
  input.data,
  highlight.genes = "NKG7",
  baseline.size = 5,
  highlight.size = 5
)
```

## Arguments

- input.data:

  Data frame with gene symbols as rownames.

- highlight.genes:

  Genes to resize.

- baseline.size, highlight.size:

  Point size for background / highlighted genes.

## Value

A numeric vector of point sizes (one per row).

## Examples

``` r
df <- data.frame(x = 1:2, row.names = c("NKG7", "B"))
size_volcano_points(df, highlight.genes = "NKG7", highlight.size = 8)
#> [1] 8 5
```
