#' Pobranie danych hydrologicznych dla okresów "dobowe" , "miesieczny" , "polroczne_i_roczne"
#' udostepnionych w zbiorze danepubliczne.imgw.pl
#'
#' @param interwal interwał stacji (do wyboru: "dobowe" , "miesieczny"(domyslnie) , "polroczne_i_roczne")
#' @param rok wektor dla wybranych lat (np. 1966:2000)
#' @param coords czy dodac wspolrzedne (WGS84) i wysokosc stacji? (domyslnie coords = FALSE)
#' @import RCurl XML
#' @importFrom utils download.file unzip read.csv
#' @return
#' @export
#'
#' @examples \dontrun{
#'
#' }
#'
# Stan wody 9999 oznacza brak danych w bazie lub przerwy w obserwacjach w danym miesiącu i stad brak możliwości obliczenia charakterystyk.
#Przepływ 99999.999 oznacza brak danych lub przerwy w obserwacjach w danym miesiacu i stad brak możliwości obliczenia charakterystyk.
#Temperatura wody 99.9 oznacza brak danych lub przerwy w obserwacjach w danym miesiacu i stad brak możliwości obliczenia charakterystyk.
library(RCurl)
library(XML)
library(utils)
# Działa tylko dla miesiecznych hydro
hydro = function(interwal="miesieczne",rok = 1966:2000,coords=FALSE){
  base_url <- "https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_hydrologiczne/"

  a <- getURL(paste0(base_url, interwal, "/"),
              ftp.use.epsv = FALSE,
              dirlistonly = TRUE)

  ind <- grep(readHTMLTable(a)[[1]]$Name, pattern = "/")
  katalogi <- as.character(readHTMLTable(a)[[1]]$Name[ind])
  katalogi <-gsub(x = katalogi, pattern = "/", replacement = "")
# pewnie można to zastapić jakąś funkcją zeby nie pisać tego tyle razy...
  if(interwal == "miesieczne") {
    adres_meta=paste0(base_url,interwal,"/mies_info.txt")
    meta <- hydro_clean_metadata(adres_meta,interwal)
  }
  #interwal="polroczne_i_roczne"
  if(interwal == "polroczne_i_roczne") { # trzeba inaczej iterować jeszcze nie zrobione
    adres_meta=paste0(base_url,interwal,"/polr_info.txt")
    meta <- hydro_clean_metadata(adres_meta,interwal)

  }
  interwal="dobowe"
  if(interwal== "dobowe") {
    adres_meta=paste0(base_url,interwal,"/codz_info.txt")
    meta <- hydro_clean_metadata(adres_meta,interwal)
  }
  # Dobowe maja 13 plików w katalogu ta petla działa póki co na miesięczne
  calosc <- vector("list", length = length(katalogi))
  for (i in seq_along(katalogi)){
    katalog=katalogi[i]
    print(i)

    if(interwal == "miesieczne") {
      adres <- paste0(base_url, interwal, "/", katalog, "/mies_", katalog, ".zip")
    }
    #interwal="polroczne_i_roczne"
    if(interwal == "polroczne_i_roczne") { # trzeba inaczej iterować jeszcze nie zrobione
      adres_H <- paste0(base_url, interwal, "/", katalog, "polr_H_", katalog, ".zip")
      adres_Q <- paste0(base_url, interwal, "/", katalog, "polr_Q_", katalog, ".zip")
      adres_T <- paste0(base_url, interwal, "/", katalog, "polr_T_", katalog, ".zip")
      adres=list(adres_H=adres_H,adres_Q=adres_Q,adres_T=adres_T)
    }
    #interwal="dobowe"
    if(interwal== "dobowe") {
      adres_meta=paste0(base_url,interwal,"/codz_info.txt")
      meta <- hydro_clean_metadata(adres_meta,interwal)
      adres <- paste0(base_url, interwal, "/", katalog, "polr_H_", katalog, ".zip")
    }

    temp <- tempfile()
    temp2 <- tempfile()
    download.file(adres, temp)
    unzip(zipfile = temp, exdir = temp2)
    plik1 <- paste(temp2, dir(temp2), sep = "/")[1]
    data1 <- read.csv(plik1, header = FALSE, stringsAsFactors = FALSE, fileEncoding = "CP1250")
    colnames(data1) <- meta
    calosc[[i]] <-data1
}
  calosc <- do.call(rbind, calosc)
  calosc <- calosc[calosc$`Rok hydrologiczny` %in% rok, ]
  return(calosc)
  }
a <- suppressWarnings(na.omit(read.fwf("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_hydrologiczne/miesieczne/mies_info.txt", widths = c(1000), fileEncoding = "CP1250", stringsAsFactors = FALSE)))
b<-a[2:11,]
a$pole1 <- suppressWarnings(as.numeric(unlist(lapply(strsplit(pola, "/"), function(x) x[1]))))
