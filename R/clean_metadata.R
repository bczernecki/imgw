#' Pobieranie danych meteorologicznych z serwisu IMGW-PIB (https://dane.imgw.pl)
#'
#' Funkcja pozwalająca na wyczyszczenie pliku z metadanymi wymaganego do procesu pobierania danych meteorologicznych i hydrologicznych z oficjalnego repozytorium Instytutu Meteorologii i Gospodarki Wodnej - Państwowego Instytutu Badawczego - https://dane.imgw.pl.
#' 
#' @param adres  adres URL do pliku z metadanymi 

#' @importFrom RCurl getURL
#' @importFrom parallel mclapply
#'
#' @export
#' @examples
#' # wymagane ustalenie ponizszych parametrow pobierania:
#' 
#' user_pass <- "" # pamietaj o wpisaniu swojego loginu:tokena wg schematu zawartego w opisie!
#' data_start <- "2016-12-26" 
#' data_end <- "2017-02-20" 
#' stacja <- "352160330" # przykladowe id dla Poznania; numer mozna pobrac ze strony https://dane.imgw.pl
#' kod <- "B100B008CD" # srednia dobowa temp. powietrza synop; j.w.
#' cores <- 4 # liczba watkow do mclapply
#' pobierz_lapply(data_start,data_end,user_pass,stacja,kod,cores)
#' 
#' 
#' # mozna takze uruchomic w petli dla kilku stacji...
#' 
#' stacja <- c("350150500", "350190560", "350160520","351160415", "350170530")
#' kod <- "B609B00400"
#' for(stacja2 in stacja){
#'   data_start <- "1966-01-01"
#'   data_end <- "2017-01-01"
#'   tmp <- pobierz_lapply(data_start,data_end,user_pass,stacja2,kod, cores=4) # pobieranie danych
#'    write.table(x = tmp, file=paste0(stacja2, ".csv" ), row.names = F) # zapisywanie danego roku do pliku
#' } # koniec petli dla stacji




library(RCurl)
library(rvest)
library(XML)

clean_metadata <- function(adres){
  a <- na.omit(read.fwf(adres, widths = c(1000),  fileEncoding="CP1250", stringsAsFactors=F))
  doilu <- max(nchar(a$V1),na.rm=T)
  pola <- substr(a$V1,doilu-3,doilu)
  a$pole1 <- as.numeric(unlist(lapply(strsplit(pola, "/"), function(x) x[1])))
  a$pole2 <- as.numeric(unlist(lapply(strsplit(pola, "/"), function(x) x[2])))
  
  a$V1 <- trimws(substr(a$V1, 1, nchar(a$V1)-3))
  #a <- a[nchar(a$V1)>2,] # usuwamy puste lub prawie puste wiersze dodatkowo...
  a <- a[!(is.na(a$pole1) & is.na(a$pole2)),] # usuwanie info o statusach
  a
}
