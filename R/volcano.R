#' Prepare a table for volcano plotting
#'
#' Keeps just the `FDR` and `logFC` columns (optionally only significant rows),
#' preserving row names so genes can be labelled later.
#'
#' @param input.data Data frame with `FDR` and `logFC` columns.
#' @param sig.only If `TRUE`, keep only rows with `FDR < 0.05`.
#' @return A data frame with `FDR` and `logFC`.
#' @examples
#' df <- data.frame(FDR = c(0.01, 0.2), logFC = c(2, -0.3),
#'                  row.names = c("A", "B"))
#' clean_volcano_data(df, sig.only = TRUE)
#' @export
clean_volcano_data <- function(input.data, sig.only = TRUE) {
  if (!all(c("FDR", "logFC") %in% names(input.data))) {
    stop("`input.data` must contain 'FDR' and 'logFC' columns.", call. = FALSE)
  }
  out <- as.data.frame(input.data)[, c("FDR", "logFC"), drop = FALSE]
  if (sig.only) out <- out[!is.na(out$FDR) & out$FDR < 0.05, , drop = FALSE]
  out
}

#' Per-point colours for a volcano plot
#'
#' Builds a named colour vector marking up/down-regulated (and optionally
#' selected) genes, in the format expected by the `point_colours` argument of
#' [volcano_plot()]. The names give each point's group and the values its colour.
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
  groups <- rep("NS", nrow(volcano.data))
  up <- volcano.data$logFC > logFC.cutoff & volcano.data$FDR < FDR.cutoff
  dn <- volcano.data$logFC < -logFC.cutoff & volcano.data$FDR < FDR.cutoff
  keyvals[up] <- increase.col
  groups[up] <- "Increased"
  keyvals[dn] <- decreased.col
  groups[dn] <- "Decreased"
  if (highlight.selected) {
    sel <- rownames(volcano.data) %in% highlight.genes
    keyvals[up & sel] <- selected.cols[1]
    groups[up & sel] <- "selected_up"
    keyvals[dn & sel] <- selected.cols[2]
    groups[dn & sel] <- "selected_down"
  }
  stats::setNames(keyvals, groups)
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

#' Volcano plot of differential-expression results
#'
#' Plots log fold change against -log10 adjusted p-value, colouring points by
#' whether they pass the fold-change cutoff, the significance cutoff, both or
#' neither, and labelling genes with `ggrepel` (when installed).
#'
#' @param data Data frame with a log fold change and an adjusted p-value column.
#' @param x,y Names of the fold-change and adjusted p-value columns.
#' @param labels Labels for the points; defaults to the row names of `data`.
#' @param label_genes Optional character vector of genes to label. If `NULL`, all
#'   points passing both cutoffs are labelled.
#' @param fc_cutoff,p_cutoff Absolute log fold change and adjusted p-value cutoffs.
#' @param colours Four colours for the groups NS, FC, P and FC + P, in that order.
#' @param point_colours Optional per-point colours, one per row of `data`, whose
#'   names give each point's legend group (see [colour_volcano_points()]).
#'   Overrides `colours`.
#' @param alpha,point_size Point transparency and size (a single value, or one per
#'   row; see [alpha_volcano_points()] and [size_volcano_points()]).
#' @param label_size Label text size.
#' @param xlim,ylim Optional axis limits. Defaults extend the data range.
#' @param title,subtitle,caption Plot annotations. The caption defaults to the
#'   number of points.
#' @param legend_position Legend position passed to [ggplot2::theme()].
#' @return A [ggplot2::ggplot()] object.
#' @details Adjusted p-values of exactly 0 are replaced by a tenth of the smallest
#'   non-zero value, with a warning, so they can be drawn on a log scale.
#' @examples
#' set.seed(1)
#' res <- data.frame(logFC = rnorm(300), FDR = runif(300) ^ 3,
#'                   row.names = paste0("gene", 1:300))
#' volcano_plot(res, fc_cutoff = 1, title = "A versus B")
#' @importFrom rlang .data
#' @export
volcano_plot <- function(data, x = "logFC", y = "FDR", labels = rownames(data),
                         label_genes = NULL, fc_cutoff = 0.25, p_cutoff = 0.05,
                         colours = c("grey30", "forestgreen", "royalblue", "red2"),
                         point_colours = NULL, alpha = 0.2, point_size = 3, label_size = 3.5,
                         xlim = NULL, ylim = NULL, title = "Volcano plot", subtitle = NULL,
                         caption = paste0("total = ", nrow(data), " variables"),
                         legend_position = "top") {
  data <- as.data.frame(data)
  if (!all(c(x, y) %in% names(data))) stop("`data` must contain columns '", x, "' and '", y, "'.", call. = FALSE)
  if (!is.numeric(data[[x]]) || !is.numeric(data[[y]])) stop("`", x, "` and `", y, "` must be numeric.", call. = FALSE)
  if (length(colours) != 4) stop("`colours` must have four values (NS, FC, P, FC + P).", call. = FALSE)
  if (!is.null(point_colours) && length(point_colours) != nrow(data)) {
    stop("`point_colours` must have one value per row of `data`.", call. = FALSE)
  }

  fc <- data[[x]]
  p <- data[[y]]
  if (any(p == 0, na.rm = TRUE)) {
    warning("One or more adjusted p-values is 0; replacing with a tenth of the smallest non-zero value.",
            call. = FALSE)
    p[which(p == 0)] <- min(p[which(p != 0)], na.rm = TRUE) / 10
  }
  is_fc <- abs(fc) > fc_cutoff
  is_p <- p < p_cutoff
  status <- ifelse(is_fc & is_p, "FC + P", ifelse(is_p, "P", ifelse(is_fc, "FC", "NS")))
  status <- factor(status, levels = c("NS", "FC", "P", "FC + P"))

  plot_data <- data.frame(
    x_val = fc, y_val = -log10(p), label = labels,
    group = if (is.null(point_colours)) status else factor(names(point_colours), levels = unique(names(point_colours))),
    stringsAsFactors = FALSE
  )
  if (is.null(point_colours)) {
    palette <- stats::setNames(colours, levels(status))
  } else {
    palette <- point_colours[!duplicated(names(point_colours))]
  }
  show_label <- if (is.null(label_genes)) is_fc & is_p else plot_data$label %in% label_genes
  show_label[is.na(show_label)] <- FALSE

  x_range <- range(fc, na.rm = TRUE)
  xlim <- xlim %||% c(x_range[1] - 1, x_range[2] + 1)
  ylim <- ylim %||% c(0, max(plot_data$y_val, na.rm = TRUE) + 1)

  plt <- ggplot2::ggplot(plot_data, ggplot2::aes(x = .data$x_val, y = .data$y_val, colour = .data$group)) +
    ggplot2::geom_point(alpha = alpha, size = point_size, na.rm = TRUE) +
    ggplot2::scale_colour_manual(values = palette) +
    ggplot2::geom_vline(xintercept = c(-fc_cutoff, fc_cutoff), linetype = "longdash", linewidth = 0.4) +
    ggplot2::geom_hline(yintercept = -log10(p_cutoff), linetype = "longdash", linewidth = 0.4) +
    ggplot2::coord_cartesian(xlim = xlim, ylim = ylim) +
    ggplot2::labs(x = bquote(~Log[2] ~ "fold change"), y = bquote(~-Log[10] ~ adjusted ~ italic(P)),
                  title = title, subtitle = subtitle, caption = caption) +
    ggplot2::theme_bw(base_size = 14) +
    ggplot2::theme(legend.position = legend_position, legend.title = ggplot2::element_blank(),
                   panel.grid.minor = ggplot2::element_blank(),
                   plot.title = ggplot2::element_text(face = "bold"))

  if (any(show_label)) {
    labelled <- plot_data[show_label, , drop = FALSE]
    if (requireNamespace("ggrepel", quietly = TRUE)) {
      plt <- plt + ggrepel::geom_text_repel(
        data = labelled, ggplot2::aes(label = .data$label), colour = "black", size = label_size,
        segment.colour = "grey30", max.overlaps = Inf, na.rm = TRUE
      )
    } else {
      plt <- plt + ggplot2::geom_text(
        data = labelled, ggplot2::aes(label = .data$label), colour = "black", size = label_size,
        check_overlap = TRUE, vjust = 1.5, na.rm = TRUE
      )
    }
  }
  plt
}

