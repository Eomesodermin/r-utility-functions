# usefulfunctions 0.3.0

A quality release: correctness fixes found by a much larger test suite, original replacements
for code that was derived from another package, and a documentation site.

## Breaking or behaviour-changing

* `tcga_survival()` now splits patients at the true upper and lower quartiles of expression.
  Previously the quartiles were rounded with `floor()` / `ceiling()`, which classified nearly every
  patient as "high" for genes with low expression (TPM below 1). Results for such genes will change.
* `sc_correlation()` returns genes sorted by decreasing correlation (it was alphabetical),
  drops genes with undefined correlation, always keeps the gene of interest when filtering by
  expression, and writes the CSV without an extra row-name column. `output.tables = NULL` skips
  writing. `debug.mode` is ignored.
* The plotting helpers (`umap_optimise()`, `correlation_heatmaps()`, `plot_correlation()`,
  `dendrogram_samples()`) no longer rely on `dev.copy()` of the active graphics device. They return
  their plots (or paths) and write PDFs to `output.dir`; `NULL` skips writing.
* The dot.case names (`makeTransparent()`, `GO.function()`, `TCGA.OS()`, ...) now warn once per
  session before forwarding to the snake_case function; see `?legacy_aliases`.

## New

* `volcano_plot()`: an original, compact volcano plot (ggplot2, optional ggrepel) that takes the
  per-point colour, alpha and size helpers. `custom_enhanced_volcano()` is now a deprecated wrapper.
* `stratify_by_expression()`: high / low sample strata for a gene or a multi-gene signature (mean
  z-score). Multi-gene signatures were previously not implemented in `tcga_survival()`.
* `tcga_survival()` returns the annotated clinical table invisibly.
* A getting-started vignette and a pkgdown site.
* `jax.table` argument to the ortholog converters for offline use.

## Fixes

* `convert_human_to_mouse(use.jax = TRUE)` converted in the wrong direction (mouse to human).
* `dendrogram_samples()` failed with current factoextra (`k` must be at least 2); it now clusters
  with `hclust()` directly.
* `umap_optimise()` plotted through `Seurat::UMAPPlot()`, which fails unless Seurat is attached.
* `moving_average()` failed when the window was longer than the vector.
* Deprecated tidyselect usage (`.data$col` inside `select()`) in `clean_volcano_data()`.
* Barcode matching in the TCGA helpers no longer depends on stringr, and patients with samples in
  both strata are left unlabelled instead of silently assigned to "Low".

## Removed

* The vendored copy of the `EnhancedVolcano` plotting code (GPL-3) and the optional ggalt dependency.
* Build artefacts (`usefulfunctions.Rcheck/`) and internal migration notes from the repository.

# usefulfunctions 0.2.0

Ground-up rebuild: heavy Bioconductor dependencies moved to `Suggests` and checked at call time,
snake_case names with dot.case aliases, unit tests and continuous integration.
