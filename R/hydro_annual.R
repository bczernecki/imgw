#' Semi-annual and annual hydrological data
#'
#' Downloading hydrological data for the semi-annual and annual period
#' available in the collection danepubliczne.imgw.pl
#'
#' @param year vector of years (e.g. 1966:2000)
#' @param coords add coordinates for the station (logical value TRUE or FALSE)
#' @param value type of data ( can be: "State=H (default)" , "Flow=Q" , "Temperature=T")
#' @importFrom RCurl getURL
#' @importFrom XML readHTMLTable
#' @importFrom utils download.file unzip read.csv
#' @return
#' @export
#'
#' @examples \dontrun{
#'   yearly <- hydro_annual(year = 2000, value="H")
#'   head(yearly)
#' }
#'
hydro_annual <-  function(year = 1966:2000, coords = FALSE, value = "H"){
  base_url <- "https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_hydrologiczne/"
  interval <- "polroczne_i_roczne"
  a <- getURL(paste0(base_url, interval, "/"),
              ftp.use.epsv = FALSE,
              dirlistonly = TRUE)

  ind <- grep(readHTMLTable(a)[[1]]$Name, pattern = "/")
  catalogs <- as.character(readHTMLTable(a)[[1]]$Name[ind])
  catalogs <- gsub(x = catalogs, pattern = "/", replacement = "")
  # mniej plików do wczytywania
  catalogs <- catalogs[catalogs %in% as.character(year)]
  meta <- hydro_metadata(interval)

  all_data <- vector("list", length = length(catalogs))
  for (i in seq_along(catalogs)){
    catalog <- catalogs[i]
    #print(i)

    address <- paste0(base_url, interval, "/", catalog, "/polr_", value, "_", catalog, ".zip")

    temp <- tempfile()
    temp2 <- tempfile()
    download.file(address, temp)
    unzip(zipfile = temp, exdir = temp2)
    file1 <- paste(temp2, dir(temp2), sep = "/")[1]
    data1 <- read.csv(file1, header = FALSE, stringsAsFactors = FALSE, fileEncoding = "CP1250")
    colnames(data1) <- meta[,value]
    all_data[[i]] <- data1
  }
  all_data <- do.call(rbind, all_data)
  # ten sam warunek braku danych lub obserwacji dla wszytkich wartosci
  all_data[all_data == 99999.999] <- NA
  # brak wykorzystania coords
  return(all_data)
}
