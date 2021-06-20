test_that("pretty_print_updates works", {
  expect_error(
    pretty_print_updates(list(a = FALSE), list(a = TRUE, b = "yes")),
    NA
  )
})
