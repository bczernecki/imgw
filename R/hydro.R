#' Hydrological data
#'
#' Pobranie danych hydrologicznych dla okresów "dobowe" , "miesieczny" , "polroczne_i_roczne"
#' udostepnionych w zbiorze danepubliczne.imgw.pl
#'
#' @param interval argument accepting the value 'terminowe' , dobowe' (default), or 'miesieczne'.  Indicates for which time resolution metadata for environment R should be prepared
#' @param year vector of years (e.g. 1966:2000)
#' @param coords add coordinates for the station (logical value TRUE or FALSE)
#' @param value type of data ( can be: "State=H (default)" , "Flow=Q" , "Temperature=T")
#' @return
#' @export
#'
#' @examples \dontrun{
#'
#' }
hydro = function(interval = "miesieczne", year = 1966:2000, coords = FALSE, value = NULL){

  if (interval == "dobowe"){
    # dobowe
    calosc <- hydro_dobowe(year = year, coords = coords)
  } else if (interval == "miesieczne"){
    #miesieczne
    calosc <- hydro_miesieczne(year = year, coords = coords)
  } else if (interval == "polroczne_i_roczne"){
    # polroczne_i_roczne
    calosc <- hydro_annual(year = year, coords = coords, value = value)
  } else{
    stop("Wrong `interval` value. It should be either 'dobowe', 'miesieczne', or 'polroczne_i_roczne'.")
  }
  return(calosc)
}
