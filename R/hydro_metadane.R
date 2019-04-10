#' Hydrological metadata
#'
#' Downloading the description (metadata) to hydrological data available in the danepubliczne.imgw.pl repository
#' By default, the function returns a list or data frame for a selected subset (depending on how to cope)
#`
#' @param interval - Argument accepts the values: 'dobowe' , miesieczne' or 'polroczne_i_roczne'.  Indicates for which time resolution metadata for environment R should be prepared
#' @importFrom RCurl getURL
#'
#' @export
#' @examples
#' \dontrun{
#'   meta <- metadane(interval = "dobowe")
#'   meta <- metadane(interval = "miesieczne")
#'   meta <- metadane(interval = "polroczne_i_roczne")
#' }

hydro_metadane <- function(interval){

  base_url <- "https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_hydrologiczne/"

  if (interval == "dobowe"){
    # dobowe
    address_meta1 <- paste0(base_url, interval, "/codz_info.txt")
    address_meta2 <- paste0(base_url, interval, "/zjaw_info.txt")
    meta <- list(clean_metadata_hydro(address_meta1, interval),
                 clean_metadata_hydro(address_meta2, interval))
  } else if (interval == "miesieczne"){
    #miesieczne
    address_meta <- paste0(base_url, interval, "/mies_info.txt")
    meta <- clean_metadata_hydro(address_meta, interval)
  } else if (interval == "polroczne_i_roczne"){
    # polroczne_i_roczne
    address_meta <- paste0(base_url, interval, "/polr_info.txt")
    meta <- clean_metadata_hydro(address_meta, interval)
  } else{
    stop("Wrong `interval` value. It should be either 'dobowe', 'miesieczne', or 'polroczne_i_roczne'.")
  }

  return(meta)
}
