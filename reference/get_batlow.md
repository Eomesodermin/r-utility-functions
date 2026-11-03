# Batlow colour palette

Returns `n` colours from the perceptually-uniform scico "batlow"
palette.

## Usage

``` r
get_batlow(n = 100, rev = FALSE)
```

## Arguments

- n:

  Number of colours to return (\>= 1).

- rev:

  If `TRUE`, reverse the palette order.

## Value

A character vector of hex colours.

## Examples

``` r
get_batlow(5)
#> [1] "#001959" "#215F61" "#818231" "#F19D6B" "#F9CCF9"
get_batlow(5, rev = TRUE)
#> [1] "#F9CCF9" "#F19D6B" "#818231" "#215F61" "#001959"
```
