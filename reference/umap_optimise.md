# Optimise UMAP hyper-parameters for a Seurat object

Sweeps `min.dist` and `n.neighbors`, saving a UMAP plot PDF for each
combination so the best-looking embedding can be chosen.

## Usage

``` r
umap_optimise(
  input.seurat,
  output.dir = "results/optimising_UMAP/",
  init.min.dist = 0.001,
  init.neigh = 5,
  min.dist.step = 2,
  neigh.step = 20,
  dims = 1:20,
  max.neigh = 50,
  seed = 42
)
```

## Arguments

- input.seurat:

  A Seurat object with a `pca` reduction.

- output.dir:

  Directory to write the PDFs into (created if needed).

- init.min.dist:

  Starting `min.dist` (sensible range 0.001-0.5).

- init.neigh:

  Starting `n.neighbors` (sensible range 5-50).

- min.dist.step:

  Multiplicative step for `min.dist`.

- neigh.step:

  Additive step for `n.neighbors`.

- dims:

  Principal components used for the embedding.

- max.neigh:

  Largest `n.neighbors` to try.

- seed:

  Random seed for reproducible embeddings.

## Value

Invisibly, the paths of the PDFs written.

## Examples

``` r
if (FALSE) { # \dontrun{
umap_optimise(pbmc_small)
} # }
```
