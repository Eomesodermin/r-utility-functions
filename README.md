# usefulfunctions

[![R-CMD-check](https://github.com/Eomesodermin/r-utility-functions/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Eomesodermin/r-utility-functions/actions/workflows/R-CMD-check.yaml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html)

A curated R package of reusable helper functions and thin wrappers for immunology
and cancer-genomics analysis — colour handling, differential-expression volcano
plots, heatmaps, dendrograms, gene-ID conversion, gene-set enrichment, TCGA
survival analysis, and single-cell (Seurat) helpers.

**Installs light.** Heavy Bioconductor dependencies (Seurat, TCGAbiolinks,
biomaRt, clusterProfiler, org.\*.eg.db, …) are optional — each function checks for
the packages it needs at call time, so the base install is quick.

## Installation

```r
# install.packages("devtools")
devtools::install_github("Eomesodermin/r-utility-functions")
library(usefulfunctions)
```

## Function overview

| Area | Functions |
|---|---|
| **Colours** | `make_transparent()`, `get_batlow()` |
| **Transforms** | `moving_average()`, `standardize()` |
| **Heatmaps / dendrograms** | `basic_heatmap()`, `dendrogram_samples()` |
| **Volcano plots** | `custom_enhanced_volcano()`, `clean_volcano_data()`, `colour_volcano_points()`, `alpha_volcano_points()`, `size_volcano_points()` |
| **Gene IDs** | `convert_mouse_to_human()`, `convert_human_to_mouse()` |
| **Enrichment** | `go_enrichment()` |
| **TCGA** | `tcga_survival()`, `download_tcga_rnaseq()` |
| **Single-cell** | `umap_optimise()`, `sc_correlation()`, `correlation_heatmaps()`, `plot_correlation()` |

Every function is documented (`?function_name`). The previous dot.case names
(`makeTransparent`, `GO.function`, `TCGA.OS`, …) remain as **deprecated aliases**,
so existing scripts keep working.

## Example

```r
# Robustly standardise an expression matrix, then plot a heatmap
z <- standardize(expr_matrix)
basic_heatmap(z, Col.cluster = TRUE, Row.cluster = TRUE)

# Gene-gene correlation across single cells
cor_df <- sc_correlation(seurat_data_matrix, goi = "NKG7")
```

---
Author: **Dillon Corvino** · [dilloncorvino.com](https://dilloncorvino.com)
