#' Monthly hydrological data
#'
#' Pobranie danych hydrologicznych dla miesiecznego okresu, udostepnionych w zbiorze danepubliczne.imgw.pl
#'
#'
#' @param rok wektor dla wybranych lat (np. 1966:2000)
#' @param coords czy dodac wspolrzedne (WGS84) i wysokosc stacji? (domyslnie coords = FALSE)
#' @importFrom RCurl getURL
#' @importFrom XML readHTMLTable
#' @importFrom utils download.file unzip read.csv
#' @return
#' @export
#'
#' @examples \dontrun{
#'   mies <- hydro_miesieczne(rok = 2000)
#'   head(mies)
#' }
#'
# Stan wody 9999 oznacza brak danych w bazie lub przerwy w obserwacjach w danym miesiącu i stad brak możliwości obliczenia charakterystyk.
#Przepływ 99999.999 oznacza brak danych lub przerwy w obserwacjach w danym miesiacu i stad brak możliwości obliczenia charakterystyk.
#Temperatura wody 99.9 oznacza brak danych lub przerwy w obserwacjach w danym miesiacu i stad brak możliwości obliczenia charakterystyk.
hydro_miesieczne <- function(rok = 1966:2000, coords = FALSE){
  base_url <- "https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_hydrologiczne/"
  interwal <- "miesieczne"
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

    adres <- paste0(base_url, interwal, "/", katalog, "/mies_", katalog, ".zip")

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
  # wyjatki na brak stanu, przeplywu i temperatury
  calosc[calosc==9999] <- NA
  calosc[calosc==99999.999] <- NA
  calosc[calosc==99.9] <- NA
  # brak wykorzystania coords
  return(calosc)
}
