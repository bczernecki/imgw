#' Pobranie danych hydrologicznych dla dobowego okresu
#' udostepnionego w zbiorze danepubliczne.imgw.pl
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
#Gruboć lodu
#0   oznacza brak pomiaru gruboci lodu ze względu na brak zjawisk lodowych
#999 oznacza brak pomiaru gruboci lodu przy występowaniu zjawisk lodowych lub (w miesišcach letnich)
#występowanie zarastania przy braku zjawisk lodowych (tzn. jeli kod pole zjawiska lodowego jest puste)

hydro_dobowe = function(rok = 1966:2000,coords=FALSE){
  base_url <- "https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_hydrologiczne/"
  interwal="dobowe"
  a <- getURL(paste0(base_url, interwal, "/"),
              ftp.use.epsv = FALSE,
              dirlistonly = TRUE)

  ind <- grep(readHTMLTable(a)[[1]]$Name, pattern = "/")
  katalogi <- as.character(readHTMLTable(a)[[1]]$Name[ind])
  katalogi <-gsub(x = katalogi, pattern = "/", replacement = "")
  # mniej plików do wczytywania
  katalogi=katalogi[katalogi %in% as.character(rok)]

  adres_meta1=paste0(base_url,interwal,"/codz_info.txt")
  adres_meta2=paste0(base_url,interwal,"/zjaw_info.txt")
  meta <- list(hydro_clean_metadata(adres_meta1,interwal),hydro_clean_metadata(adres_meta2,interwal))

  # Dobowe maja 13 plików w katalogu ta petla działa póki co na miesięczne
  calosc <- vector("list", length = length(katalogi))
  for (i in seq_along(katalogi)){
    katalog=katalogi[i]
    print(i)

  iterator=c("01","02","03","04","05","06","07","08","09","10","11","12")
   for (j in seq_along(iterator)) {
     adres <- paste0(base_url, interwal, "/", katalog, "/codz_", katalog,"_",iterator[j], ".zip")
     temp <- tempfile()
     temp2<- tempfile()
     download.file(adres, temp)
     unzip(zipfile = temp, exdir = temp2)
     plik1 <- paste(temp2, dir(temp2), sep = "/")[1]
     data1 <- read.csv(plik1, header = FALSE, stringsAsFactors = FALSE, fileEncoding = "CP1250")
     colnames(data1) <- meta[[1]]
   }
  adres <- paste0(base_url, interwal, "/", katalog, "/zjaw_", katalog,".zip")

   temp <- tempfile()
   temp2 <- tempfile()
   download.file(adres, temp)
   unzip(zipfile = temp, exdir = temp2)
   plik2 <- paste(temp2, dir(temp2), sep = "/")[1]
   data2 <- read.csv(plik2, header = FALSE, stringsAsFactors = FALSE, fileEncoding = "CP1250")
   colnames(data2) <- meta[[2]]
   # czesc wspolna
   #Kod stacji
   #Nazwa stacji
   #Nazwa rzeki/jeziora
   #Rok hydrologiczny
   #Wskanik miesišca w roku hydrologicznym
   #Dzień

   calosc[[i]] <- merge(data1, data2, by = c("Kod stacji", "Nazwa stacji", "Rok hydrologiczny", "Nazwa rzeki/jeziora",
                                             "Wskaźnik miesiąca w roku hydrologicznym", "Dzień"), all.x = TRUE)
  }
  calosc <- do.call(rbind, calosc)
  #calosc <- calosc[calosc$Rok %in% rok, ]
  # czesc wspolna
  #Kod stacji
  #Nazwa stacji
  #Nazwa rzeki/jeziora
  #Rok hydrologiczny
  #Wskanik miesišca w roku hydrologicznym
  #Dzień
  calosc <- do.call(rbind, calosc)
  calosc[calosc==9999]<-NA
  calosc[calosc==99999.999]<-NA
  calosc[calosc==99.9]<-NA
  #zjawiska lodowe nie uwzględniam 0 przy braku zjawisk lodowych bo to znaczy ze było poprostu 0
  calosc[calosc==999]<-NA
  #calosc <- calosc[calosc$`Rok hydrologiczny` %in% rok, ]
  return(calosc)
}