#' Enhanced volcano plot (deprecated wrapper)
#'
#' `custom_enhanced_volcano()` is retained for existing scripts. It forwards the
#' commonly used arguments to [volcano_plot()], and ignores the rest with a
#' warning. New code should call [volcano_plot()] directly.
#'
#' @param toptable Data frame with `x` and `y` columns.
#' @param lab Point labels (defaults to the row names).
#' @param x,y Names of the fold-change and adjusted p-value columns.
#' @param selectLab Genes to label (all points passing both cutoffs if `NULL`).
#' @param xlim,ylim Axis limits.
#' @param title,subtitle,caption Plot annotations.
#' @param pCutoff,FCcutoff Adjusted p-value and absolute log fold change cutoffs.
#' @param pointSize,labSize Point and label sizes.
#' @param col Four group colours (NS, FC, P, FC + P).
#' @param colCustom Per-point colours (see [colour_volcano_points()]).
#' @param colAlpha Point transparency.
#' @param legendPosition Legend position.
#' @param ... Other `EnhancedVolcano`-style arguments, which are ignored.
#' @return A ggplot object.
#' @seealso [volcano_plot()]
#' @export
custom_enhanced_volcano <- function(toptable, lab = rownames(toptable), x = "logFC", y = "FDR",
                                    selectLab = NULL, xlim = NULL, ylim = NULL,
                                    title = "Volcano plot", subtitle = NULL, caption = NULL,
                                    pCutoff = 0.05, FCcutoff = 0.25, pointSize = 3, labSize = 3.5,
                                    col = c("grey30", "forestgreen", "royalblue", "red2"),
                                    colCustom = NULL, colAlpha = 0.2, legendPosition = "top", ...) {
  rlang::warn("`custom_enhanced_volcano()` is deprecated; use `volcano_plot()`.",
              .frequency = "once", .frequency_id = "usefulfunctions-cev")
  ignored <- names(list(...))
  if (length(ignored)) {
    warning("Ignoring unsupported arguments: ", paste(ignored, collapse = ", "), call. = FALSE)
  }
  volcano_plot(toptable, x = x, y = y, labels = lab, label_genes = selectLab,
               fc_cutoff = FCcutoff, p_cutoff = pCutoff, colours = col, point_colours = colCustom,
               alpha = colAlpha, point_size = pointSize, label_size = labSize, xlim = xlim, ylim = ylim,
               title = title, subtitle = subtitle,
               caption = caption %||% paste0("total = ", nrow(toptable), " variables"),
               legend_position = legendPosition)
}
