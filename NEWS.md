# usefulfunctions 0.2.0 (in development)

Ground-up rebuild for a lighter, better-documented, tested package.

* **Light install:** heavy Bioconductor dependencies (Seurat, TCGAbiolinks, biomaRt,
  clusterProfiler, org.*.eg.db, …) moved to `Suggests`; the package now installs quickly.
  Removed the CRAN-archived `cgdsr` dependency.
* **Modern API:** functions renamed to snake_case (e.g. `make_transparent`, `moving_average`,
  `get_batlow`). Old dot.case names (`makeTransparent`, `calc.moving.average`, `Get.batlow`)
  are kept as deprecated aliases, so existing scripts keep working.
* **Bug fix:** `get_batlow()` now returns the palette instead of assigning into the global
  environment.
* Added unit tests and continuous integration (`R CMD check` on every push).
