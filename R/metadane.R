#' Funkcja metadane
#'
#` Funkcja konwertujaca URL z metadanymi na liste badz ramke danych
#`
#' @param okres -  argumenty przyjmujący wartość: 'dobowe', 'miesieczne' badz 'terminowe'.  Oznacza dla jakiej rozdzielczosci czasowej maja zostac przygotowane metadane dla srodowiska R
#' @importFrom RCurl getURL
#'
#' @export
#' @examples
#' # przykladowe uzycie:
#' meta <- metadane(okres="dobowe")
#' meta <- metadane(okres="terminowe")
#' meta <- metadane(okres="miesieczne")
#' 

metadane <- function(okres){ # okres moze byc: miesieczne, dobowe, terminowe
  b <- NULL
  if(okres=="dobowe")   { # uwaga! dobowe maja po 2 pliki z metadanymi!!!
    b[[1]] <-   clean_metadata("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/dobowe/synop/s_d_format.txt")
    b[[2]] <-   clean_metadata("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/dobowe/synop/s_d_t_format.txt")
  }
  
  if(okres=="miesieczne") {
    b[[1]] <- clean_metadata("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/miesieczne/synop/s_m_d_format.txt")
  }
  
  if(okres=="terminowe"){
    b[[1]] <- clean_metadata("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/terminowe/synop/s_t_format.txt")
  }
  return(b)
}

