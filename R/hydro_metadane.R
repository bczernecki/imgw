#' Pobranie opisu (metadanych) do danych hydrologicznych  udostępnionych w repozytorium danepubliczne.imgw.pl
#' Domyślnie funkcja zwraca listę bądź ramkę danych dla wybranego podzbioru (w zależności od radzaj)
#`
#' @param interwal -  Argument przyjmujący wartość: 'dobowe' , miesieczne' lub 'polroczne_i_roczne'.  Oznacza dla jakiej rozdzielczosci czasowej maja zostac przygotowane metadane dla srodowiska R
#' @importFrom RCurl getURL
#'
#' @export
#' @examples
#' # przykladowe uzycie:
#' \dontrun{
#'   meta <- metadane(interwal = "dobowe")
#'   meta <- metadane(interwal = "miesieczne")
#'   meta <- metadane(interwal = "polroczne_i_roczne")
#' }

hydro_metadane <- function(interwal){

  base_url <- "https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_hydrologiczne/"

  if (interwal == "dobowe"){
    # dobowe
    adres_meta1 <- paste0(base_url, interwal, "/codz_info.txt")
    adres_meta2 <- paste0(base_url, interwal, "/zjaw_info.txt")
    meta <- list(hydro_clean_metadata(adres_meta1, interwal),
                 hydro_clean_metadata(adres_meta2, interwal))
  } else if (interwal == "miesieczne"){
    #miesieczne
    adres_meta <- paste0(base_url, interwal, "/mies_info.txt")
    meta <- hydro_clean_metadata(adres_meta, interwal)
  } else if (interwal == "polroczne_i_roczne"){
    # polroczne_i_roczne
    adres_meta <- paste0(base_url, interwal, "/polr_info.txt")
    meta <- hydro_clean_metadata(adres_meta, interwal)
  } else{
    stop("Wrong `interwal` value. It should be either 'dobowe', 'miesieczne', or 'polroczne_i_roczne'.")
  }

  return(meta)
}
