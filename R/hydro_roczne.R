#' Semiannual and annual hydrological data
#'
#' Pobranie danych hydrologicznych dla rocznego okresu
#' udostepnionego w zbiorze danepubliczne.imgw.pl
#'
#' @param rok wektor dla wybranych lat hydrologicznych (np. 1966:2000)
#' @param coords czy dodac wspolrzedne (WGS84) i wysokosc stacji? (domyslnie coords = FALSE)
#' @param value rodzaj danych (do wyboru: "Stan=H (domyslnie)" , "Przepływ=Q" , "Temperatura=T")
#' @importFrom RCurl getURL
#' @importFrom XML readHTMLTable
#' @importFrom utils download.file unzip read.csv
#' @return
#' @export
#'
#' @examples \dontrun{
#'   roczne <- hydro_roczne(rok = 2000,value="H")
#'   head(mies)
#' }
#'
# do wyboru jeden z 3 value nie zadziała dla pobrania wszystkiego na raz przytanie czy potrzeba?
# nie używam coords czy jest taka baza jak ("stacje_meteo")?

hydro_roczne <-  function(rok = 1966:2000, coords = FALSE, value = "H"){
  base_url <- "https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_hydrologiczne/"
  interwal <- "polroczne_i_roczne"
  a <- getURL(paste0(base_url, interwal, "/"),
              ftp.use.epsv = FALSE,
              dirlistonly = TRUE)

  ind <- grep(readHTMLTable(a)[[1]]$Name, pattern = "/")
  katalogi <- as.character(readHTMLTable(a)[[1]]$Name[ind])
  katalogi <- gsub(x = katalogi, pattern = "/", replacement = "")
  # mniej plików do wczytywania
  katalogi <- katalogi[katalogi %in% as.character(rok)]
  meta <- hydro_metadane(interwal)

  calosc <- vector("list", length = length(katalogi))
  for (i in seq_along(katalogi)){
    katalog <- katalogi[i]
    #print(i)

    adres <- paste0(base_url, interwal, "/", katalog, "/polr_", value, "_", katalog, ".zip")

    temp <- tempfile()
    temp2 <- tempfile()
    download.file(adres, temp)
    unzip(zipfile = temp, exdir = temp2)
    plik1 <- paste(temp2, dir(temp2), sep = "/")[1]
    data1 <- read.csv(plik1, header = FALSE, stringsAsFactors = FALSE, fileEncoding = "CP1250")
    colnames(data1) <- meta[,value]
    calosc[[i]] <- data1
  }
  calosc <- do.call(rbind, calosc)
  # ten sam warunek braku danych lub obserwacji dla wszytkich wartosci
  calosc[calosc==99999.999] <- NA
  # brak wykorzystania coords
  return(calosc)
}
