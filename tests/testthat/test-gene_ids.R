# A miniature JAX HOM_MouseHumanSequence report: three orthologous classes plus a
# one-to-many class (class 3 has two human genes).
jax_fixture <- data.frame(
  DB.Class.Key = c(1, 1, 2, 2, 3, 3, 3),
  Common.Organism.Name = c("mouse, laboratory", "human", "mouse, laboratory", "human",
                           "mouse, laboratory", "human", "human"),
  Symbol = c("Gzma", "GZMA", "Nkg7", "NKG7", "Xcl1", "XCL1", "XCL2"),
  stringsAsFactors = FALSE
)

test_that("mouse to human conversion uses the report", {
  expect_equal(convert_mouse_to_human(c("Gzma", "Nkg7"), use.jax = TRUE, jax.table = jax_fixture),
               c("GZMA", "NKG7"))
})

test_that("human to mouse conversion returns mouse symbols (not human)", {
  expect_equal(convert_human_to_mouse(c("GZMA", "NKG7"), use.jax = TRUE, jax.table = jax_fixture),
               c("Gzma", "Nkg7"))
})

test_that("one-to-many orthologs are all returned and unknown genes are dropped", {
  expect_setequal(convert_mouse_to_human(c("Xcl1", "NotAGene"), use.jax = TRUE, jax.table = jax_fixture),
                  c("XCL1", "XCL2"))
  expect_equal(convert_human_to_mouse("XCL2", use.jax = TRUE, jax.table = jax_fixture), "Xcl1")
  expect_length(convert_mouse_to_human("NotAGene", use.jax = TRUE, jax.table = jax_fixture), 0)
})

test_that("a malformed report is rejected", {
  expect_error(convert_mouse_to_human("Gzma", use.jax = TRUE, jax.table = data.frame(a = 1)),
               "must contain columns")
})
