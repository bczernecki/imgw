context("meteo-metadata")

test_that("meteo-metadata works!", {
  meteo_metadata("hourly", "synop")
  meteo_metadata("hourly", "climate")
  meteo_metadata("hourly", "precip")
  meteo_metadata("daily", "synop")
  meteo_metadata("daily", "climate")
  meteo_metadata("daily", "precip")
  meteo_metadata("monthly", "synop")
  meteo_metadata("monthly", "climate")
  meteo_metadata("monthly", "precip")
})
