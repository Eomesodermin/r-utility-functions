# Deprecated dot.case function names

The package originally used dot.case names. They are kept so that
existing scripts keep working, but each call now warns once per session
and forwards to its snake_case replacement. Use the new name in new
code.

## Usage

``` r
makeTransparent(...)

Get.batlow(...)

calc.moving.average(...)

basic.heatmap(...)

dendrogram(...)

convert.mouse.to.human(...)

convert.human.to.mouse(...)

GO.function(...)

UMAP.optimise(...)

clean.data.volcano(...)

colour.points.volcano(...)

alpha.points.volcano(...)

size.points.volcano(...)

custom.enhanced.volcano(...)

sc.correlation(...)

correlation.heatmaps(...)

download.TCGA.RNAseq(...)

TCGA.OS(...)
```

## Arguments

- ...:

  Passed to the replacement function.

## Value

The result of the replacement function.

## Details

|  |  |
|----|----|
| Old name | Use instead |
| `makeTransparent()` | [`make_transparent()`](https://eomesodermin.github.io/r-utility-functions/reference/make_transparent.md) |
| `Get.batlow()` | [`get_batlow()`](https://eomesodermin.github.io/r-utility-functions/reference/get_batlow.md) |
| `calc.moving.average()` | [`moving_average()`](https://eomesodermin.github.io/r-utility-functions/reference/moving_average.md) |
| `basic.heatmap()` | [`basic_heatmap()`](https://eomesodermin.github.io/r-utility-functions/reference/basic_heatmap.md) |
| `dendrogram()` | [`dendrogram_samples()`](https://eomesodermin.github.io/r-utility-functions/reference/dendrogram_samples.md) |
| `convert.mouse.to.human()` | [`convert_mouse_to_human()`](https://eomesodermin.github.io/r-utility-functions/reference/convert_genes.md) |
| `convert.human.to.mouse()` | [`convert_human_to_mouse()`](https://eomesodermin.github.io/r-utility-functions/reference/convert_genes.md) |
| `GO.function()` | [`go_enrichment()`](https://eomesodermin.github.io/r-utility-functions/reference/go_enrichment.md) |
| `UMAP.optimise()` | [`umap_optimise()`](https://eomesodermin.github.io/r-utility-functions/reference/umap_optimise.md) |
| `clean.data.volcano()` | [`clean_volcano_data()`](https://eomesodermin.github.io/r-utility-functions/reference/clean_volcano_data.md) |
| `colour.points.volcano()` | [`colour_volcano_points()`](https://eomesodermin.github.io/r-utility-functions/reference/colour_volcano_points.md) |
| `alpha.points.volcano()` | [`alpha_volcano_points()`](https://eomesodermin.github.io/r-utility-functions/reference/alpha_volcano_points.md) |
| `size.points.volcano()` | [`size_volcano_points()`](https://eomesodermin.github.io/r-utility-functions/reference/size_volcano_points.md) |
| `custom.enhanced.volcano()` | [`custom_enhanced_volcano()`](https://eomesodermin.github.io/r-utility-functions/reference/custom_enhanced_volcano.md) |
| `sc.correlation()` | [`sc_correlation()`](https://eomesodermin.github.io/r-utility-functions/reference/sc_correlation.md) |
| `correlation.heatmaps()` | [`correlation_heatmaps()`](https://eomesodermin.github.io/r-utility-functions/reference/correlation_heatmaps.md) |
| `download.TCGA.RNAseq()` | [`download_tcga_rnaseq()`](https://eomesodermin.github.io/r-utility-functions/reference/download_tcga_rnaseq.md) |
| `TCGA.OS()` | [`tcga_survival()`](https://eomesodermin.github.io/r-utility-functions/reference/tcga_survival.md) |
