# Silence R CMD check notes for non-standard-evaluation (dplyr) column names
# used in the internal TCGA preprocessing helpers.
utils::globalVariables(c(".", "data", "gene_id", "gene_name", "gene_type", "gene_sum"))
