# usefulfunctions

<!-- badges: start -->
[![R-CMD-check](https://github.com/Eomesodermin/r-utility-functions/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Eomesodermin/r-utility-functions/actions/workflows/R-CMD-check.yaml)
[![lint-and-coverage](https://github.com/Eomesodermin/r-utility-functions/actions/workflows/lint-coverage.yaml/badge.svg)](https://github.com/Eomesodermin/r-utility-functions/actions/workflows/lint-coverage.yaml)
[![pkgdown](https://github.com/Eomesodermin/r-utility-functions/actions/workflows/pkgdown.yaml/badge.svg)](https://eomesodermin.github.io/r-utility-functions/)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE.md)
<!-- badges: end -->

An R package of tested helpers for single-cell, bulk RNA-seq and cancer-genomics analyses: volcano
plots, gene-gene correlation, Gene Ontology over-representation, mouse-human ortholog conversion,
TCGA overall-survival analysis and UMAP parameter sweeps. It started as the shared code behind the
analysis repositories in this account and is kept small, documented and covered by tests.

**Documentation:** <https://eomesodermin.github.io/r-utility-functions/>

## Design

- **Light install.** Only ggplot2, dplyr and a few small packages are required. Seurat,
  clusterProfiler, biomaRt, TCGAbiolinks and the other heavy dependencies are optional; each
  function checks for what it needs when called and says what to install.
- **Functions return objects.** Plot functions return ggplot objects (or the paths they wrote)
  rather than only drawing to the active device, so results can be tested and reused.
- **Tested.** Pure logic (stratification, ortholog lookup, barcode handling, plot construction) is
  unit tested; calls to external services are isolated so they can be mocked.

## Installation

```r
# install.packages("remotes")
remotes::install_github("Eomesodermin/r-utility-functions")
```

## Examples

```r
library(usefulfunctions)

# Volcano plot with a highlighted gene
res <- data.frame(logFC = rnorm(500), FDR = runif(500)^3, row.names = paste0("gene", 1:500))
volcano_plot(res, fc_cutoff = 1, label_genes = "gene1")

# Genes correlated with NKG7 across cells, ranked
cor_df <- sc_correlation(expr_matrix, goi = "NKG7", output.tables = NULL)
plot_correlation(cor_df, output.dir = NULL, goi = "NKG7")

# TCGA overall survival, high versus low expression of a gene or signature
tcga_survival("TCGA-LAML", gene.signature = c("NKG7", "GZMB"))
```

The [getting-started vignette](https://eomesodermin.github.io/r-utility-functions/articles/usefulfunctions.html)
walks through these on simulated data.

## Function overview

| Area | Functions |
|---|---|
| Plots | `volcano_plot()`, `basic_heatmap()`, `dendrogram_samples()`, `plot_correlation()` |
| Volcano helpers | `clean_volcano_data()`, `colour_volcano_points()`, `alpha_volcano_points()`, `size_volcano_points()` |
| Single cell | `sc_correlation()`, `correlation_heatmaps()`, `umap_optimise()` |
| Enrichment, identifiers | `go_enrichment()`, `convert_mouse_to_human()`, `convert_human_to_mouse()` |
| TCGA | `tcga_survival()`, `download_tcga_rnaseq()`, `stratify_by_expression()` |
| Utilities | `make_transparent()`, `get_batlow()`, `moving_average()`, `standardize()` |

Earlier dot.case names such as `makeTransparent()` and `TCGA.OS()` still work and warn once per
session; see `?legacy_aliases` and [`NEWS.md`](NEWS.md) for what changed in each release.

## Development

```r
devtools::document()   # regenerate man/ and NAMESPACE
devtools::test()       # run the test suite
devtools::check()      # R CMD check
lintr::lint_package()
```

## Citation

See [`CITATION.cff`](CITATION.cff). Released under the [MIT License](LICENSE.md).
