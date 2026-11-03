# Per-point colours for a volcano plot

Builds a named colour vector marking up/down-regulated (and optionally
selected) genes, in the format expected by the `point_colours` argument
of
[`volcano_plot()`](https://eomesodermin.github.io/r-utility-functions/reference/volcano_plot.md).
The names give each point's group and the values its colour.

## Usage

``` r
colour_volcano_points(
  volcano.data,
  increase.col = "Red",
  decreased.col = "Blue",
  highlight.selected = FALSE,
  selected.cols = c("Green", "Orange"),
  highlight.genes = "NKG7",
  FDR.cutoff = 0.05,
  logFC.cutoff = 1
)
```

## Arguments

- volcano.data:

  Data frame with `FDR` and `logFC`, gene symbols as rownames.

- increase.col, decreased.col:

  Colours for up/down-regulated genes.

- highlight.selected:

  If `TRUE`, recolour the genes in `highlight.genes`.

- selected.cols:

  Length-2 colours for selected up / down genes.

- highlight.genes:

  Character vector of genes to highlight.

- FDR.cutoff, logFC.cutoff:

  Significance thresholds.

## Value

A named character vector of colours (one per row).

## Examples

``` r
df <- data.frame(FDR = c(0.01, 0.5), logFC = c(2, 0),
                 row.names = c("NKG7", "B"))
colour_volcano_points(df)
#> Increased        NS 
#>     "Red"  "grey50" 
```
