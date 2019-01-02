#' Funkcja czyszczaca metadane dla plikow miesiecznych
#' 
#' Tylko do wewnetrznego uzytku...
#' Na potrzeby funkcji 'metadane()'
#' @param adres  adres URL do pliku z metadanymi
#' @importFrom RCurl getURL
#' @importFrom utils read.fwf
#' @importFrom stats na.omit
#'
#' @export
#' 

clean_metadata_miesieczne <- function(adres){
  a <- na.omit(read.fwf(adres, widths = c(1000),  fileEncoding="CP1250", stringsAsFactors=F))
  doilu <- max(sort(table(nchar(a$V1))))
  pola <- substr(a$V1,doilu-3,doilu+2)
  a$pole1 <- as.numeric(unlist(lapply(strsplit(pola, "/"), function(x) x[1])))
  a$pole2 <- as.numeric(unlist(lapply(strsplit(pola, "/"), function(x) x[2])))
  
  a$V1 <- trimws(substr(a$V1, 1, nchar(a$V1)-3))
  a#a <- a[nchar(a$V1)>2,] # usuwamy puste lub prawie puste wiersze dodatkowo...
  a <- a[!(is.na(a$pole1) & is.na(a$pole2)),] # usuwanie info o statusach
  a
}
