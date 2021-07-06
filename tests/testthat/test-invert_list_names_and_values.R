test_that("invert_list_names_and_values() works", {
  expect_equal(
    invert_list_names_and_values(list(A = "a", B = "b")),
    list(a = "A", b = "B")
  )
  expect_equal(
    invert_list_names_and_values(list()),
    list()
  )
})
