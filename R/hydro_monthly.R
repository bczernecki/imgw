#' Monthly hydrological data
#'
#' Downloading monthly hydrological data from the danepubliczne.imgw.pl collection
#'
#' @param year vector of years (e.g., 1966:2000)
#' @param station name or ID of hydrological station(s).
#' It accepts names (characters in CAPITAL LETTERS) or stations' IDs (numeric)
#' @importFrom RCurl getURL
#' @importFrom XML readHTMLTable
#' @importFrom utils download.file unzip read.csv
#' @export
#'
#' @examples \dontrun{
#'   monthly <- hydro_monthly(year = 2000)
#'   head(monthly)
#' }
#'
hydro_monthly <- function(year, station = NULL){
  base_url <- "https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_hydrologiczne/"
  interval <- "monthly"
  interval_pl <- "miesieczne"
  a <- getURL(paste0(base_url, interval_pl, "/"),
              ftp.use.epsv = FALSE,
              dirlistonly = TRUE)

  ind <- grep(readHTMLTable(a)[[1]]$Name, pattern = "/")
  catalogs <- as.character(readHTMLTable(a)[[1]]$Name[ind])
  catalogs <- gsub(x = catalogs, pattern = "/", replacement = "")
  catalogs <- catalogs[catalogs  %in% as.character(year)]
  if (length(catalogs) == 0) {
    stop("Selected year(s) is not available in the database.", call. = FALSE)
  }
  meta <- hydro_metadata(interval)

  all_data <- vector("list", length = length(catalogs))
  for (i in seq_along(catalogs)){
    catalog <- catalogs[i]
    #print(i)

    adres <- paste0(base_url, interval_pl, "/", catalog, "/mies_", catalog, ".zip")

    temp <- tempfile()
    temp2 <- tempfile()
    download.file(adres, temp)
    unzip(zipfile = temp, exdir = temp2)
    file1 <- paste(temp2, dir(temp2), sep = "/")[1]
    data1 <- read.csv(file1, header = FALSE, stringsAsFactors = FALSE, fileEncoding = "CP1250")
    colnames(data1) <- meta[[1]][,1]
    all_data[[i]] <- data1
  }
  all_data <- do.call(rbind, all_data)
  # wyjatki na brak stanu, przeplywu i temperatury
  # Stan wody 9999 oznacza brak danych w bazie lub przerwy w obserwacjach w danym miesiącu i stad brak możliwości obliczenia charakterystyk.
  #Przepływ 99999.999 oznacza brak danych lub przerwy w obserwacjach w danym miesiacu i stad brak możliwości obliczenia charakterystyk.
  #Temperatura wody 99.9 oznacza brak danych lub przerwy w obserwacjach w danym miesiacu i stad brak możliwości obliczenia charakterystyk.
  all_data[all_data == 9999] <- NA
  all_data[all_data == 99999.999] <- NA
  all_data[all_data == 99.9] <- NA
  colnames(all_data) <- meta[[1]][,1]
  # brak wykorzystania coords
  #station selection
  if (!is.null(station)) {
    stations=read.csv("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_hydrologiczne/lista_stacji_hydro.csv",
                      header = FALSE)
    if (is.character(station)) {
      if(dim(stations[stations$V2 %in% station, ])[1] == 0){
        stop("Selected station(s) is not available in the database.", call. = FALSE)
      }
     all_data <- all_data[all_data$`Nazwa stacji` %in% station, ]
    } else if (is.numeric(station)){
      if( dim(stations[stations$V1 %in% station, ])[1] == 0){
        stop("Selected station(s) is not available in the database.", call. = FALSE)
      }
      all_data <- all_data[all_data$`Kod stacji` %in% station, ]
    }else {
      stop("Selected station(s) are not in the proper format.", call. = FALSE)
      }
  }
  return(all_data)
}

