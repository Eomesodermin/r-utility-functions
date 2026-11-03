# Plot a correlation ranking

Line plot of ranked correlation values from
[`sc_correlation()`](https://eomesodermin.github.io/r-utility-functions/reference/sc_correlation.md),
highlighting a gene of interest, plus a zoom on the top-correlated
genes.

## Usage

``` r
plot_correlation(
  cor.df,
  output.dir = "output/figures/",
  goi = "NKG7",
  top.n.val = 30
)
```

## Arguments

- cor.df:

  Output of
  [`sc_correlation()`](https://eomesodermin.github.io/r-utility-functions/reference/sc_correlation.md).

- output.dir:

  Directory to write the PDFs into (created if needed). Use `NULL` to
  skip writing.

- goi:

  Gene(s) of interest to highlight.

- top.n.val:

  Number of top-correlated genes to show in the zoom plot.

## Value

Invisibly, a list with the `ranking` and `top` ggplots.

## Examples

``` r
m <- matrix(rnorm(400), nrow = 20,
            dimnames = list(paste0("g", 1:20), paste0("c", 1:20)))
cor_df <- sc_correlation(m, goi = "g1", remove.quantile = 0, output.tables = NULL)
plot_correlation(cor_df, output.dir = NULL, goi = "g1", top.n.val = 5)
```
