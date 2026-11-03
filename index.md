# usefulfunctions

An R package of tested helpers for single-cell, bulk RNA-seq and
cancer-genomics analyses: volcano plots, gene-gene correlation, Gene
Ontology over-representation, mouse-human ortholog conversion, TCGA
overall-survival analysis and UMAP parameter sweeps. It started as the
shared code behind the analysis repositories in this account and is kept
small, documented and covered by tests.

**Documentation:** <https://eomesodermin.github.io/r-utility-functions/>

## Design

- **Light install.** Only ggplot2, dplyr and a few small packages are
  required. Seurat, clusterProfiler, biomaRt, TCGAbiolinks and the other
  heavy dependencies are optional; each function checks for what it
  needs when called and says what to install.
- **Functions return objects.** Plot functions return ggplot objects (or
  the paths they wrote) rather than only drawing to the active device,
  so results can be tested and reused.
- **Tested.** Pure logic (stratification, ortholog lookup, barcode
  handling, plot construction) is unit tested; calls to external
  services are isolated so they can be mocked.

## Installation

``` r

# install.packages("remotes")
remotes::install_github("Eomesodermin/r-utility-functions")
```

## Examples

``` r

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

The [getting-started
vignette](https://eomesodermin.github.io/r-utility-functions/articles/usefulfunctions.html)
walks through these on simulated data.

## Function overview

| Area | Functions |
|----|----|
| Plots | [`volcano_plot()`](https://eomesodermin.github.io/r-utility-functions/reference/volcano_plot.md), [`basic_heatmap()`](https://eomesodermin.github.io/r-utility-functions/reference/basic_heatmap.md), [`dendrogram_samples()`](https://eomesodermin.github.io/r-utility-functions/reference/dendrogram_samples.md), [`plot_correlation()`](https://eomesodermin.github.io/r-utility-functions/reference/plot_correlation.md) |
| Volcano helpers | [`clean_volcano_data()`](https://eomesodermin.github.io/r-utility-functions/reference/clean_volcano_data.md), [`colour_volcano_points()`](https://eomesodermin.github.io/r-utility-functions/reference/colour_volcano_points.md), [`alpha_volcano_points()`](https://eomesodermin.github.io/r-utility-functions/reference/alpha_volcano_points.md), [`size_volcano_points()`](https://eomesodermin.github.io/r-utility-functions/reference/size_volcano_points.md) |
| Single cell | [`sc_correlation()`](https://eomesodermin.github.io/r-utility-functions/reference/sc_correlation.md), [`correlation_heatmaps()`](https://eomesodermin.github.io/r-utility-functions/reference/correlation_heatmaps.md), [`umap_optimise()`](https://eomesodermin.github.io/r-utility-functions/reference/umap_optimise.md) |
| Enrichment, identifiers | [`go_enrichment()`](https://eomesodermin.github.io/r-utility-functions/reference/go_enrichment.md), [`convert_mouse_to_human()`](https://eomesodermin.github.io/r-utility-functions/reference/convert_genes.md), [`convert_human_to_mouse()`](https://eomesodermin.github.io/r-utility-functions/reference/convert_genes.md) |
| TCGA | [`tcga_survival()`](https://eomesodermin.github.io/r-utility-functions/reference/tcga_survival.md), [`download_tcga_rnaseq()`](https://eomesodermin.github.io/r-utility-functions/reference/download_tcga_rnaseq.md), [`stratify_by_expression()`](https://eomesodermin.github.io/r-utility-functions/reference/stratify_by_expression.md) |
| Utilities | [`make_transparent()`](https://eomesodermin.github.io/r-utility-functions/reference/make_transparent.md), [`get_batlow()`](https://eomesodermin.github.io/r-utility-functions/reference/get_batlow.md), [`moving_average()`](https://eomesodermin.github.io/r-utility-functions/reference/moving_average.md), [`standardize()`](https://eomesodermin.github.io/r-utility-functions/reference/standardize.md) |

Earlier dot.case names such as
[`makeTransparent()`](https://eomesodermin.github.io/r-utility-functions/reference/legacy_aliases.md)
and
[`TCGA.OS()`](https://eomesodermin.github.io/r-utility-functions/reference/legacy_aliases.md)
still work and warn once per session; see
[`?legacy_aliases`](https://eomesodermin.github.io/r-utility-functions/reference/legacy_aliases.md)
and
[`NEWS.md`](https://eomesodermin.github.io/r-utility-functions/NEWS.md)
for what changed in each release.

## Development

``` r

devtools::document()   # regenerate man/ and NAMESPACE
devtools::test()       # run the test suite
devtools::check()      # R CMD check
lintr::lint_package()
```

## Citation

See
[`CITATION.cff`](https://eomesodermin.github.io/r-utility-functions/CITATION.cff).
Released under the [MIT
License](https://eomesodermin.github.io/r-utility-functions/LICENSE.md).
