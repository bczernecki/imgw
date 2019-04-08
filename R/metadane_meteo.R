#' Pobranie opisu (metadanych) do danych meteorologicznych  udostępnionych w repozytorium danepubliczne.imgw.pl
#' Domyślnie funkcja zwraca listę bądź ramkę danych dla wybranego podzbioru (w zależności od radzaj)
#`
#' @param interwal -  Argument przyjmujący wartość: 'terminowe' , dobowe' (domyślnie), lub 'miesieczne'.  Oznacza dla jakiej rozdzielczosci czasowej maja zostac przygotowane metadane dla srodowiska R
#' @param rzad -  Argument przyjmujący wartość: 'synop' (domyślnie) lub 'klimat'.  Oznacza dla jakiego rzadu/rzędu staji mają zostać przygotowane metadane.
#' @importFrom RCurl getURL
#'
#' @export
#' @examples
#' # przykladowe uzycie:
#' \dontrun{
#' meta <- metadane(interwal = "dobowe", rzad = "synop")
#' meta <- metadane(interwal = "terminowe", rzad = "synop")
#' meta <- metadane(interwal = "miesieczne", rzad = "opad")
#' }

metadane_meteo <- function(interwal, rzad){ # interwal moze byc: miesieczne, dobowe, terminowe
  b <- NULL

  base_url <- "https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/"

  # METADANE DOBOWE:
  if(interwal == "dobowe")   { # uwaga! dobowe maja dla klimatow i synopow po 2 pliki z metadanymi!!!

    if(rzad == "synop"){
      b[[1]] <- clean_metadata_meteo(adres = paste0(base_url, "dane_meteorologiczne/dobowe/synop/s_d_format.txt"),
                               rzad = "synop", interwal = "dobowe")
      b[[2]] <- clean_metadata_meteo(adres = paste0(base_url, "dane_meteorologiczne/dobowe/synop/s_d_t_format.txt"),
                                              rzad = "synop", interwal = "dobowe")
    }

    if(rzad == "klimat"){
      b[[1]] <- clean_metadata_meteo(adres = paste0(base_url, "dane_meteorologiczne/dobowe/klimat/k_d_format.txt"),
                               rzad = "klimat", interwal = "dobowe")
      b[[2]] <- clean_metadata_meteo(adres = paste0(base_url, "dane_meteorologiczne/dobowe/klimat/k_d_t_format.txt"),
                               rzad = "klimat", interwal = "dobowe")
    }

    if(rzad == "opad"){
      b[[1]] <- clean_metadata_meteo(adres = paste0(base_url, "dane_meteorologiczne/dobowe/opad/o_d_format.txt"),
                               rzad = "opad", interwal = "dobowe")
    }

  } # koniec "DOBOWE"


  # TODO: pod adresem: https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/miesieczne/synop/
  # sa 2 rzade metadanych, bo pliki miesieczne maja 2 rzade danych; w starej wersji paczki tylko jedna wersja jest uwzgledniana
  # dodatkowo inne rzade danych beda do pobrania w zaleznosci od danych SYNOP, KLIMAT, OPAD:
  if(interwal == "miesieczne") {

    if(rzad == "synop"){
      b[[1]] <- clean_metadata_meteo(paste0(base_url, "dane_meteorologiczne/miesieczne/synop/s_m_d_format.txt"),
                               rzad = "synop", interwal = "miesieczne")
      b[[2]] <- clean_metadata_meteo(paste0(base_url, "dane_meteorologiczne/miesieczne/synop/s_m_t_format.txt"),
                               rzad = "synop", interwal = "miesieczne")
    }

    if(rzad == "klimat"){
      b[[1]] <- clean_metadata_meteo(paste0(base_url, "dane_meteorologiczne/miesieczne/klimat/k_m_d_format.txt"),
                               rzad = "klimat", interwal = "miesieczne")
      b[[2]] <- clean_metadata_meteo(paste0(base_url, "dane_meteorologiczne/miesieczne/klimat/k_m_t_format.txt"),
                               rzad = "klimat", interwal = "miesieczne")
    }

    if(rzad == "opad"){
      b[[1]] <- clean_metadata_meteo(paste0(base_url, "dane_meteorologiczne/miesieczne/opad/o_m_format.txt"),
                               rzad = "opad", interwal = "miesieczne")
    }

  } # koniec MIESIECZNYCH


  ## rozpoczecie dla danych TERMINOWYCH:
  if(interwal == "terminowe"){
    if(rzad == "synop") b[[1]] <- clean_metadata_meteo(paste0(base_url, "dane_meteorologiczne/terminowe/synop/s_t_format.txt"),
                                                 rzad = "synop", interwal = "terminowe")
    if(rzad == "klimat") b[[1]] <- clean_metadata_meteo(paste0(base_url, "dane_meteorologiczne/terminowe/klimat/k_t_format.txt"),
                                                  rzad = "klimat", interwal = "terminowe")
  }

  return(b)
}

# metadane(interwal = "dobowe", rzad = "synop")
# metadane(interwal = "dobowe", rzad = "klimat")
# metadane(interwal = "dobowe", rzad = "opad")
