#' Semiannual and annual hydrological data
#'
#' Downloading hydrological data for the annual period
# 'available in the collection danepubliczne.imgw.pl
#'
#' @param year vector of years (e.g. 1966:2000)
#' @param coords geographical coordinates if TRUE (WGS84)(defaults coords = FALSE)
#' @param value type of data ( "State=H (default)" , "Flow=Q" , "Temperature=T")
#' @importFrom RCurl getURL
#' @importFrom XML readHTMLTable
#' @importFrom utils download.file unzip read.csv
#' @return
#' @export
#'
#' @examples \dontrun{
#'   yearly <- hydro_yearly(year = 2000,value="H")
#'   head(mies)
#' }
#'
# do wyboru jeden z 3 value nie zadziała dla pobrania wszystkiego na raz przytanie czy potrzeba?
# nie używam coords czy jest taka baza jak ("stacje_meteo")?

hydro_yearly <-  function(year = 1966:2000, coords = FALSE, value = "H"){
  base_url <- "https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_hydrologiczne/"
  interval <- "polroczne_i_roczne"
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
    #print(i)

    adres <- paste0(base_url, interval, "/", catalog, "/polr_", value, "_", catalog, ".zip")

    temp <- tempfile()
    temp2 <- tempfile()
    download.file(adres, temp)
    unzip(zipfile = temp, exdir = temp2)
    file1 <- paste(temp2, dir(temp2), sep = "/")[1]
    data1 <- read.csv(file1, header = FALSE, stringsAsFactors = FALSE, fileEncoding = "CP1250")
    colnames(data1) <- meta[,value]
    all_data[[i]] <- data1
  }
  all_data <- do.call(rbind, all_data)
  # ten sam warunek braku danych lub obserwacji dla wszytkich wartosci
  all_data[all_data==99999.999] <- NA
  # brak wykorzystania coords
  return(all_data)
}
