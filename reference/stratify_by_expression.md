# Split samples into high and low expressers of a gene or signature

Ranks samples by the expression of one gene, or by a signature score for
several genes (the mean of each gene's z-score across samples), and
returns the samples in the top and bottom quantile.

## Usage

``` r
stratify_by_expression(expr, genes, quantile = 0.25)
```

## Arguments

- expr:

  Numeric matrix or data frame of expression (genes x samples), with
  gene symbols as row names and sample identifiers as column names.

- genes:

  One or more gene symbols present in `rownames(expr)`.

- quantile:

  Fraction of samples in each tail; `0.25` gives the upper and lower
  quartiles.

## Value

A list with the sample names in `high` and `low`, and the per-sample
`score` used for ranking.

## Examples

``` r
set.seed(1)
expr <- matrix(rexp(200), nrow = 4,
               dimnames = list(c("NKG7", "GZMB", "CD3E", "ACTB"), paste0("s", 1:50)))
strata <- stratify_by_expression(expr, "NKG7")
lengths(strata[c("high", "low")])
#> high  low 
#>   13   13 
stratify_by_expression(expr, c("NKG7", "GZMB"))$high
#>  [1] "s2"  "s4"  "s6"  "s14" "s17" "s19" "s22" "s23" "s27" "s38" "s39" "s43"
#> [13] "s44"
```
