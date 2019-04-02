#' Funkcja metadane
#'
#` Funkcja konwertujaca URL z metadanymi na liste badz ramke danych
#`
#' @param okres -  argumenty przyjmujący wartość: 'dobowe', 'miesieczne' badz 'terminowe'.  Oznacza dla jakiej rozdzielczosci czasowej maja zostac przygotowane metadane dla srodowiska R
#' @param rodzaj -  argumenty przyjmujący wartość: 'synop' (domyślnie) lub 'klimat'.  Oznacza dla jakiego rodzaju/rzędu staji mają zostać przygotowane metadane.
#' @importFrom RCurl getURL
#'
#' @export
#' @examples
#' # przykladowe uzycie:
#' \dontrun{
#' meta <- metadane(okres="dobowe")
#' meta <- metadane(okres="terminowe")
#' meta <- metadane(okres="miesieczne")
#' }

metadane <- function(okres="dobowe", rodzaj = "synop"){ # okres moze byc: miesieczne, dobowe, terminowe
  b <- NULL

  # METADANE DOBOWE:
  if(okres == "dobowe")   { # uwaga! dobowe maja dla klimatow i synopow po 2 pliki z metadanymi!!!

    if(rodzaj=="synop"){
      b[[1]] <-   clean_metadata("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/dobowe/synop/s_d_format.txt")
      b[[2]] <-   clean_metadata("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/dobowe/synop/s_d_t_format.txt")
    }

    if(rodzaj=="klimat"){
      b[[1]] <- clean_metadata("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/dobowe/klimat/k_d_format.txt")
      b[[2]] <- clean_metadata("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/dobowe/klimat/k_d_t_format.txt")
    }

    if(rodzaj=="opad"){
      b[[1]] <- clean_metadata("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/dobowe/opad/o_d_format.txt", rodzaj="opad")
    }

  } # koniec "DOBOWE"


  ###########################
  # TUTAJ SKONCZYLEM: 02/04/2019 17:43


  # TODO: pod adresem: https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/miesieczne/synop/
  # sa 2 rodzaje metadanych, bo pliki miesieczne maja 2 rodzaje danych; w starej wersji paczki tylko jedna wersja jest uwzgledniana
  # dodatkowo inne rodzaje danych beda do pobrania w zaleznosci od danych SYNOP, KLIMAT, OPAD:
  if(okres == "miesieczne") {
    b[[1]] <- clean_metadata_miesieczne("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/miesieczne/synop/s_m_d_format.txt")
  }

  if(okres == "terminowe"){
    if(rodzaj == "synop") b[[1]] <- clean_metadata("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/terminowe/synop/s_t_format.txt")
    if(rodzaj == "klimat") b[[1]] <- clean_metadata("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/terminowe/klimat/k_t_format.txt")
  }

  return(b)
}

# metadane(okres = "dobowe", rodzaj = "synop")
# metadane(okres = "dobowe", rodzaj = "klimat")
# metadane(okres = "dobowe", rodzaj = "opad")

