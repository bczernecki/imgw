context("meteo-metadata")

test_that("meteo-metadata works!", {
  m <- meteo_metadata("hourly", "synop")
  m <- meteo_metadata("hourly", "climate")
  m <- meteo_metadata("hourly", "precip")
  m <- meteo_metadata("daily", "synop")
  m <- meteo_metadata("daily", "climate")
  m <- meteo_metadata("daily", "precip")
  m <- meteo_metadata("monthly", "synop")
  m <- meteo_metadata("monthly", "climate")
  m <- meteo_metadata("monthly", "precip")
})
