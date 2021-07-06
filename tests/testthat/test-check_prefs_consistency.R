test_that("check_prefs_consistency() works", {
  # expect error about duplicate names
  expect_error(
    check_prefs_consistency(
      list(not_a_pref = TRUE, not_a_pref = TRUE, not_a_pref = TRUE))
  )

  # expect note about bad pref names
  expect_error(
    check_prefs_consistency(
      list(not_a_pref = TRUE, not_a_pref2 = TRUE, not_a_pref3 = TRUE)),
    NA
  )

  # expect note about bad value
  expect_error(
    check_prefs_consistency(
      list(rainbow_parentheses = "TRUE")),
    NA
  )

  # expect note about bad value
  expect_error(
    check_prefs_consistency(
      list(ansi_console_mode = TRUE)),
    NA
  )

  # expect note about bad value
  expect_error(
    check_prefs_consistency(
      list(margin_column = "hello")),
    NA
  )

  # expect note about bad value
  expect_error(
    check_prefs_consistency(
      list(margin_column = c(1L, 80L))),
    NA
  )

  # expect note about bad value
  expect_error(
    check_prefs_consistency(
      list(font_size_points = "hello")),
    NA
  )

  # expect NO NOTES
  expect_error(
    check_prefs_consistency(
      list(rainbow_parentheses = TRUE)),
    NA
  )


})
