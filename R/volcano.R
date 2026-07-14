#' Prepare a table for volcano plotting
#'
#' Keeps just the `FDR` and `logFC` columns (optionally only significant rows).
#'
#' @param input.data Data frame with `FDR` and `logFC` columns.
#' @param sig.only If `TRUE`, keep only rows with `FDR < 0.05`.
#' @return A data frame with `FDR` and `logFC`.
#' @examples
#' df <- data.frame(FDR = c(0.01, 0.2), logFC = c(2, -0.3),
#'                  row.names = c("A", "B"))
#' clean_volcano_data(df, sig.only = TRUE)
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @export
clean_volcano_data <- function(input.data, sig.only = TRUE) {
  if (!all(c("FDR", "logFC") %in% names(input.data))) {
    stop("`input.data` must contain 'FDR' and 'logFC' columns.", call. = FALSE)
  }
  if (sig.only) {
    input.data %>%
      dplyr::filter(.data$FDR < 0.05) %>%
      dplyr::select(.data$FDR, .data$logFC)
  } else {
    input.data %>% dplyr::select(.data$FDR, .data$logFC)
  }
}

#' Per-point colours for a volcano plot
#'
#' Builds a named colour vector marking up/down-regulated (and optionally
#' selected) genes, in the `colCustom` format expected by
#' [custom_enhanced_volcano()].
#'
#' @param volcano.data Data frame with `FDR` and `logFC`, gene symbols as rownames.
#' @param increase.col,decreased.col Colours for up/down-regulated genes.
#' @param highlight.selected If `TRUE`, recolour the genes in `highlight.genes`.
#' @param selected.cols Length-2 colours for selected up / down genes.
#' @param highlight.genes Character vector of genes to highlight.
#' @param FDR.cutoff,logFC.cutoff Significance thresholds.
#' @return A named character vector of colours (one per row).
#' @examples
#' df <- data.frame(FDR = c(0.01, 0.5), logFC = c(2, 0),
#'                  row.names = c("NKG7", "B"))
#' colour_volcano_points(df)
#' @export
colour_volcano_points <- function(volcano.data, increase.col = "Red",
                                  decreased.col = "Blue", highlight.selected = FALSE,
                                  selected.cols = c("Green", "Orange"),
                                  highlight.genes = "NKG7", FDR.cutoff = 0.05,
                                  logFC.cutoff = 1) {
  keyvals <- rep("grey50", nrow(volcano.data))
  names(keyvals) <- rep("NS", nrow(volcano.data))
  up <- volcano.data$logFC > logFC.cutoff & volcano.data$FDR < FDR.cutoff
  dn <- volcano.data$logFC < -logFC.cutoff & volcano.data$FDR < FDR.cutoff
  keyvals[up] <- increase.col;  names(keyvals)[up] <- "Increased"
  keyvals[dn] <- decreased.col; names(keyvals)[dn] <- "Decreased"
  if (highlight.selected) {
    sel <- rownames(volcano.data) %in% highlight.genes
    keyvals[up & sel] <- selected.cols[1]; names(keyvals)[up & sel] <- "selected_up"
    keyvals[dn & sel] <- selected.cols[2]; names(keyvals)[dn & sel] <- "selected_down"
  }
  keyvals
}

#' Per-point alpha for a volcano plot
#'
#' @param input.data Data frame with gene symbols as rownames.
#' @param highlight.genes Genes to draw opaque.
#' @param baseline.alpha,highlight.alpha Alpha for background / highlighted genes.
#' @return A numeric vector of alpha values (one per row).
#' @examples
#' df <- data.frame(x = 1:2, row.names = c("NKG7", "B"))
#' alpha_volcano_points(df, highlight.genes = "NKG7")
#' @export
alpha_volcano_points <- function(input.data, highlight.genes = "NKG7",
                                 baseline.alpha = 0.1, highlight.alpha = 1) {
  out <- rep(baseline.alpha, nrow(input.data))
  out[rownames(input.data) %in% highlight.genes] <- highlight.alpha
  out
}

