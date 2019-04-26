#' Meteorological data
#'
#' Downloading hourly, daily, and monthly meteorological data from the SYNOP / CLIMATE / PRECIP stations available in the danepubliczne.imgw.pl collection
#'
#' @param interval temporal resolution of the data ("hourly", "daily", "monthly")
#' @param rank rank of the stations ("synop", "climate", "precip")
#' @param year vector of years (e.g., 1966:2000)
#' @param status leave the columns with measurement and observation statuses (default status = FALSE - i.e. the status columns are deleted)
#' @param coords add coordinates of the station (logical value TRUE or FALSE)
#' @param short shortening column names (logical value TRUE or FALSE)
#' @param ... other parameters that may be passed to 'shortening' function that shortens column names

#' @export
#'
#' @examples \dontrun{
#'   x <- meteo("monthly", rank = "synop", year = 2018, coords = TRUE)
#'   head(x)
#' }
meteo <- function(interval, rank, year, status = FALSE, coords = FALSE, short = TRUE, ...){
  if (interval == "daily"){
    # daily
    calosc <- meteo_daily(rank = rank, year = year, status = status, coords = coords, short = short, ...)
  } else if (interval == "monthly"){
    #monthly
    calosc <- meteo_monthly(rank = rank, year = year, status = status, coords = coords, short = short, ...)
  } else if (interval == "hourly"){
    #hourly
    calosc <- meteo_hourly(rank = rank, year = year, status = status, coords = coords, short = short, ...)
  } else{
    stop("Wrong `interval` value. It should be either 'hourly', daily', or 'monthly'.")
  }


  return(calosc)
}
