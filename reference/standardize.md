# Row-wise robust standardisation

Centres each row of a matrix by its median and scales by its median
absolute deviation (MAD) — a robust alternative to a z-score. Rows with
zero MAD (constant values) are returned centred (all zero) instead of
`NaN`.

## Usage

``` r
standardize(z, na.rm = TRUE)
```

## Arguments

- z:

  A numeric matrix (features x samples).

- na.rm:

  Whether to ignore `NA`s when computing the median and MAD.

## Value

A matrix the same shape as `z`, robustly standardised by row.

## Examples

``` r
m <- matrix(c(1, 2, 3, 10, 20, 30), nrow = 2, byrow = TRUE)
standardize(m)
#>            [,1] [,2]      [,3]
#> [1,] -0.6744908    0 0.6744908
#> [2,] -0.6744908    0 0.6744908
# a constant row no longer produces NaN:
standardize(rbind(c(5, 5, 5), c(1, 2, 3)))
#>            [,1] [,2]      [,3]
#> [1,]  0.0000000    0 0.0000000
#> [2,] -0.6744908    0 0.6744908
```
