#' Pobranie danych terminowych  (meteorologicznych) ze stacji SYNOP/KLIMAT udostepnionych w zbiorze danepubliczne.imgw.pl
#'
#' @param rzad rzad stacji (do wyboru: "synop", "klimat")
#' @param rok wektor dla wybranych lat (np. 1966:2000)
#' @param status czy pozostawic kolumny ze statusami pomiarow lub obserwacji (domyslnie status = FALSE - tj. kolumny ze statusami sa usuwane )
#' @param coords czy dodac koordynaty dla stacji (wartosc logiczna TRUE lub FALSE)
#' @import RCurl XML
#' @importFrom utils download.file unzip read.csv
#' @return
#' @export
#'
#' @examples \dontrun{
#'   terminowe <- meteo_terminowe(rzad = "klimat", lata = 1970:2000)
#'   head(terminowe)
#' }
#'

meteo_terminowe <- function(rzad = "synop", rok = 1966:2018, status = FALSE, coords = FALSE, ...){

  stopifnot(rzad == "synop" | rzad == "klimat") # dla terminowek tylko synopy i klimaty maja dane

  interwal <- "terminowe" # to mozemy ustawic na sztywno
  meta <- metadane(interwal = "terminowe", rzad = rzad)

  a <- getURL(paste0("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/", interwal, "/", rzad, "/"),
              ftp.use.epsv = FALSE,
              dirlistonly = TRUE)
  ind <- grep(readHTMLTable(a)[[1]]$Name, pattern = "/")
  katalogi <- as.character(readHTMLTable(a)[[1]]$Name[ind])

  # fragment dla lat (ktore katalogi wymagaja pobrania:
  lata_w_katalogach <- strsplit(gsub(x = katalogi, pattern = "/", replacement = ""), split = "_")
  lata_w_katalogach <- lapply(lata_w_katalogach, function(x) x[1]:x[length(x)])
  ind <- lapply(lata_w_katalogach, function(x) sum(x %in% rok) > 0)
  katalogi <- katalogi[unlist(ind)] # to sa nasze prawdziwe katalogi do przemielenia

  calosc <- vector("list", length = length(katalogi))

  for (i in seq_along(katalogi)){
    katalog <- gsub(katalogi[i], pattern = "/", replacement = "")

    if(rzad == "synop") {
      adres <- paste0("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/terminowe/",
                      rzad, "/", katalog, "/")
      zawartosc_folderu <- getURL(adres, ftp.use.epsv = FALSE, dirlistonly = FALSE) # zawartosc folderu dla wybranego roku

      ind <- grep(readHTMLTable(zawartosc_folderu)[[1]]$Name, pattern = "zip")
      pliki <- as.character(readHTMLTable(zawartosc_folderu)[[1]]$Name[ind])
      adresy_do_pobrania <- paste0(adres, pliki)
      # w tym miejscu trzeba przemyslec fragment kodu do dodania dla pojedynczej stacji jesli tak sobie zazyczy uzytkownik:
      # na podstawie zawartosci obiektu pliki

      for(j in seq_along(adresy_do_pobrania)){
        temp <- tempfile()
        temp2 <- tempfile()
        download.file(adresy_do_pobrania[j], temp)
        unzip(zipfile = temp, exdir = temp2)
        plik1 <- paste(temp2, dir(temp2), sep = "/")
        data1 <- read.csv(plik1, header = FALSE, stringsAsFactors = FALSE, fileEncoding = "CP1250")
        colnames(data1) <- meta[[1]]$parametr

        # usuwa statusy
        if(status == FALSE){
          data1[grep("^Status", colnames(data1))] = NULL
        }

        unlink(c(temp, temp2))
        calosc[[i]] <- data1
      } # koniec petli po zipach do pobrania
    } # koniec if'a dla synopa

    ######################
    ###### KLIMAT: #######
    ######################
    if(rzad == "klimat") {
      adres <- paste0("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/terminowe/",
                      rzad, "/", katalog, "/")
      zawartosc_folderu <- getURL(adres, ftp.use.epsv = FALSE, dirlistonly = FALSE) # zawartosc folderu dla wybranego roku

      ind <- grep(readHTMLTable(zawartosc_folderu)[[1]]$Name, pattern = "zip")
      pliki <- as.character(readHTMLTable(zawartosc_folderu)[[1]]$Name[ind])
      adresy_do_pobrania <- paste0(adres, pliki)
      # w tym miejscu trzeba przemyslec fragment kodu do dodania dla pojedynczej stacji jesli tak sobie zazyczy uzytkownik:
      # na podstawie zawartosci obiektu pliki

      for(j in seq_along(adresy_do_pobrania)){
        temp <- tempfile()
        temp2 <- tempfile()
        download.file(adresy_do_pobrania[j], temp)
        unzip(zipfile = temp, exdir = temp2)
        plik1 <- paste(temp2, dir(temp2), sep = "/")
        data1 <- read.csv(plik1, header = FALSE, stringsAsFactors = FALSE, fileEncoding = "CP1250")
        colnames(data1) <- meta[[1]]$parametr
        # usuwa statusy
        if(status == FALSE){
          data1[grep("^Status", colnames(data1))] = NULL
        }

        unlink(c(temp, temp2))
        calosc[[i]] <- data1
      } # koniec petli po zipach do pobrania
    } # koniec if'a dla klimatu



  } # koniec petli po glownych katalogach danych dobowych



  calosc <- do.call(rbind, calosc)

  # dodaje rzad
  kod_rzedu <- switch(rzad, synop = "SYNOPTYCZNA", klimat = "KLIMATYCZNA")
  calosc <- cbind(data.frame(Kod_rzedu = kod_rzedu), calosc)

  if (coords){
    # data("stacje_meteo")
    calosc <- merge(stacje_meteo, calosc, by.x = "Kod_stacji", by.y = "Kod stacji", all.y = TRUE)
  }


  return(calosc[calosc$Rok %in% rok, ]) # przyciecie tylko do wybranych lat gdyby sie pobralo za duzo
} # koniec funkcji meteo_terminowe
