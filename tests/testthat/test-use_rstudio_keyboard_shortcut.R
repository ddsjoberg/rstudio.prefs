test_that("check_shortcut_consistency()", {
  expect_error(
    as.list(letters) %>% check_shortcut_consistency()
  )

  expect_error(
    list(test = 5) %>% check_shortcut_consistency()
  )

  expect_error(
    # `make_path_norm()` is a function
    list(test = "make_path_norm") %>% check_shortcut_consistency(),
    NA
  )
  expect_error(
    list(test = "not_a_fun") %>% check_shortcut_consistency()
  )
})
