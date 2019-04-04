#' Pobranie danych miesiecznych (meteorologicznych) ze stacji SYNOP/KLIMAT/OPAD udostepnionych w zbiorze danepubliczne.imgw.pl
#'
#' @param rzad rzad stacji (do wyboru: "synop" , "klimat" , "opad")
#' @import RCurl XML magrittr
#' @importFrom utils download.file unzip read.csv
#' @return
#' @export
#'
#' @examples \dontrun{
#'   mies <- meteo_miesieczne(rzad = "klimat")
#'   head(mies)
#' }
#'

meteo_miesieczne <- function(rzad = "synop", ...){

  # TODO:
  # 1: DODAC %>%  oraz data.table z rbindlist() do eksportowanych funkcji:
  # 2: Dane miesieczne maja 2 rodzaje plikow; w tej chwili pobiera sie tylko pierwszy rodzaj
  # 3: zamiast walic w rbind.data.frame lepiej w listy i pozniej poleciec rbindlistem
  # 4: w tej chwili uzytkownik pobiera wszystkie lata; byc moze warto dac mu wybor - przyda sie takze w innych funkcjach pobierajacych

    interwal <- "miesieczne" # to mozemy ustawic na sztywno
    meta <- metadane(interwal = "miesieczne", rzad = rzad)

    a <- getURL(paste0("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/", interwal, "/", rzad, "/"),
                ftp.use.epsv = FALSE,
                dirlistonly = TRUE)
    ind <- grep(readHTMLTable(a)[[1]]$Name, pattern = "/")
    katalogi <- as.character(readHTMLTable(a)[[1]]$Name[ind])
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
      data1[grep("^Status", colnames(data1))] = NULL
      data2[grep("^Status", colnames(data2))] = NULL

      unlink(c(temp, temp2))
      #calosc[[i]] <- left_join(data1, data2, by = c("Kod stacji", "Nazwa stacji", "Rok", "Miesiąc"))
      calosc[[i]] <- merge(data1, data2, by = c("Kod stacji", "Nazwa stacji", "Rok", "Miesiąc"), all.x = TRUE)
    }

    #return(data.table::rbindlist(calosc, fill = T)) # trzeba sie zastanowic ktore z ponizzszych rozwiazan jest lepsze
    return(do.call(rbind, calosc))
  }
