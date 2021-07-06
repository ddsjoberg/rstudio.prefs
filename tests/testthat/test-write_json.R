test_that("write_json()", {
  expect_error(
    write_json(
      list(a = 1, b = 2),
      path = file.path(tempdir(), "test_folder", "test_json.json"),
      .backup = TRUE
    ),
    NA,
  )
  expect_error(
    write_json(
      list(a = 1, b = 2),
      path = file.path(tempdir(), "test_folder", "test_json.json"),
      .backup = TRUE
    ),
    NA,
  )
  expect_error(
    write_json(
      list(a = 1, b = 2),
      path = file.path(tempdir(), "test_folder", "test_json.json"),
      .backup = TRUE
    ),
    NA,
  )
})
