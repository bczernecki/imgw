#' Meteorological metadata
#'
#' Downloading the description (metadata) to the meteorological data available in the danepubliczne repository.imgw.pl
#' By default, the function returns a list or data frame for a selected subset (depending on how to cop#`
#'
#' @param interval -  Argument accepting the value 'terminowe' , dobowe' (default), or 'miesieczne'.  Indicates for which time resolution metadata for environment R should be prepared
#' @param rank rank of station ("synop" , "klimat" , "opad")
#'
#' @export
#' @examples
#' \dontrun{
#' meta <- meteo_metadane(interval = "dobowe", rank = "synop")
#' meta <- meteo_metadane(interval = "terminowe", rank = "synop")
#' meta <- meteo_metadane(interval = "miesieczne", rank = "opad")
#' }

meteo_metadane <- function(interval, rank){ # interval moze byc: miesieczne, dobowe, terminowe
  b <- NULL

  base_url <- "https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/"

  # METADANE DOBOWE:
  if(interval == "dobowe")   { # uwaga! dobowe maja dla klimatow i synopow po 2 pliki z metadanymi!!!

    if(rank == "synop"){
      b[[1]] <- clean_metadata_meteo(adres = paste0(base_url, "dane_meteorologiczne/dobowe/synop/s_d_format.txt"),
                               rank = "synop", interval = "dobowe")
      b[[2]] <- clean_metadata_meteo(adres = paste0(base_url, "dane_meteorologiczne/dobowe/synop/s_d_t_format.txt"),
                                              rank = "synop", interval = "dobowe")
    }

    if(rank == "klimat"){
      b[[1]] <- clean_metadata_meteo(adres = paste0(base_url, "dane_meteorologiczne/dobowe/klimat/k_d_format.txt"),
                               rank = "klimat", interval = "dobowe")
      b[[2]] <- clean_metadata_meteo(adres = paste0(base_url, "dane_meteorologiczne/dobowe/klimat/k_d_t_format.txt"),
                               rank = "klimat", interval = "dobowe")
    }

    if(rank == "opad"){
      b[[1]] <- clean_metadata_meteo(adres = paste0(base_url, "dane_meteorologiczne/dobowe/opad/o_d_format.txt"),
                               rank = "opad", interval = "dobowe")
    }

  } # koniec "DOBOWE"


  # TODO: pod adresem: https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/miesieczne/synop/
  # sa 2 ranke metadanych, bo pliki miesieczne maja 2 ranke danych; w starej wersji paczki tylko jedna wersja jest uwzgledniana
  # dodatkowo inne ranke danych beda do pobrania w zaleznosci od danych SYNOP, KLIMAT, OPAD:
  if(interval == "miesieczne") {

    if(rank == "synop"){
      b[[1]] <- clean_metadata_meteo(paste0(base_url, "dane_meteorologiczne/miesieczne/synop/s_m_d_format.txt"),
                               rank = "synop", interval = "miesieczne")
      b[[2]] <- clean_metadata_meteo(paste0(base_url, "dane_meteorologiczne/miesieczne/synop/s_m_t_format.txt"),
                               rank = "synop", interval = "miesieczne")
    }

    if(rank == "klimat"){
      b[[1]] <- clean_metadata_meteo(paste0(base_url, "dane_meteorologiczne/miesieczne/klimat/k_m_d_format.txt"),
                               rank = "klimat", interval = "miesieczne")
      b[[2]] <- clean_metadata_meteo(paste0(base_url, "dane_meteorologiczne/miesieczne/klimat/k_m_t_format.txt"),
                               rank = "klimat", interval = "miesieczne")
    }

    if(rank == "opad"){
      b[[1]] <- clean_metadata_meteo(paste0(base_url, "dane_meteorologiczne/miesieczne/opad/o_m_format.txt"),
                               rank = "opad", interval = "miesieczne")
    }

  } # koniec MIESIECZNYCH


  ## rozpoczecie dla danych TERMINOWYCH:
  if(interval == "terminowe"){
    if(rank == "synop") b[[1]] <- clean_metadata_meteo(paste0(base_url, "dane_meteorologiczne/terminowe/synop/s_t_format.txt"),
                                                 rank = "synop", interval = "terminowe")
    if(rank == "klimat") b[[1]] <- clean_metadata_meteo(paste0(base_url, "dane_meteorologiczne/terminowe/klimat/k_t_format.txt"),
                                                  rank = "klimat", interval = "terminowe")
  }

  return(b)
}

# metadane(interval = "dobowe", rank = "synop")
# metadane(interval = "dobowe", rank = "klimat")
# metadane(interval = "dobowe", rank = "opad")
