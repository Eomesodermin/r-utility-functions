# Download a TCGA RNA-seq dataset

Queries, downloads and prepares a TCGA gene-expression dataset (STAR
counts) via TCGAbiolinks, saving the prepared table to an `.rda` file.

## Usage

``` r
download_tcga_rnaseq(
  dataset.name,
  raw.data.dir = "GDCdata/",
  rda.dir = "data/"
)
```

## Arguments

- dataset.name:

  TCGA project id, e.g. `"TCGA-LAML"`.

- raw.data.dir:

  Directory for the raw GDC download.

- rda.dir:

  Directory to save the prepared `.rda` into.

## Value

The prepared expression table from
[`TCGAbiolinks::GDCprepare()`](https://rdrr.io/pkg/TCGAbiolinks/man/GDCprepare.html).

## Examples

``` r
if (FALSE) { # \dontrun{
download_tcga_rnaseq("TCGA-LAML")
} # }
```
