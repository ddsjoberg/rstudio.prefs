test_that("repo_string_as_named_list() works", {
  expect_equal(
    repo_string_as_named_list('ropensci|https://ropensci.r-universe.dev|ddsjoberg|https://ddsjoberg.r-universe.dev'),
    list(ropensci = "https://ropensci.r-universe.dev",
         ddsjoberg = "https://ddsjoberg.r-universe.dev")
  )

  expect_equal(
    repo_string_as_named_list(NULL),
    list()
  )
})
