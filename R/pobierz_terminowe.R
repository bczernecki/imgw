#' Funkcja pobierająca dane terminowe
#'
#' Funkcja pobiera wszystkie dostępne dane terminowe ze stacji SYNOP dostępne w zbiorze danepubliczne.imgw.pl
#' W obecnej (mocno roboczej postaci) funkcja pobiera wszystkie dane, co wymaga dostepu do duzej ilosc pamieci RAM (~kilkadziesiat GB)
#' 
#' @import RCurl rvest dplyr 
#' @importFrom data.table rbindlist
#' @importFrom XML readHTMLTable
#' @export
#' @examples
#' result <- pobierz_terminowe() # currently requires lot of memory!


################################
################################
# to jest fragment dla terminowek

pobierz_terminowe <- function(){
  okres <- "terminowe"
  meta <- metadane(okres="terminowe")[[1]]
  
  a <- RCurl::getURL(paste0("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/",okres,"/synop/"),ftp.use.epsv = FALSE,dirlistonly = TRUE)
  ind <- rvest::readHTMLTable(a)[[1]]$Name %>% grep(pattern="/")
  katalogi <- rvest::readHTMLTable(a)[[1]]$Name[ind] %>% as.character()
  calosc <- NULL
  
  for (i in 1:length(katalogi)){
    print(i)
    katalog <- gsub(katalogi[i], pattern="/", replacement = "")
    adres <- paste0("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/terminowe/synop/",katalog,"/")
    
      a <- RCurl::getURL(adres,ftp.use.epsv = FALSE,dirlistonly = TRUE)
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
            } # koniec petli po plikach .zip w katalogu dla danego (wielo)lecia/roku
    
  } # koniec petli po katalogach (wieloleciach)
  colnames(calosc) <- meta$V1
  return(calosc)
}

###################################
###################################