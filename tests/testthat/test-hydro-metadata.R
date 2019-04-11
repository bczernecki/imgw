context("hydro-metadata")

test_that("hydro-metadata works!", {
  m <- hydro_metadata("daily")
  m <- hydro_metadata("monthly")
  m <- hydro_metadata("semiannual_and_annual")
})
