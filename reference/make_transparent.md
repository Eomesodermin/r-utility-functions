# Make a colour transparent

Adds an alpha channel to one or more colours. Vectorised over `color`.

## Usage

``` r
make_transparent(color, percent = 50, name = NULL)
```

## Arguments

- color:

  A colour or vector of colours (names or hex).

- percent:

  Numeric in `[0, 100]`; percentage transparency (0 = opaque). Recycled
  against `color`.

- name:

  Optional name(s) for the returned colour(s).

## Value

A character vector of hex colours with alpha, one per `color`.

## Author

Adapted from Ricardo Oliveros-Ramos.

## Examples

``` r
make_transparent("red", percent = 50)
#> [1] "#FF00007F"
make_transparent(c("red", "blue", "green"), percent = c(25, 50, 75))
#> [1] "#FF0000BF" "#0000FF7F" "#00FF003F"
```
