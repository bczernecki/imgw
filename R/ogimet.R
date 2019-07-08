#' Scrapping meteorological (Synop) data from the Ogimet webpage
#'
#' Downloading hourly and daily (meteorological) data from the Synop stations available in the https://www.ogimet.com/ repository
#'
#' @param date start and finish of date (e.g., date=c("2018-05-01","2018-07-01") )
#' @param coords add geographical coordinates of the station (logical value TRUE or FALSE)
#' @param station WMO ID of meteorological station(s). Character or numeric vector
#' @param precip_split whether to split precipitation fields into 6/12/24h numeric fields (logical value TRUE (default) or FALSE)
#' @importFrom RCurl getURL
#' @importFrom XML readHTMLTable
#' @export
#'
#' @examples \donttest{
#'   # downloading data for Poznan-Lawica
#'   poznan <- ogimet(interval == "daily", station = 12330, coords = TRUE, precip_split = TRUE)
#'   head(poznan)
#' }
#'
meteo <- function(interval, date ,  coords = FALSE, station ,  precip_split = TRUE, ...){
  if (interval == "daily"){
    # daily
    all_data <- ogimet_daily(date=date ,  coords = coords, station = station ,  precip_split = precip_split, ...)
  } else if (interval == "hourly"){
    #hourly
    all_data <- meteo_hourly(date=date ,  coords = coords, station = station ,  precip_split = precip_split, ...)
  } else{
    stop("Wrong `interval` value. It should be either 'hourly' or 'daily'")
  }

  return(all_data)
}
