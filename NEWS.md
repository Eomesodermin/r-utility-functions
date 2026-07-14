# usefulfunctions 0.2.0

Ground-up rebuild — lighter, tested, fully documented.

* **Light install:** heavy Bioconductor dependencies (Seurat, TCGAbiolinks, biomaRt,
  clusterProfiler, org.*.eg.db, gplots, factoextra, ape, ggrepel, ggalt) moved to
  `Suggests` and checked at call time. Removed the CRAN-archived `cgdsr` dependency.
* **Modern API:** all functions renamed to snake_case; the old dot.case names are kept
  as deprecated aliases, so nothing breaks.
* **Bug fix:** `get_batlow()` returns the palette instead of assigning to the global env.
* **Curated merge** of the useful functions from `r-bioinformatics-utils`; project-specific
  / buggy functions there were intentionally excluded.
* Added unit tests (testthat) and continuous integration (`R CMD check` on every push).
* **Function improvements & functionality:**
  * `make_transparent()` is now vectorised over multiple colours.
  * `get_batlow()` gains a `rev` argument and validates `n`.
  * `standardize()` is robust to constant (zero-MAD) rows and gains `na.rm`.
  * `sc_correlation()` gains a `method` argument (pearson/spearman/kendall) and validates `goi`.
  * `moving_average()` and `clean_volcano_data()` validate their inputs with clear errors.
  * Expanded the testthat suite to cover the new behaviour and edge cases.

