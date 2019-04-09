#' Funkcja czyszczaca metadane
#'
#' Tylko do wewnetrznego uzytku...
#' Na potrzeby funkcji 'meteo_metadane()'
#' @param address address URL to file with metadata
#' @param rank rank
#' @param interval interval czasowy
#' @importFrom RCurl getURL
#' @importFrom utils read.fwf
#' @importFrom stats na.omit
#'
#' @examples
#' \dontrun{
#'   clean_metadata_meteo(address = "https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/dobowe/synop/s_d_format.txt", rank = "synop", interval = "terminowe")
#' }
#'

clean_metadata_meteo <- function(address, rank = "synop", interval = "terminowe"){
  a <- suppressWarnings(na.omit(read.fwf(address, widths = c(1000), fileEncoding = "CP1250", stringsAsFactors = FALSE)))

  length_char <- max(nchar(a$V1), na.rm = TRUE)

  if(rank == "opad" & interval == "terminowe") length_char <- 40 # wyjatek dla opadow
  if(rank == "synop" & interval == "terminowe") length_char <- 60 # wyjatek dla synopow terminowych

  field <- substr(a$V1, length_char - 3, length_char)

  if(rank == "synop" & interval == "miesieczne") {
    length_char <- as.numeric(names(sort(table(nchar(a$V1)), decreasing = TRUE)[1])) + 2
    field <- substr(a$V1, length_char - 3, length_char + 2)
  }

  a$field1 <- suppressWarnings(as.numeric(unlist(lapply(strsplit(field, "/"), function(x) x[1]))))
  a$field2 <- suppressWarnings(as.numeric(unlist(lapply(strsplit(field, "/"), function(x) x[2]))))

  a$V1 <- trimws(substr(a$V1, 1, nchar(a$V1) - 3))
  #a <- a[nchar(a$V1)>2,] # usuwamy puste lub prawie puste wiersze dodatkowo...
  a <- a[!(is.na(a$field1) & is.na(a$field2)), ] # usuwanie info o statusach
  colnames(a)[1] <- "parameters"
  a
}
