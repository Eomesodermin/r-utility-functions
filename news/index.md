# Changelog

## usefulfunctions 0.3.0

A quality release: correctness fixes found by a much larger test suite,
original replacements for code that was derived from another package,
and a documentation site.

### Breaking or behaviour-changing

- [`tcga_survival()`](https://eomesodermin.github.io/r-utility-functions/reference/tcga_survival.md)
  now splits patients at the true upper and lower quartiles of
  expression. Previously the quartiles were rounded with
  [`floor()`](https://rdrr.io/r/base/Round.html) /
  [`ceiling()`](https://rdrr.io/r/base/Round.html), which classified
  nearly every patient as “high” for genes with low expression (TPM
  below 1). Results for such genes will change.
- [`sc_correlation()`](https://eomesodermin.github.io/r-utility-functions/reference/sc_correlation.md)
  returns genes sorted by decreasing correlation (it was alphabetical),
  drops genes with undefined correlation, always keeps the gene of
  interest when filtering by expression, and writes the CSV without an
  extra row-name column. `output.tables = NULL` skips writing.
  `debug.mode` is ignored.
- The plotting helpers
  ([`umap_optimise()`](https://eomesodermin.github.io/r-utility-functions/reference/umap_optimise.md),
  [`correlation_heatmaps()`](https://eomesodermin.github.io/r-utility-functions/reference/correlation_heatmaps.md),
  [`plot_correlation()`](https://eomesodermin.github.io/r-utility-functions/reference/plot_correlation.md),
  [`dendrogram_samples()`](https://eomesodermin.github.io/r-utility-functions/reference/dendrogram_samples.md))
  no longer rely on
  [`dev.copy()`](https://rdrr.io/r/grDevices/dev2.html) of the active
  graphics device. They return their plots (or paths) and write PDFs to
  `output.dir`; `NULL` skips writing.
- The dot.case names
  ([`makeTransparent()`](https://eomesodermin.github.io/r-utility-functions/reference/legacy_aliases.md),
  [`GO.function()`](https://eomesodermin.github.io/r-utility-functions/reference/legacy_aliases.md),
  [`TCGA.OS()`](https://eomesodermin.github.io/r-utility-functions/reference/legacy_aliases.md),
  …) now warn once per session before forwarding to the snake_case
  function; see
  [`?legacy_aliases`](https://eomesodermin.github.io/r-utility-functions/reference/legacy_aliases.md).

### New

- [`volcano_plot()`](https://eomesodermin.github.io/r-utility-functions/reference/volcano_plot.md):
  an original, compact volcano plot (ggplot2, optional ggrepel) that
  takes the per-point colour, alpha and size helpers.
  [`custom_enhanced_volcano()`](https://eomesodermin.github.io/r-utility-functions/reference/custom_enhanced_volcano.md)
  is now a deprecated wrapper.
- [`stratify_by_expression()`](https://eomesodermin.github.io/r-utility-functions/reference/stratify_by_expression.md):
  high / low sample strata for a gene or a multi-gene signature (mean
  z-score). Multi-gene signatures were previously not implemented in
  [`tcga_survival()`](https://eomesodermin.github.io/r-utility-functions/reference/tcga_survival.md).
- [`tcga_survival()`](https://eomesodermin.github.io/r-utility-functions/reference/tcga_survival.md)
  returns the annotated clinical table invisibly.
- A getting-started vignette and a pkgdown site.
- `jax.table` argument to the ortholog converters for offline use.

### Fixes

- `convert_human_to_mouse(use.jax = TRUE)` converted in the wrong
  direction (mouse to human).
- [`dendrogram_samples()`](https://eomesodermin.github.io/r-utility-functions/reference/dendrogram_samples.md)
  failed with current factoextra (`k` must be at least 2); it now
  clusters with [`hclust()`](https://rdrr.io/r/stats/hclust.html)
  directly.
- [`umap_optimise()`](https://eomesodermin.github.io/r-utility-functions/reference/umap_optimise.md)
  plotted through
  [`Seurat::UMAPPlot()`](https://satijalab.org/seurat/reference/DimPlot.html),
  which fails unless Seurat is attached.
- [`moving_average()`](https://eomesodermin.github.io/r-utility-functions/reference/moving_average.md)
  failed when the window was longer than the vector.
- Deprecated tidyselect usage (`.data$col` inside `select()`) in
  [`clean_volcano_data()`](https://eomesodermin.github.io/r-utility-functions/reference/clean_volcano_data.md).
- Barcode matching in the TCGA helpers no longer depends on stringr, and
  patients with samples in both strata are left unlabelled instead of
  silently assigned to “Low”.

### Removed

- The vendored copy of the `EnhancedVolcano` plotting code (GPL-3) and
  the optional ggalt dependency.
- Build artefacts (`usefulfunctions.Rcheck/`) and internal migration
  notes from the repository.

## usefulfunctions 0.2.0

Ground-up rebuild: heavy Bioconductor dependencies moved to `Suggests`
and checked at call time, snake_case names with dot.case aliases, unit
tests and continuous integration.
