#' Funkcja czyszczaca metadane
#'
#' Tylko do wewnetrznego uzytku...
#' Na potrzeby funkcji 'metadane()'
#' @param adres adres URL do pliku z metadanymi
#' @param rzad rzad
#' @param interwal interwal czasowy
#' @importFrom RCurl getURL
#' @importFrom utils read.fwf
#' @importFrom stats na.omit
#'
#' @export
#' @examples
#' # przykladowe pobranie:
#' \dontrun{
#'   clean_metadata(adres = "https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/dobowe/synop/s_d_format.txt")
#' }
#'

clean_metadata <- function(adres, rzad = "synop", interwal = "terminowe"){
  a <- na.omit(read.fwf2(adres, widths = c(1000), fileEncoding = "CP1250", stringsAsFactors = FALSE))
  doilu <- max(nchar(a$V1), na.rm = TRUE)

  if(rzad == "opad") doilu <- 40 # wyjatek dla opadow

  pola <- substr(a$V1, doilu - 3, doilu)

  if(rzad == "synop" & interwal == "miesieczne") {
    doilu <- as.numeric(names(sort(table(nchar(a$V1)), decreasing = TRUE)[1])) + 2
    pola <- substr(a$V1, doilu - 3, doilu + 2)
  }

  a$pole1 <- as.numeric(unlist(lapply(strsplit(pola, "/"), function(x) x[1])))
  a$pole2 <- as.numeric(unlist(lapply(strsplit(pola, "/"), function(x) x[2])))

  a$V1 <- trimws(substr(a$V1, 1, nchar(a$V1) - 3))
  #a <- a[nchar(a$V1)>2,] # usuwamy puste lub prawie puste wiersze dodatkowo...
  a <- a[!(is.na(a$pole1) & is.na(a$pole2)), ] # usuwanie info o statusach
  colnames(a)[1] <- "parametr"
  a
}
