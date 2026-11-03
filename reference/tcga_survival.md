# Overall-survival analysis of a TCGA cohort

Downloads (or loads) a TCGA dataset, normalises it, stratifies patients
into high and low expressers of a gene or signature (upper vs lower
quartile), and runs a Kaplan-Meier overall-survival analysis.

## Usage

``` r
tcga_survival(
  TCGA.dataset,
  gene.signature,
  gene.name = NULL,
  rda.file.path = NULL,
  plot.dir = "figures/",
  data.dir = "data/"
)
```

## Arguments

- TCGA.dataset:

  TCGA project id, e.g. `"TCGA-LAML"`.

- gene.signature:

  Gene, or vector of genes, defining the signature. With several genes
  the ranking score is the mean z-score (see
  [`stratify_by_expression()`](https://eomesodermin.github.io/r-utility-functions/reference/stratify_by_expression.md)).

- gene.name:

  Optional label (defaults to `gene.signature`).

- rda.file.path:

  Optional path to a prepared `.rda` from
  [`download_tcga_rnaseq()`](https://eomesodermin.github.io/r-utility-functions/reference/download_tcga_rnaseq.md);
  if `NULL`, the data are downloaded.

- plot.dir:

  Directory to save the survival plot into.

- data.dir:

  Directory for downloaded and normalised data.

## Value

Invisibly, the clinical table with the `Signature` (High / Low)
assignment. The survival plot is written to `plot.dir`.

## Examples

``` r
if (FALSE) { # \dontrun{
tcga_survival("TCGA-LAML", gene.signature = "TLR2")
} # }
```
