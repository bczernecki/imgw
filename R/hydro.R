#' Pobranie danych hydrologicznych dla okresów "dobowe" , "miesieczny" , "polroczne_i_roczne"
#' udostepnionych w zbiorze danepubliczne.imgw.pl
#'
#' @param interwal interwał stacji (do wyboru: "dobowe" , "miesieczny"(domyslnie) , "polroczne_i_roczne")
#' @param rok wektor dla wybranych lat (np. 1966:2000)
#' @param coords czy dodac wspolrzedne (WGS84) i wysokosc stacji? (domyslnie coords = FALSE)
#' @param value rodzaj danych (do wyboru: "Stan=H (domyslnie)" , "Przepływ=Q" , "Temperatura=T")
#' @return
#' @export
#'
#' @examples \dontrun{
#'
#' }
#'
# Stan wody 9999 oznacza brak danych w bazie lub przerwy w obserwacjach w danym miesiącu i stad brak możliwości obliczenia charakterystyk.
#Przepływ 99999.999 oznacza brak danych lub przerwy w obserwacjach w danym miesiacu i stad brak możliwości obliczenia charakterystyk.
#Temperatura wody 99.9 oznacza brak danych lub przerwy w obserwacjach w danym miesiacu i stad brak możliwości obliczenia charakterystyk.
# Działa tylko dla miesiecznych hydro
hydro = function(interwal = "miesieczne", rok = 1966:2000, coords = FALSE, value = NULL){

  if (interwal == "dobowe"){
    # dobowe
    calosc <- hydro_dobowe(rok = rok, coords = coords)
  } else if (interwal == "miesieczne"){
    #miesieczne
    calosc <- hydro_miesieczne(rok = rok, coords = coords)
  } else if (interwal == "polroczne_i_roczne"){
    # polroczne_i_roczne
    calosc <- hydro_roczne(rok = rok, coords = coords, value = value)
  } else{
    stop("Wrong `interwal` value. It should be either 'dobowe', 'miesieczne', or 'polroczne_i_roczne'.")
  }
  return(calosc)
}
