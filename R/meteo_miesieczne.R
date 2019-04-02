#' Pobranie danych miesięcznych (meteorologicznych) ze stacji SYNOP/KLIMAT/OPAD udostępnionych w zbiorze danepubliczne.imgw.pl
#'
#' @import RCurl XML
#' @importFrom utils download.file unzip read.csv
#'
#' @return
#' @export
#'
#' @examples mies <- meteo_miesieczne(rzad = "klimat")
#' @examples head(mies)
#'

meteo_miesieczne = function(rzad = "synop"){

  # TODO:
  # 1: DODAC %>%  oraz data.table z rbindlist() do eksportowanych funkcji:
  # 2: Dane miesieczne maja 2 rodzaje plikow; w tej chwili pobiera sie tylko pierwszy rodzaj
  # 3: zamiast walic w rbind.data.frame lepiej w listy i pozniej poleciec rbindlistem
  # 4: w tej chwili uzytkownik pobiera wszystkie lata; byc moze warto dac mu wybor - przyda sie takze w innych funkcjach pobierajacych

    interwal <-  "miesieczne" # to mozemy ustawic na sztywno
    meta <- metadane(interwal="miesieczne", rzad = rzad)[[1]]
    meta <- metadane(interwal="miesieczne", rzad = rzad)

    a <- getURL(paste0("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/",interwal,"/", rzad,"/"),ftp.use.epsv = FALSE,dirlistonly = TRUE)
    ind <- readHTMLTable(a)[[1]]$Name %>% grep(pattern="/")
    katalogi <- readHTMLTable(a)[[1]]$Name[ind] %>% as.character()
    calosc <- NULL

    for (i in 1:length(katalogi)){
      print(i)
      katalog <- gsub(katalogi[i], pattern="/", replacement = "")

      if(rzad == "synop")   adres <- paste0("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/miesieczne/",rzad,"/",katalog,"/",katalog,"_m_s.zip")
      if(rzad == "klimat")   adres <- paste0("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/miesieczne/",rzad,"/",katalog,"/",katalog,"_m_k.zip")
      temp <- tempfile()
      temp2 <- tempfile()
      download.file(adres, temp)
      unzip(zipfile = temp, exdir = temp2)
      plik1 <- paste(temp2,dir(temp2),sep="/")[1]
      data1 <- read.csv(plik1, header=F, stringsAsFactors = F, fileEncoding = "CP1250")
      colnames(data1) <- meta[[1]]$parametr

      plik2 <- paste(temp2,dir(temp2),sep="/")[2]
      data2 <- read.csv(plik2, header=F, stringsAsFactors = F, fileEncoding = "CP1250")
      colnames(data2) <- meta[[2]]$parametr

      unlink(c(temp, temp2))
      calosc[[i]] <- left_join(data1,data2)
    }

    #return(data.table::rbindlist(calosc, fill = T)) # trzeba sie zastanowic ktore z ponizzszych rozwiazan jest lepsze
    return(do.call(rbind, calosc))
  }



