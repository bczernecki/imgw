#' Hydrological data
#'
#' Pobranie danych hydrologicznych dla okresów "dobowe" , "miesieczny" , "polroczne_i_roczne"
#' udostepnionych w zbiorze danepubliczne.imgw.pl
#'
#' @param interval - temporal resolution of the data ("daily" , "monthly", or "semiannual_and_annual")
#' @param year vector of years (e.g., 1966:2000)
#' @param coords add coordinates of the station (logical value TRUE or FALSE)
#' @param value type of data (can be: "State=H (default)", "Flow=Q", "Temperature=T")
#' @return
#' @export
#'
#' @examples \dontrun{
#'   x <- hydro("monthly", year = 1999)
#'   head(x)
#' }
hydro = function(interval, year, coords = FALSE, value = NULL){

  if (interval == "daily"){
    # dobowe
    calosc <- hydro_daily(year = year, coords = coords)
  } else if (interval == "monthly"){
    #miesieczne
    calosc <- hydro_monthly(year = year, coords = coords)
  } else if (interval == "semiannual_and_annual"){
    # polroczne_i_roczne
    calosc <- hydro_annual(year = year, coords = coords, value = value)
  } else{
    stop("Wrong `interval` value. It should be either 'daily', 'monthly', or 'semiannual_and_annual'.")
  }
  return(calosc)
}
