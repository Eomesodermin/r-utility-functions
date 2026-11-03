# Enhanced volcano plot (deprecated wrapper)

`custom_enhanced_volcano()` is retained for existing scripts. It
forwards the commonly used arguments to
[`volcano_plot()`](https://eomesodermin.github.io/r-utility-functions/reference/volcano_plot.md),
and ignores the rest with a warning. New code should call
[`volcano_plot()`](https://eomesodermin.github.io/r-utility-functions/reference/volcano_plot.md)
directly.

## Usage

``` r
custom_enhanced_volcano(
  toptable,
  lab = rownames(toptable),
  x = "logFC",
  y = "FDR",
  selectLab = NULL,
  xlim = NULL,
  ylim = NULL,
  title = "Volcano plot",
  subtitle = NULL,
  caption = NULL,
  pCutoff = 0.05,
  FCcutoff = 0.25,
  pointSize = 3,
  labSize = 3.5,
  col = c("grey30", "forestgreen", "royalblue", "red2"),
  colCustom = NULL,
  colAlpha = 0.2,
  legendPosition = "top",
  ...
)
```

## Arguments

- toptable:

  Data frame with `x` and `y` columns.

- lab:

  Point labels (defaults to the row names).

- x, y:

  Names of the fold-change and adjusted p-value columns.

- selectLab:

  Genes to label (all points passing both cutoffs if `NULL`).

- xlim, ylim:

  Axis limits.

- title, subtitle, caption:

  Plot annotations.

- pCutoff, FCcutoff:

  Adjusted p-value and absolute log fold change cutoffs.

- pointSize, labSize:

  Point and label sizes.

- col:

  Four group colours (NS, FC, P, FC + P).

- colCustom:

  Per-point colours (see
  [`colour_volcano_points()`](https://eomesodermin.github.io/r-utility-functions/reference/colour_volcano_points.md)).

- colAlpha:

  Point transparency.

- legendPosition:

  Legend position.

- ...:

  Other `EnhancedVolcano`-style arguments, which are ignored.

## Value

A ggplot object.

## See also

[`volcano_plot()`](https://eomesodermin.github.io/r-utility-functions/reference/volcano_plot.md)
