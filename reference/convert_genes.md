# Convert gene symbols between mouse and human

Maps orthologous gene symbols between mouse (MGI) and human (HGNC) using
Ensembl BioMart, or the Jackson Laboratory homology report as an
alternative when the Ensembl servers are unreachable.

## Usage

``` r
convert_mouse_to_human(genes, use.jax = FALSE, jax.table = NULL)

convert_human_to_mouse(genes, use.jax = FALSE, jax.table = NULL)
```

## Arguments

- genes:

  Character vector of gene symbols to convert.

- use.jax:

  If `TRUE`, use the JAX `HOM_MouseHumanSequence` report instead of
  BioMart.

- jax.table:

  Optional data frame holding the JAX report (as read by
  [`utils::read.delim()`](https://rdrr.io/r/utils/read.table.html)). If
  `NULL` the report is downloaded. Supplying it avoids the download and
  makes the conversion reproducible offline.

## Value

With BioMart, a data frame with one row per ortholog pair (`MGI.symbol`,
`HGNC.symbol` or the reverse). With `use.jax = TRUE`, a character vector
of the converted symbols.

## Details

Both directions keep one row per source symbol and per target symbol
(the first match), so one-to-many orthologs are collapsed.

## Examples

``` r
if (FALSE) { # \dontrun{
convert_mouse_to_human(c("Gzma", "Gzmb", "Xcl1"))
convert_human_to_mouse(c("GZMA", "GZMB", "XCL1"))
} # }
```
