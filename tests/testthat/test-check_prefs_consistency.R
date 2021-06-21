test_that("check_prefs_consistency() works", {
  expect_error(
    check_prefs_consistency(
      list(not_a_pref = TRUE, not_a_pref2 = TRUE, not_a_pref3 = TRUE)),
    NA
  )

  expect_error(
    check_prefs_consistency(
      list(rainbow_parentheses = "TRUE")),
    NA
  )

  expect_error(
    check_prefs_consistency(
      list(rainbow_parentheses = TRUE)),
    NA
  )
})
