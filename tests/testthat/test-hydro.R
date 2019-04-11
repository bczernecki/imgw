context("hydro")
y <- 2017

test_that("hydro works!", {
  x <- hydro("daily", year = y)
  x <- hydro("monthly", year = y)
  x <- hydro("semiannual_and_annual", year = y, value = "H")
  x <- hydro("semiannual_and_annual", year = y, value = "Q")
  x <- hydro("semiannual_and_annual", year = y, value = "T")
})
