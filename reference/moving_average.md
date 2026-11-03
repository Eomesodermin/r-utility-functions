# Moving average of a numeric vector

Computes a moving average that ignores `NA` values inside each window,
so a window containing some missing values still returns the mean of the
observed ones. Adapted from Riesenberg et al., Nat. Commun. 2015
(doi:10.1038/ncomms9755) and cookbook-r.com.

## Usage

``` r
moving_average(x, n = 1, centered = FALSE)
```

## Arguments

- x:

  A numeric vector.

- n:

  Window size: a positive integer number of values to average over.

- centered:

  If `TRUE`, centre the window on each point; otherwise use a trailing
  window that ends at each point.

## Value

A numeric vector the same length as `x`. Positions whose whole window is
`NA` return `NaN`.

## Examples

``` r
moving_average(c(1, 2, 3, 4, 5), n = 3)
#> [1] 1.0 1.5 2.0 3.0 4.0
moving_average(c(1, NA, 3, 4, 5), n = 2, centered = TRUE)
#> [1] 1.0 3.0 3.5 4.5 5.0
```
