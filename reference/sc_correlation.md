# Gene-gene correlation across single cells

Correlates a gene of interest against all (sufficiently expressed) genes
in a normalised expression matrix, returning correlation, p-value and
FDR.

## Usage

``` r
sc_correlation(
  data.slot,
  goi = "NKG7",
  remove.quantile = 0.3,
  output.tables = "results/tables/Correlation_analysis/",
  debug.mode = FALSE,
  method = c("pearson", "spearman", "kendall")
)
```

## Arguments

- data.slot:

  Numeric expression matrix (genes x cells), e.g. a downsampled Seurat
  `data` layer as a matrix.

- goi:

  Gene of interest (a rowname of `data.slot`).

- remove.quantile:

  Drop genes whose mean expression is in the lowest fraction before
  testing.

- output.tables:

  Directory to write the results CSV into (created if needed). Use
  `NULL` to skip writing.

- debug.mode:

  Deprecated and ignored.

- method:

  Correlation method: "pearson" (default), "spearman" or "kendall".

## Value

A data frame with `GeneID`, `Cor.val`, `P.val` and `FDR`, sorted by
decreasing correlation. Genes with undefined correlation (zero variance)
are dropped.

## Examples

``` r
m <- matrix(rnorm(50), nrow = 5,
            dimnames = list(paste0("g", 1:5), paste0("c", 1:10)))
sc_correlation(m, goi = "g1", output.tables = NULL)
#>   GeneID    Cor.val     P.val       FDR
#> 1     g1  1.0000000 0.0000000 0.0000000
#> 2     g4  0.3895636 0.2658045 0.2658045
#> 3     g2 -0.4046410 0.2460947 0.2658045
```
