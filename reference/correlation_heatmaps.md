# Heatmaps of top correlated genes

Draws Seurat heatmaps of the most positively and negatively correlated
genes from
[`sc_correlation()`](https://eomesodermin.github.io/r-utility-functions/reference/sc_correlation.md),
using the batlow palette.

## Usage

``` r
correlation_heatmaps(
  seurat.object,
  correlation.df,
  up.n = 20,
  dn.n = 20,
  goi = "NKG7",
  output.dir = "results/figures/Correlation_analysis/"
)
```

## Arguments

- seurat.object:

  A Seurat object (idents/assay pre-set, ideally downsampled).

- correlation.df:

  Output of
  [`sc_correlation()`](https://eomesodermin.github.io/r-utility-functions/reference/sc_correlation.md).

- up.n, dn.n:

  Number of up / down correlated genes to show.

- goi:

  Gene of interest.

- output.dir:

  Directory to write the PDFs into (created if needed). Use `NULL` to
  skip writing.

## Value

Invisibly, a list with the `up` and `down` heatmap plots.

## Examples

``` r
if (FALSE) { # \dontrun{
correlation_heatmaps(small_seurat, cor_df, up.n = 20, goi = "NKG7")
} # }
```
