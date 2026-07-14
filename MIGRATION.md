# v0.2 rebuild — migration status: COMPLETE ✅

Ground-up rebuild to a lighter, tested, documented package. Pattern per function:
snake_case name (primary) + dot.case deprecated alias (in `zzz.R`) + heavy deps
guarded via `requireNamespace()` and moved to `Suggests`. Every batch keeps
`R CMD check` at **Status: OK**.

## Migrated & tested (10 functions)
| snake_case | legacy alias | file | heavy dep (Suggests) |
|---|---|---|---|
| `make_transparent` | `makeTransparent` | colours.R | — |
| `get_batlow` | `Get.batlow` | colours.R | — (fixed global-assign bug) |
| `moving_average` | `calc.moving.average` | moving_average.R | — |
| `standardize` | — | standardize.R | — |
| `basic_heatmap` | `basic.heatmap` | heatmaps.R | gplots |
| `dendrogram_samples` | `dendrogram` | dendrogram.R | factoextra, ape |
| `convert_mouse_to_human` | `convert.mouse.to.human` | gene_ids.R | biomaRt |
| `convert_human_to_mouse` | `convert.human.to.mouse` | gene_ids.R | biomaRt |
| `go_enrichment` | `GO.function` | enrichment.R | clusterProfiler, org.*.eg.db |
| `umap_optimise` | `UMAP.optimise` | single_cell.R | Seurat |

## Migrated in later batches
- Volcano suite, single-cell correlation, and TCGA survival — all done.

## (was) Still to migrate
- **Volcano plots** (volcano.R, ~370 lines): `custom_enhanced_volcano` + helpers
  `clean_volcano_data`, `colour_volcano_points`, `alpha_volcano_points`,
  `size_volcano_points`  (ggplot2 Imports; ggrepel, ggalt → Suggests)
- **Single-cell correlation** (scRNAseq_correlation.R): `sc_correlation`,
  `correlation_heatmaps` + the `plot.cor.data` S3 method  (Seurat → Suggests)
- **TCGA** (TCGA_functions.R, ~450 lines): `tcga_survival`, `download_tcga_rnaseq`,
  `annotate_clinical_data`  (TCGAbiolinks → Suggests; drop the archived-cgdsr code path)

## Intentionally NOT merged from r-bioinformatics-utils
Project-specific / buggy functions that reference undefined globals or hardcode one
dataset's sample names: `reorder.samples`, `get.sample.id`, `boxplot.expression`,
`plot.sig`, `Mm.EG2Symbol`, `combineMeta`, most `Scripts/` analysis templates.
