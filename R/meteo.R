#' Meteorological data
#'
#' Pobranie danych meteorologicznych dla okresów "dobowe" , "miesieczne" , "terminowe"
#' udostepnionych w zbiorze danepubliczne.imgw.pl
#'
#' @param interwal interwał stacji (do wyboru: "dobowe" , "miesieczne" , "terminowe")
#' @param rzad rzad stacji (do wyboru: "synop" , "klimat" , "opad")
#' @param rok wektor dla wybranych lat (np. 1966:2000)
#' @param status czy pozostawic kolumny ze statusami pomiarow lub obserwacji (domyslnie status = FALSE - tj. kolumny ze statusami sa usuwane )
#' @param coords czy dodac koordynaty dla stacji (wartosc logiczna TRUE lub FALSE)
#'
#' @return
#' @export
#'
#' @examples \dontrun{
#'
#' }
meteo = function(interwal, rzad = "synop", rok = 1966:2018, status = FALSE, coords = FALSE){
  if (interwal == "dobowe"){
    # dobowe
    calosc <- meteo_dobowe(rzad = rzad, rok = rok, status = status, coords = coords)
  } else if (interwal == "miesieczne"){
    #miesieczne
    calosc <- meteo_miesieczne(rzad = rzad, rok = rok, status = status, coords = coords)
  } else if (interwal == "terminowe"){
    # polroczne_i_roczne
    calosc <- meteo_roczne(rzad = rzad, rok = rok, status = status, coords = coords)
  } else{
    stop("Wrong `interwal` value. It should be either 'dobowe', 'miesieczne', or 'terminowe'.")
  }
  return(calosc)
}
