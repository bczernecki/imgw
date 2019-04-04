#' Pobranie danych dobowych (meteorologicznych) ze stacji SYNOP/KLIMAT/OPAD udostepnionych w zbiorze danepubliczne.imgw.pl
#'
#' @param rzad rzad stacji (do wyboru: "synop" , "klimat" , "opad")
#' @param lata wektor dla wybranych lat (np. 1966:2000)
#' @param status czy pozostawic kolumny ze statusami pomiarow lub obserwacji (domyslnie status = FALSE - tj. kolumny ze statusami sa usuwane )
#' @param coords czy dodac koordynaty dla stacji (wartosc logiczna TRUE lub FALSE)
#' @import RCurl XML magrittr
#' @importFrom utils download.file unzip read.csv
#' @return
#' @export
#'
#' @examples \dontrun{
#'   dobowe <- meteo_dobowe(rzad = "klimat", lata = 1970:2000)
#'   head(dobowe)
#' }
#'

meteo_dobowe <- function(rzad = "synop", lata = 1966:2018, status = FALSE, coords = FALSE, ...){

  interwal <- "dobowe" # to mozemy ustawic na sztywno
  meta <- metadane(interwal = "dobowe", rzad = rzad)

  a <- getURL(paste0("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/", interwal, "/", rzad, "/"),
              ftp.use.epsv = FALSE,
              dirlistonly = TRUE)
  ind <- grep(readHTMLTable(a)[[1]]$Name, pattern = "/")
  katalogi <- as.character(readHTMLTable(a)[[1]]$Name[ind])

  # fragment dla lat (ktore katalogi wymagaja pobrania:
  lata_w_katalogach <- strsplit( gsub(x= katalogi, pattern = "/", replacement = ""), split="_")
  lata_w_katalogach <- lapply(lata_w_katalogach, function(x) x[1]:x[length(x)])
  ind <- lapply(lata_w_katalogach, function(x) sum(x %in% lata)>0)
  katalogi <- katalogi[unlist(ind)] # to sa nasze prawdziwe katalogi do przemielenia

  calosc <- vector("list", length = length(katalogi))

  for (i in seq_along(katalogi)){
    katalog <- gsub(katalogi[i], pattern = "/", replacement = "")

    if(rzad == "synop") {
      adres <- paste0("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/dobowe/",
                      rzad, "/", katalog, "/")
      zawartosc_folderu <- getURL(adres,ftp.use.epsv = FALSE,dirlistonly = FALSE) # zawartosc folderu dla wybranego roku

      ind <- grep(readHTMLTable(zawartosc_folderu)[[1]]$Name,pattern = "zip")
      pliki <- readHTMLTable(zawartosc_folderu)[[1]]$Name[ind] %>% as.character()
      adresy_do_pobrania <- paste0(adres,pliki)
      # w tym miejscu trzeba przemyslec fragment kodu do dodania dla pojedynczej stacji jesli tak sobie zazyczy uzytkownik:
      # na podstawie zawartosci obiektu pliki

      for(j in seq_along(adresy_do_pobrania)){
        temp <- tempfile()
        temp2 <- tempfile()
        download.file(adresy_do_pobrania[j], temp)
        unzip(zipfile = temp, exdir = temp2)
        plik1 <- paste(temp2, dir(temp2), sep = "/")[1]
        data1 <- read.csv(plik1, header = FALSE, stringsAsFactors = FALSE, fileEncoding = "CP1250")
        colnames(data1) <- meta[[1]]$parametr

        plik2 <- paste(temp2, dir(temp2), sep = "/")[2]
        data2 <- read.csv(plik2, header = FALSE, stringsAsFactors = FALSE, fileEncoding = "CP1250")
        colnames(data2) <- meta[[2]]$parametr

        # usuwa statusy
        if(status == FALSE){
          data1[grep("^Status", colnames(data1))] = NULL
          data2[grep("^Status", colnames(data2))] = NULL
        }

        unlink(c(temp, temp2))
        calosc[[i]] <- merge(data1, data2, by = c("Kod stacji", "Nazwa stacji", "Rok", "Miesiąc"), all.x = TRUE)
      } # koniec petli po zipach do pobrania

    } # koniec if'a dla synopa


    } # koniec petli po glownych katalogach danych dobowych


    # TODO:
    # to samo dla KLIMATow i OPADowek:

    # if(rzad == "klimat") {
    # }
    #
    # if(rzad == "opad") {
    # }


  calosc <- do.call(rbind, calosc)
  return(calosc[calosc$Rok %in% lata,]) # przyciecie tylko do wybranych lat gdyby sie pobralo za duzo
} # koniec funkcji meteo_dobowe
