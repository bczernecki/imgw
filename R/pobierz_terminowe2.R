#' Funkcja pobierająca dane terminowe ale tylko dla wybranego roku / wielolecia
#'
#' Funkcja pobiera dane terminowe ze stacji SYNOP dostępne w jednym z katalogow pod adresem https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/terminowe/synop/
#' Jako argument nalezy podac POJEDYNCZY rok (>=2001) lub wielolecie (dla danych sprzed 2000)
#' 
#' @import RCurl rvest dplyr 
#' @importFrom data.table rbindlist
#' @importFrom XML readHTMLTable
#' @export
#' @examples
#' result <- pobierz_terminowe2(rok=2005) 
#' # jesli chcemy pobrac wiecej niz 1 rok warto skorzystac z funkcji 'lapply'
#' # ponizsza operacja automatycznie pobierze lata 2005-2007:
#' wynik <- lapply(2005:2007, pobierz_terminowe2)
#' library(data.table)
#' wynik2 <- rbindlist(wynik)



################################
################################
# to jest fragment dla terminowek

pobierz_terminowe2 <- function(rok=2017){
  okres <- "terminowe"
  meta <- metadane(okres="terminowe")[[1]]
  calosc <- NULL
  
    i <- rok
    cat(paste("wybrano rok", i))
    adres <- paste0("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/terminowe/synop/",i,"/")
    
    a <- RCurl::getURL(adres,ftp.use.epsv = FALSE,dirlistonly = TRUE)
    if(length(XML::readHTMLTable(a))==0) print("prawdopodobnie wybrano zly rok")
    ind <- XML::readHTMLTable(a)[[1]]$Name %>% grep(pattern=".zip")
    pliki <- XML::readHTMLTable(a)[[1]]$Name[ind] %>% as.character()
    
    for(dl in pliki){
      link <- paste0(adres, dl)
      print(link)
      temp <- tempfile()
      temp2 <- tempfile()
      download.file(link, temp)
      unzip(zipfile = temp, exdir = temp2)
      plik <- paste(temp2,dir(temp2),sep="/")[1]
      data <- read.csv(plik, header=F, stringsAsFactors = F, fileEncoding = "CP1250") 
      colnames(data) <- meta$V1
      unlink(c(temp, temp2))
      calosc <- rbind.data.frame(calosc, data)
    } # koniec petli po plikach .zip w katalogu dla wskazanego (wielo)lecia/roku
    
  colnames(calosc) <- meta$V1
  return(calosc)
}

###################################
###################################