#' Per-point size for a volcano plot
#'
#' @param input.data Data frame with gene symbols as rownames.
#' @param highlight.genes Genes to resize.
#' @param baseline.size,highlight.size Point size for background / highlighted genes.
#' @return A numeric vector of point sizes (one per row).
#' @examples
#' df <- data.frame(x = 1:2, row.names = c("NKG7", "B"))
#' size_volcano_points(df, highlight.genes = "NKG7", highlight.size = 8)
#' @export
size_volcano_points <- function(input.data, highlight.genes = "NKG7",
                                baseline.size = 5, highlight.size = 5) {
  out <- rep(baseline.size, nrow(input.data))
  out[rownames(input.data) %in% highlight.genes] <- highlight.size
  out
}

#' @title Custom default settings for enhanced volcano plot
#' @author Kevin Blighe, Sharmila Rana, Myles Lewis, authors of EnhancedVolcano package
#'
#' @description Enhanced volcano plot
#'
#'
#'
#'
#' @param toptable A data.frame with the columns 'logFC' and 'FDR'
#' @param lab A character vector of labels for the points
#' @param x A character vector of the column name for the x-axis
#' @param y A character vector of the column name for the y-axis
#' @param selectLab A character vector of labels to be selected
#' @param xlim A numeric vector of length 2 for the x-axis limits
#' @param ylim A numeric vector of length 2 for the y-axis limits
#' @param xlab A character vector of the x-axis label
#' @param ylab A character vector of the y-axis label
#' @param axisLabSize A numeric value for the axis label size
#' @param title A character vector of the plot title
#' @param subtitle A character vector of the plot subtitle
#' @param caption A character vector of the plot caption
#' @param titleLabSize A numeric value for the title label size
#' @param subtitleLabSize A numeric value for the subtitle label size
#' @param captionLabSize A numeric value for the caption label size
#' @param pCutoff A numeric value for the p-value cutoff
#' @param FCcutoff A numeric value for the fold change cutoff
#' @param cutoffLineType A character vector of the cutoff line type
#' @param cutoffLineCol A character vector of the cutoff line color
#' @param cutoffLineWidth A numeric value for the cutoff line width
#' @param pointSize A numeric value for the point size
#' @param labSize A numeric value for the label size
#' @param labCol A character vector of the label color
#' @param labFace A character vector of the label face
#' @param labhjust A numeric value for the label horizontal justification
#' @param labvjust A numeric value for the label vertical justification
#' @param boxedLabels A logical value for boxed labels
#' @param shape A numeric value for the point shape
#' @param shapeCustom A numeric vector of the custom point shape
#' @param col A character vector of the point color
#' @param colCustom A character vector of the custom point color
#' @param colAlpha A numeric value for the point color alpha
#' @param colGradient A character vector of the point color gradient
#' @param colGradientBreaks A numeric vector of the point color gradient breaks
#' @param colGradientLabels A character vector of the point color gradient labels
#' @param colGradientLimits A numeric vector of the point color gradient limits
#' @param legendLabels A character vector of the legend labels
#' @param legendPosition A character vector of the legend position
#' @param legendLabSize A numeric value for the legend label size
#' @param legendIconSize A numeric value for the legend icon size
#' @param encircle A character vector of the labels to be encircled
#' @param encircleCol A character vector of the encircle color
#' @param encircleFill A character vector of the encircle fill
#' @param encircleAlpha A numeric value for the encircle alpha
#' @param encircleSize A numeric value for the encircle size
#' @param shade A character vector of the labels to be shaded
#' @param shadeFill A character vector of the shade fill
#' @param shadeAlpha A numeric value for the shade alpha
#' @param shadeSize A numeric value for the shade size
#' @param shadeBins A numeric value for the shade bins
#' @param drawConnectors A logical value for drawing connectors
#' @param widthConnectors A numeric value for the connector width
#' @param typeConnectors A character vector of the connector type
#' @param endsConnectors A character vector of the connector ends
#' @param lengthConnectors A numeric value for the connector length
#' @param colConnectors A character vector of the connector color
#' @param arrowheads A logical value for arrowheads
#' @param hline A numeric value for the horizontal line
#' @param hlineType A character vector of the horizontal line type
#' @param hlineCol A character vector of the horizontal line color
#' @param hlineWidth A numeric value for the horizontal line width
#' @param vline A numeric value for the vertical line
#' @param vlineType A character vector of the vertical line type
#' @param vlineCol A character vector of the vertical line color
#' @param vlineWidth A numeric value for the vertical line width
#' @param gridlines.major A logical value for major gridlines
#' @param gridlines.minor A logical value for minor gridlines
#' @param border A character vector of the border
#' @param borderWidth A numeric value for the border width
#' @param borderColour A character vector of the border color
#' @return A ggplot object
#' @import ggplot2
#' @examples
#' \dontrun{
#' custom_enhanced_volcano(my_toptable, FCcutoff = 1, title = "A vs B")
#' }
#' @export

