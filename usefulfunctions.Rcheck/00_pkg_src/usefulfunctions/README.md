# r-utility-functions

An R package (`usefulfunctions`) bundling reusable helper functions I use regularly across
bioinformatics and single-cell analysis. Packaging them keeps analysis code clean and
reproducible — several published and in-preparation manuscripts rely on functions from this
repository, so it is made public in the interest of open, transparent science.

## Installation
```r
# install.packages("devtools")
devtools::install_github("Eomesodermin/r-utility-functions")
library(usefulfunctions)
```

## Function overview
| Function | Description |
|---|---|
| `basic.heatmap()` | Quick, sensible-default heatmaps |
| `volcano()` / `clean.data.volcano()` / `alpha.points.volcano()` | Differential-expression volcano plots with transparency handling |
| `GO.function()` | Gene Ontology enrichment wrapper |
| `Convert_Gene_IDs` helpers | Interconvert gene identifiers (symbol / ENSEMBL / Entrez) |
| `UMAP.optimise()` | Grid-search UMAP hyper-parameters for single-cell embeddings |
| `scRNAseq_correlation` | Correlation utilities for single-cell expression |
| `TCGA.OS()` / `annotate.clinical.data()` | TCGA overall-survival analysis + clinical annotation |
| `calc.moving.average()` | Moving-average smoothing (e.g. expression vs. survival) |
| `Get.batlow()` / colour-scheme helpers | Perceptually-uniform colour schemes |
| `makeTransparent()` | Add alpha to any colour |
| Dendrogram helpers | Hierarchical clustering / dendrogram plotting |

Full documentation is available via `?function.name` after loading the package (see `man/`).

## Scope
These functions are primarily designed for my own workflows but are shared openly. Contributions
and issues are welcome, though the API may change.

---
Author: **Dillon Corvino** · [dilloncorvino.com](https://dilloncorvino.com)
