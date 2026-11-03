# Per-point alpha for a volcano plot

Per-point alpha for a volcano plot

## Usage

``` r
alpha_volcano_points(
  input.data,
  highlight.genes = "NKG7",
  baseline.alpha = 0.1,
  highlight.alpha = 1
)
```

## Arguments

- input.data:

  Data frame with gene symbols as rownames.

- highlight.genes:

  Genes to draw opaque.

- baseline.alpha, highlight.alpha:

  Alpha for background / highlighted genes.

## Value

A numeric vector of alpha values (one per row).

## Examples

``` r
df <- data.frame(x = 1:2, row.names = c("NKG7", "B"))
alpha_volcano_points(df, highlight.genes = "NKG7")
#> [1] 1.0 0.1
```
