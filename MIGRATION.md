# v0.2 rebuild — migration status

Ground-up rebuild to a lighter, tested, documented package. Pattern per function:
snake_case name (primary) + dot.case deprecated alias + heavy deps guarded (`Suggests`).

## Migrated & tested (R CMD check: OK)
- `make_transparent()`  (alias `makeTransparent`)
- `get_batlow()`        (alias `Get.batlow`; fixed global-assign bug)
- `moving_average()`    (alias `calc.moving.average`)

## Pending migration (present on `main`, to port onto this base)
- Volcano plots: `custom_enhanced_volcano` + point helpers  (ggplot2, ggrepel → Suggests)
- Heatmaps: `basic_heatmap`  (gplots → Suggests)
- Dendrograms: `dendrogram_samples`  (factoextra, ape → Suggests)
- Gene IDs: `convert_human_to_mouse` / `convert_mouse_to_human`  (biomaRt → Suggests)
- Enrichment: `go_enrichment`  (clusterProfiler, org.*.eg.db → Suggests)
- TCGA: `tcga_survival`, `download_tcga_rnaseq`, `annotate_clinical_data`  (TCGAbiolinks → Suggests)
- Single-cell: `umap_optimise`, `sc_correlation`, `correlation_heatmaps`  (Seurat → Suggests)
- Curated merges from `r-bioinformatics-utils`: `combine_meta`, `get_clonotypes`, `standardize`
  (project-specific/buggy functions there are intentionally NOT merged)
