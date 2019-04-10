#' Daily hydrological data
#'
#' Downloading hydrological data for the dobowe period
#' available in the collection danepubliczne.imgw.pl
#'
#' @param year vector of years (e.g. 1966:2000)
#' @param coords add coordinates for the station (logical value TRUE or FALSE)
#' @importFrom RCurl getURL
#' @importFrom XML readHTMLTable
#' @importFrom utils download.file unzip read.csv
#' @return
#' @export
#'
#' @examples \dontrun{
#'   daily <- hydro_daily(year = 2000)
#'   head(mies)
#' }
#'
# Stan wody 9999 oznacza brak danych w bazie lub przerwy w obserwacjach w danym miesiącu i stad brak możliwości obliczenia charakterystyk.
#Przepływ 99999.999 oznacza brak danych lub przerwy w obserwacjach w danym miesiacu i stad brak możliwości obliczenia charakterystyk.
#Temperatura wody 99.9 oznacza brak danych lub przerwy w obserwacjach w danym miesiacu i stad brak możliwości obliczenia charakterystyk.
#Grubość lodu
#0   oznacza brak pomiaru grubości lodu ze względu na brak zjawisk lodowych
#999 oznacza brak pomiaru grubości lodu przy występowaniu zjawisk lodowych lub (w miesišcach letnich)
#występowanie zarastania przy braku zjawisk lodowych (tzn. jeżli kod pole zjawiska lodowego jest puste)

hydro_daily <- function(year = 1966:2000, coords = FALSE){
  base_url <- "https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_hydrologiczne/"
  interval <- "dobowe"
  a <- getURL(paste0(base_url, interval, "/"),
              ftp.use.epsv = FALSE,
              dirlistonly = TRUE)

  ind <- grep(readHTMLTable(a)[[1]]$Name, pattern = "/")
  catalogs <- as.character(readHTMLTable(a)[[1]]$Name[ind])
  catalogs <- gsub(x = catalogs, pattern = "/", replacement = "")
  catalogs <- catalogs[catalogs %in% as.character(year)]
  meta <- hydro_metadane(interval)

  all_data <- vector("list", length = length(catalogs))
  for (i in seq_along(catalogs)){
    catalog <- catalogs[i]
    print(i)

    iterator <- c("01", "02", "03", "04", "05", "06",
                "07", "08", "09", "10", "11", "12")
    for (j in seq_along(iterator)) {
      address <- paste0(base_url, interval, "/", catalog, "/codz_", catalog,"_", iterator[j], ".zip")
      temp <- tempfile()
      temp2 <- tempfile()
      download.file(address, temp)
      unzip(zipfile = temp, exdir = temp2)
      file1 <- paste(temp2, dir(temp2), sep = "/")[1]
      data1 <- read.csv(file1, header = FALSE, stringsAsFactors = FALSE, fileEncoding = "CP1250")
      colnames(data1) <- meta[[1]]
    }
    address <- paste0(base_url, interval, "/", catalog, "/zjaw_", catalog,".zip")

    temp <- tempfile()
    temp2 <- tempfile()
    download.file(address, temp)
    unzip(zipfile = temp, exdir = temp2)
    file2 <- paste(temp2, dir(temp2), sep = "/")[1]
    data2 <- read.csv(file2, header = FALSE, stringsAsFactors = FALSE, fileEncoding = "CP1250")
    colnames(data2) <- meta[[2]]

    all_data[[i]] <- merge(data1, data2,
                         by = c("Kod stacji", "Nazwa stacji",
                               "Rok hydrologiczny", "Nazwa rzeki/jeziora",
                               "Wskaźnik miesiąca w roku hydrologicznym", "Dzień"),
                         all.x = TRUE)
  }

  all_data <- do.call(rbind, all_data)
  all_data[all_data==9999] <- NA
  all_data[all_data==99999.999] <- NA
  all_data[all_data==99.9] <- NA
  #zjawiska lodowe nie uwzględniam 0 przy braku zjawisk lodowych bo to znaczy ze było poprostu 0
  all_data[all_data==999] <- NA
  # brak wykorzystania coords
  return(all_data)
}
