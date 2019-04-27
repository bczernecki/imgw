#' Hydrological data
#'
#' Downloading hourly, daily, and monthly hydrological data from the SYNOP / CLIMATE / PRECIP stations available in the danepubliczne.imgw.pl collection
#'
#' @param interval temporal resolution of the data ("daily" , "monthly", or "semiannual_and_annual")
#' @param year vector of years (e.g., 1966:2000)
#' @param value type of data (can be: state - "H" (default), flow - "Q", or temperature - "T")
#' @param station vector of hydrological stations danepubliczne.imgw.pl can be name of station CAPITAL LETTERS(character)
#' or ID of station(numeric)
#' @export
#'
#' @examples \dontrun{
#'   x <- hydro("monthly", year = 1999)
#'   head(x)
#' }
hydro <- function(interval, year, value = NULL, station = NULL){

  if (interval == "daily"){
    # dobowe
    calosc <- hydro_daily(year = year, station = station)
  } else if (interval == "monthly"){
    #miesieczne
    calosc <- hydro_monthly(year = year, station = station)
  } else if (interval == "semiannual_and_annual"){
    # polroczne_i_roczne
    calosc <- hydro_annual(year = year, value = value, station = station)
  } else{
    stop("Wrong `interval` value. It should be either 'daily', 'monthly', or 'semiannual_and_annual'.", call. = FALSE)
  }
  return(calosc)
}
