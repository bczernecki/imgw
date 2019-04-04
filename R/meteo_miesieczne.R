#' Pobranie danych miesiecznych (meteorologicznych) ze stacji SYNOP/KLIMAT/OPAD udostepnionych w zbiorze danepubliczne.imgw.pl
#'
#' @param rzad rzad stacji (do wyboru: "synop" , "klimat" , "opad")
#' @param rok wektor dla wybranych lat (np. 1966:2000)
#' @param status czy usunac kolumny ze statusami pomiarow lub obserwacji (domyslnie status = FALSE - tj. kolumny ze statusami sa usuwane)
#' @param coords czy dodac wspolrzedne (WGS84) i wysokosc stacji? (domyslnie coords = FALSE)
#' @import RCurl XML
#' @importFrom utils download.file unzip read.csv
#' @return
#' @export
#'
#' @examples \dontrun{
#'   mies <- meteo_miesieczne(rzad = "klimat")
#'   head(mies)
#' }
#'

meteo_miesieczne <- function(rzad = "synop", rok = 1966:2018, status = FALSE, coords = FALSE, ...){

    interwal <- "miesieczne" # to mozemy ustawic na sztywno
    meta <- metadane(interwal = "miesieczne", rzad = rzad)

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
      # print(i)
      katalog <- gsub(katalogi[i], pattern = "/", replacement = "")

      if(rzad == "synop") {
        adres <- paste0("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/miesieczne/",
                        rzad, "/", katalog, "/", katalog, "_m_s.zip")
      }
      if(rzad == "klimat") {
        adres <- paste0("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/miesieczne/",
                        rzad, "/", katalog, "/", katalog, "_m_k.zip")
      }
      if(rzad == "opad") {
        adres <- paste0("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/miesieczne/",
                        rzad, "/", katalog, "/", katalog, "_m_o.zip")
      }

      temp <- tempfile()
      temp2 <- tempfile()
      download.file(adres, temp)
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
      calosc[[i]] <- merge(data1, data2, by = c("Kod stacji", "Rok", "Miesiąc"), all.x = TRUE)
    }

    calosc <- do.call(rbind, calosc)
    calosc <- calosc[calosc$Rok %in% rok, ]

    # dodaje rzad
    kod_rzedu <- switch(rzad, synop = "SYNOPTYCZNA", klimat = "KLIMATYCZNA", opad = "OPADOWA")
    calosc <- cbind(data.frame(Kod_rzedu = kod_rzedu), calosc)

    if (coords){
      # data("stacje_meteo")
      calosc <- merge(stacje_meteo, calosc, by.x = "Kod_stacji", by.y = "Kod stacji", all.y = TRUE)
    }

    return(calosc) # przyciecie tylko do wybranych lat gdyby sie pobralo za duzo
}
