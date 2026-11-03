# Prepare a table for volcano plotting

Keeps just the `FDR` and `logFC` columns (optionally only significant
rows), preserving row names so genes can be labelled later.

## Usage

``` r
clean_volcano_data(input.data, sig.only = TRUE)
```

## Arguments

- input.data:

  Data frame with `FDR` and `logFC` columns.

- sig.only:

  If `TRUE`, keep only rows with `FDR < 0.05`.

## Value

A data frame with `FDR` and `logFC`.

## Examples

``` r
df <- data.frame(FDR = c(0.01, 0.2), logFC = c(2, -0.3),
                 row.names = c("A", "B"))
clean_volcano_data(df, sig.only = TRUE)
#>    FDR logFC
#> A 0.01     2
```