custom_enhanced_volcano <- function(toptable,
                                    lab = rownames(toptable),
                                    x = 'logFC',
                                    y = "FDR",
                                    selectLab = NULL,
                                    xlim = c(min(toptable[[x]], na.rm = TRUE) - 1.5, max(toptable[[x]], na.rm = TRUE) + 1.5),
                                    ylim = c(0, max(-log10(toptable[[y]]), na.rm = TRUE) + 5),
                                    xlab = bquote(~Log[2] ~ "fold change"),
                                    ylab = bquote(~-Log[10]~adjusted~italic(P)),
                                    axisLabSize = 18,
                                    title = "Volcano plot",
                                    subtitle = "",
                                    caption = paste0("total = ", nrow(toptable), " variables"), titleLabSize = 18, subtitleLabSize = 14,
                                    captionLabSize = 14,
                                    pCutoff = 0.05,
                                    FCcutoff = 0.25,
                                    cutoffLineType = "longdash",
                                    cutoffLineCol = "black",
                                    cutoffLineWidth = 0.4,
                                    pointSize = 5,
                                    labSize = 4,
                                    labCol = "black",
                                    labFace = "plain",
                                    labhjust = 0.5,
                                    labvjust = 1.5,
                                    boxedLabels = FALSE,
                                    shape = 19,
                                    shapeCustom = NULL,
                                    col = c("grey30", "forestgreen", "royalblue", "red2"),
                                    colCustom = NULL,
                                    colAlpha = 0.2,
                                    colGradient = NULL,
                                    colGradientBreaks = c(pCutoff, 1),
                                    colGradientLabels = c("0", "1.0"),
                                    colGradientLimits = c(0, 1),
                                    legendLabels = c("NS", expression(Log[2] ~ FC), "p-value", expression(p - value ~ and ~ log[2] ~ FC)),
                                    legendPosition = "top",
                                    legendLabSize = 14,
                                    legendIconSize = 5,
                                    encircle = NULL,
                                    encircleCol = "black",
                                    encircleFill = "pink",
                                    encircleAlpha = 3/4,
                                    encircleSize = 2.5,
                                    shade = NULL,
                                    shadeFill = "grey",
                                    shadeAlpha = 1/2,
                                    shadeSize = 0.01,
                                    shadeBins = 2,
                                    drawConnectors = TRUE,
                                    widthConnectors = 0.5,
                                    typeConnectors = "open",
                                    endsConnectors = "first",
                                    lengthConnectors = unit(0.01, "npc"),
                                    colConnectors = "grey10",
                                    arrowheads = TRUE,
                                    hline = NULL,
                                    hlineType = "longdash",
                                    hlineCol = "black",
                                    hlineWidth = 0.4,
                                    vline = NULL,
                                    vlineType = "longdash",
                                    vlineCol = "black",
                                    vlineWidth = 0.4,
                                    gridlines.major = TRUE,
                                    gridlines.minor = FALSE,
                                    border = "partial",
                                    borderWidth = 0.8,
                                    borderColour = "black")
{
  if (!is.numeric(toptable[[x]])) {
  if (!requireNamespace("ggrepel", quietly = TRUE)) {
    stop("Package 'ggrepel' is required for custom_enhanced_volcano(); install it.", call. = FALSE)
  }
    stop(paste(x, " is not numeric!", sep = ""))
  }
  if (!is.numeric(toptable[[y]])) {
    stop(paste(y, " is not numeric!", sep = ""))
  }
  i <- xvals <- yvals <- Sig <- NULL
  toptable <- as.data.frame(toptable)
  toptable$Sig <- "NS"
  toptable$Sig[(abs(toptable[[x]]) > FCcutoff)] <- "FC"
  toptable$Sig[(toptable[[y]] < pCutoff)] <- "P"
  toptable$Sig[(toptable[[y]] < pCutoff) & (abs(toptable[[x]]) >
                                              FCcutoff)] <- "FC_P"
  toptable$Sig <- factor(toptable$Sig, levels = c("NS", "FC",
                                                  "P", "FC_P"))
  if (min(toptable[[y]], na.rm = TRUE) == 0) {
    warning(paste("One or more p-values is 0.", "Converting to 10^-1 * current",
                  "lowest non-zero p-value..."), call. = FALSE)
    toptable[which(toptable[[y]] == 0), y] <- min(toptable[which(toptable[[y]] !=
                                                                   0), y], na.rm = TRUE) * 10^-1
  }
  toptable$lab <- lab
  toptable$xvals <- toptable[[x]]
  toptable$yvals <- toptable[[y]]
  if (!is.null(selectLab)) {
    names.new <- rep(NA, length(toptable$lab))
    indices <- which(toptable$lab %in% selectLab)
    names.new[indices] <- toptable$lab[indices]
    toptable$lab <- names.new
  }
  th <- theme_bw(base_size = 24) + theme(legend.background = element_rect(),
                                         plot.title = element_text(angle = 0, size = titleLabSize,
                                                                   face = "bold", vjust = 1), plot.subtitle = element_text(angle = 0,
                                                                                                                           size = subtitleLabSize, face = "plain", vjust = 1),
                                         plot.caption = element_text(angle = 0, size = captionLabSize,
                                                                     face = "plain", vjust = 1), axis.text.x = element_text(angle = 0,
                                                                                                                            size = axisLabSize, vjust = 1), axis.text.y = element_text(angle = 0,
                                                                                                                                                                                       size = axisLabSize, vjust = 1), axis.title = element_text(size = axisLabSize),
                                         legend.position = legendPosition, legend.key = element_blank(),
                                         legend.key.size = unit(0.5, "cm"), legend.text = element_text(size = legendLabSize),
                                         title = element_text(size = legendLabSize), legend.title = element_blank())
  if (!is.null(colCustom) & !is.null(shapeCustom)) {
    plot <- ggplot(toptable, aes(x = xvals, y = -log10(yvals))) +
      th + guides(colour = guide_legend(order = 1, override.aes = list(size = legendIconSize)),
                  shape = guide_legend(order = 2, override.aes = list(size = legendIconSize))) +
      geom_point(aes(color = factor(names(colCustom)),
                     shape = factor(names(shapeCustom))), alpha = colAlpha,
                 size = pointSize, na.rm = TRUE) + scale_color_manual(values = colCustom) +
      scale_shape_manual(values = shapeCustom)
  }
  else if (!is.null(colCustom) & is.null(shapeCustom) & length(shape) ==
           1) {
    plot <- ggplot(toptable, aes(x = xvals, y = -log10(yvals))) +
      th + guides(colour = guide_legend(order = 1, override.aes = list(size = legendIconSize)),
                  shape = guide_legend(order = 2, override.aes = list(size = legendIconSize))) +
      geom_point(aes(color = factor(names(colCustom))),
                 alpha = colAlpha, shape = shape, size = pointSize,
                 na.rm = TRUE) + scale_color_manual(values = colCustom) +
      scale_shape_manual(guide = TRUE)
  }
  else if (!is.null(colCustom) & is.null(shapeCustom) & length(shape) ==
           4) {
    plot <- ggplot(toptable, aes(x = xvals, y = -log10(yvals))) +
      th + guides(colour = guide_legend(order = 1, override.aes = list(size = legendIconSize)),
                  shape = guide_legend(order = 2, override.aes = list(size = legendIconSize))) +
      geom_point(aes(color = factor(names(colCustom)),
                     shape = factor(Sig)), alpha = colAlpha, size = pointSize,
                 na.rm = TRUE) + scale_color_manual(values = colCustom) +
      scale_shape_manual(values = c(NS = shape[1], FC = shape[2],
                                    P = shape[3], FC_P = shape[4]), labels = c(NS = legendLabels[1],
                                                                               FC = legendLabels[2], P = legendLabels[3], FC_P = legendLabels[4]),
                         guide = TRUE)
  }
  else if (is.null(colCustom) & !is.null(shapeCustom)) {
    if (is.null(colGradient)) {
      plot <- ggplot(toptable, aes(x = xvals, y = -log10(yvals))) +
        th + guides(colour = guide_legend(order = 1,
                                          override.aes = list(size = legendIconSize)),
                    shape = guide_legend(order = 2, override.aes = list(size = legendIconSize))) +
        geom_point(aes(color = factor(Sig), shape = factor(names(shapeCustom))),
                   alpha = colAlpha, size = pointSize, na.rm = TRUE) +
        scale_color_manual(values = c(NS = col[1], FC = col[2],
                                      P = col[3], FC_P = col[4]), labels = c(NS = legendLabels[1],
                                                                             FC = legendLabels[2], P = legendLabels[3],
                                                                             FC_P = legendLabels[4])) + scale_shape_manual(values = shapeCustom)
    }
    else {
      plot <- ggplot(toptable, aes(x = xvals, y = -log10(yvals))) +
        th + guides(shape = guide_legend(order = 2, override.aes = list(size = legendIconSize))) +
        geom_point(aes(color = factor(Sig), shape = factor(names(shapeCustom))),
                   alpha = colAlpha, size = pointSize, na.rm = TRUE) +
        scale_colour_gradient(low = colGradient[1], high = colGradient[2],
                              limits = colGradientLimits, breaks = colGradientBreaks,
                              labels = colGradientLabels)
      scale_shape_manual(values = shapeCustom)
    }
  }
  else if (is.null(colCustom) & is.null(shapeCustom) & length(shape) ==
           1) {
    if (is.null(colGradient)) {
      plot <- ggplot(toptable, aes(x = xvals, y = -log10(yvals))) +
        th + guides(colour = guide_legend(order = 1,
                                          override.aes = list(shape = shape, size = legendIconSize))) +
        geom_point(aes(color = factor(Sig)), alpha = colAlpha,
                   shape = shape, size = pointSize, na.rm = TRUE) +
        scale_color_manual(values = c(NS = col[1], FC = col[2],
                                      P = col[3], FC_P = col[4]), labels = c(NS = legendLabels[1],
                                                                             FC = legendLabels[2], P = legendLabels[3],
                                                                             FC_P = legendLabels[4]))
    }
    else {
      plot <- ggplot(toptable, aes(x = xvals, y = -log10(yvals))) +
        th + geom_point(aes(color = yvals), alpha = colAlpha,
                        shape = shape, size = pointSize, na.rm = TRUE) +
        scale_colour_gradient(low = colGradient[1], high = colGradient[2],
                              limits = colGradientLimits, breaks = colGradientBreaks,
                              labels = colGradientLabels)
    }
  }
  else if (is.null(colCustom) & is.null(shapeCustom) & length(shape) ==
           4) {
    if (is.null(colGradient)) {
      plot <- ggplot(toptable, aes(x = xvals, y = -log10(yvals))) +
        th + guides(colour = guide_legend(order = 1,
                                          override.aes = list(shape = c(NS = shape[1],
                                                                        FC = shape[2], P = shape[3], FC_P = shape[4]),
                                                              size = legendIconSize))) + geom_point(aes(color = factor(Sig),
                                                                                                        shape = factor(Sig)), alpha = colAlpha, size = pointSize,
                                                                                                    na.rm = TRUE) + scale_color_manual(values = c(NS = col[1],
                                                                                                                                                  FC = col[2], P = col[3], FC_P = col[4]), labels = c(NS = legendLabels[1],
                                                                                                                                                                                                      FC = legendLabels[2], P = legendLabels[3], FC_P = legendLabels[4])) +
        scale_shape_manual(values = c(NS = shape[1],
                                      FC = shape[2], P = shape[3], FC_P = shape[4]),
                           guide = FALSE)
    }
    else {
      plot <- ggplot(toptable, aes(x = xvals, y = -log10(yvals))) +
        th + geom_point(aes(color = yvals, shape = factor(Sig)),
                        alpha = colAlpha, size = pointSize, na.rm = TRUE) +
        scale_colour_gradient(low = colGradient[1], high = colGradient[2],
                              limits = colGradientLimits, breaks = colGradientBreaks,
                              labels = colGradientLabels) + scale_shape_manual(values = c(NS = shape[1],
                                                                                          FC = shape[2], P = shape[3], FC_P = shape[4]),
                                                                               guide = FALSE)
    }
  }
  plot <- plot + xlab(xlab) + ylab(ylab) + xlim(xlim[1], xlim[2]) +
    ylim(ylim[1], ylim[2]) + geom_vline(xintercept = c(-FCcutoff,
                                                       FCcutoff), linetype = cutoffLineType, colour = cutoffLineCol,
                                        size = cutoffLineWidth) + geom_hline(yintercept = -log10(pCutoff),
                                                                             linetype = cutoffLineType, colour = cutoffLineCol, size = cutoffLineWidth)
  plot <- plot + labs(title = title, subtitle = subtitle, caption = caption)
  if (!is.null(vline)) {
    plot <- plot + geom_vline(xintercept = vline, linetype = vlineType,
                              colour = vlineCol, size = vlineWidth)
  }
  if (!is.null(hline)) {
    plot <- plot + geom_hline(yintercept = -log10(hline),
                              linetype = hlineType, colour = hlineCol, size = hlineWidth)
  }
  if (border == "full") {
    plot <- plot + theme(panel.border = element_rect(colour = borderColour,
                                                     fill = NA, size = borderWidth))
  }
  else if (border == "partial") {
    plot <- plot + theme(axis.line = element_line(size = borderWidth,
                                                  colour = borderColour), panel.border = element_blank(),
                         panel.background = element_blank())
  }
  else {
    stop("Unrecognised value passed to 'border'. Must be 'full' or 'partial'")
  }
  if (gridlines.major) {
    plot <- plot + theme(panel.grid.major = element_line())
  }
  else {
    plot <- plot + theme(panel.grid.major = element_blank())
  }
  if (gridlines.minor) {
    plot <- plot + theme(panel.grid.minor = element_line())
  }
  else {
    plot <- plot + theme(panel.grid.minor = element_blank())
  }
  if (!boxedLabels) {
    if (drawConnectors && is.null(selectLab)) {
      if (arrowheads) {
        arr <- arrow(length = lengthConnectors, type = typeConnectors,
                     ends = endsConnectors)
      }
      else {
        arr <- NULL
      }
      plot <- plot + ggrepel::geom_text_repel(data = subset(toptable,
                                                   toptable[[y]] < pCutoff & abs(toptable[[x]]) >
                                                     FCcutoff), aes(label = subset(toptable, toptable[[y]] <
                                                                                     pCutoff & abs(toptable[[x]]) > FCcutoff)[["lab"]]),
                                     size = labSize, segment.color = colConnectors,
                                     segment.size = widthConnectors, arrow = arr,
                                     hjust = labhjust, vjust = labvjust, colour = labCol,
                                     fontface = labFace, na.rm = TRUE)
    }
    else if (drawConnectors && !is.null(selectLab)) {
      if (arrowheads) {
        arr <- arrow(length = lengthConnectors, type = typeConnectors,
                     ends = endsConnectors)
      }
      else {
        arr <- NULL
      }
      plot <- plot + ggrepel::geom_text_repel(data = subset(toptable,
                                                   !is.na(toptable[["lab"]])), aes(label = subset(toptable,
                                                                                                  !is.na(toptable[["lab"]]))[["lab"]]), size = labSize,
                                     segment.color = colConnectors, segment.size = widthConnectors,
                                     arrow = arr, hjust = labhjust, vjust = labvjust,
                                     colour = labCol, fontface = labFace, na.rm = TRUE)
    }
    else if (!drawConnectors && !is.null(selectLab)) {
      plot <- plot + geom_text(data = subset(toptable,
                                             !is.na(toptable[["lab"]])), aes(label = subset(toptable,
                                                                                            !is.na(toptable[["lab"]]))[["lab"]]), size = labSize,
                               check_overlap = TRUE, hjust = labhjust, vjust = labvjust,
                               colour = labCol, fontface = labFace, na.rm = TRUE)
    }
    else if (!drawConnectors && is.null(selectLab)) {
      plot <- plot + geom_text(data = subset(toptable,
                                             toptable[[y]] < pCutoff & abs(toptable[[x]]) >
                                               FCcutoff), aes(label = subset(toptable, toptable[[y]] <
                                                                               pCutoff & abs(toptable[[x]]) > FCcutoff)[["lab"]]),
                               size = labSize, check_overlap = TRUE, hjust = labhjust,
                               vjust = labvjust, colour = labCol, fontface = labFace,
                               na.rm = TRUE)
    }
  }
  else {
    if (drawConnectors && is.null(selectLab)) {
      if (arrowheads) {
        arr <- arrow(length = lengthConnectors, type = typeConnectors,
                     ends = endsConnectors)
      }
      else {
        arr <- NULL
      }
      plot <- plot + ggrepel::geom_label_repel(data = subset(toptable,
                                                    toptable[[y]] < pCutoff & abs(toptable[[x]]) >
                                                      FCcutoff), aes(label = subset(toptable, toptable[[y]] <
                                                                                      pCutoff & abs(toptable[[x]]) > FCcutoff)[["lab"]]),
                                      size = labSize, segment.color = colConnectors,
                                      segment.size = widthConnectors, arrow = arr,
                                      hjust = labhjust, vjust = labvjust, colour = labCol,
                                      fontface = labFace, na.rm = TRUE)
    }
    else if (drawConnectors && !is.null(selectLab)) {
      if (arrowheads) {
        arr <- arrow(length = lengthConnectors, type = typeConnectors,
                     ends = endsConnectors)
      }
      else {
        arr <- NULL
      }
      plot <- plot + ggrepel::geom_label_repel(data = subset(toptable,
                                                    !is.na(toptable[["lab"]])), aes(label = subset(toptable,
                                                                                                   !is.na(toptable[["lab"]]))[["lab"]]), size = labSize,
                                      segment.color = colConnectors, segment.size = widthConnectors,
                                      arrow = arr, hjust = labhjust, vjust = labvjust,
                                      colour = labCol, fontface = labFace, na.rm = TRUE)
    }
    else if (!drawConnectors && !is.null(selectLab)) {
      plot <- plot + geom_label(data = subset(toptable,
                                              !is.na(toptable[["lab"]])), aes(label = subset(toptable,
                                                                                             !is.na(toptable[["lab"]]))[["lab"]]), size = labSize,
                                hjust = labhjust, vjust = labvjust, colour = labCol,
                                fontface = labFace, na.rm = TRUE)
    }
    else if (!drawConnectors && is.null(selectLab)) {
      plot <- plot + geom_label(data = subset(toptable,
                                              toptable[[y]] < pCutoff & abs(toptable[[x]]) >
                                                FCcutoff), aes(label = subset(toptable, toptable[[y]] <
                                                                                pCutoff & abs(toptable[[x]]) > FCcutoff)[["lab"]]),
                                size = labSize, hjust = labhjust, vjust = labvjust,
                                colour = labCol, fontface = labFace, na.rm = TRUE)
    }
  }
  if (!is.null(encircle)) {
    plot <- plot + ggalt::geom_encircle(data = subset(toptable,
                                               rownames(toptable) %in% encircle), colour = encircleCol,
                                 fill = encircleFill, alpha = encircleAlpha, size = encircleSize,
                                 show.legend = FALSE, na.rm = TRUE)
  }
  if (!is.null(shade)) {
    plot <- plot + stat_density2d(data = subset(toptable,
                                                rownames(toptable) %in% shade), fill = shadeFill,
                                  alpha = shadeAlpha, geom = "polygon", contour = TRUE,
                                  size = shadeSize, bins = shadeBins, show.legend = FALSE,
                                  na.rm = TRUE)
  }
  return(plot)
}
