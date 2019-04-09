#' Monthly hydrological data
#'
#' Downloading hydrological data for the monthly period, available in the collection danepubliczne.imgw.pl
#'
#'
#' @param year vector of years (e.g. 1966:2000)
#' @param coords geographical coordinates if TRUE (WGS84)  (defaults coords = FALSE)
#' @importFrom RCurl getURL
#' @importFrom XML readHTMLTable
#' @importFrom utils download.file unzip read.csv
#' @return
#' @export
#'
#' @examples \dontrun{
#'   monthly <- hydro_monthly(year = 2000)
#'   head(mies)
#' }
#'
# Stan wody 9999 oznacza brak danych w bazie lub przerwy w obserwacjach w danym miesiącu i stad brak możliwości obliczenia charakterystyk.
#Przepływ 99999.999 oznacza brak danych lub przerwy w obserwacjach w danym miesiacu i stad brak możliwości obliczenia charakterystyk.
#Temperatura wody 99.9 oznacza brak danych lub przerwy w obserwacjach w danym miesiacu i stad brak możliwości obliczenia charakterystyk.
hydro_monthly <- function(year = 1966:2000, coords = FALSE){
  base_url <- "https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_hydrologiczne/"
  interval <- "miesieczne"
  a <- getURL(paste0(base_url, interval, "/"),
              ftp.use.epsv = FALSE,
              dirlistonly = TRUE)

  ind <- grep(readHTMLTable(a)[[1]]$Name, pattern = "/")
  catalogs  <- as.character(readHTMLTable(a)[[1]]$Name[ind])
  catalogs  <- gsub(x = catalogs , pattern = "/", replacement = "")
  catalogs  <- catalogs [catalogs  %in% as.character(year)]
  meta <- hydro_metadane(interval)

  all_data <- vector("list", length = length(catalogs ))
  for (i in seq_along(catalogs )){
    catalog <- catalogs [i]
    #print(i)

    adres <- paste0(base_url, interval, "/", catalog, "/mies_", catalog, ".zip")

    temp <- tempfile()
    temp2 <- tempfile()
    download.file(adres, temp)
    unzip(zipfile = temp, exdir = temp2)
    file1 <- paste(temp2, dir(temp2), sep = "/")[1]
    data1 <- read.csv(file1, header = FALSE, stringsAsFactors = FALSE, fileEncoding = "CP1250")
    colnames(data1) <- meta
    all_data[[i]] <-data1
  }
  all_data <- do.call(rbind, all_data)
  # wyjatki na brak stanu, przeplywu i temperatury
  all_data[all_data==9999] <- NA
  all_data[all_data==99999.999] <- NA
  all_data[all_data==99.9] <- NA
  # brak wykorzystania coords
  return(all_data)
}
