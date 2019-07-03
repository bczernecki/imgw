#' Hourly meteorological data form ogimet
#'
#' Downloading houly (meteorological) data from the stations available in the https://www.ogimet.com/ collection
#'
#' @param date start and finish of date (e.g., date=c("2018-05-01","2018-07-01") )
#' @param coords add coordinates of the station (logical value TRUE or FALSE)
#' @param station ID of meteorological station(s).
#' It accepts stations' IDs (numeric)
#' @param col_names three types of column names possible: "short" - default, values with shorten names, "full" - full English description, "polish" - original names in the dataset
#' @param ... other parameters that may be passed to the 'shortening' function that shortens column names
#' @importFrom RCurl getURL
#' @importFrom XML readHTMLTable
#' @export
#'
#' @examples \donttest{
#'   daily_ogi <- ogimet_hours()
#'   head(daily_ogi)
#' }
#'

ogimet_hours <- function(date=c("2018-05-01","2018-07-01"),  coords = FALSE, station = c(12326,12195), col_names = "short", ...){

  options(RCurlOptions = list(ssl.verifypeer = FALSE)) # required on windows for RCurl

  dates = seq.Date(as.Date(date[1]), as.Date(date[2]), by="1 month") - 1
  data_station=NULL
  for (station_nr in station){
    print(station_nr)
    for (i in length(dates):1) {
      year=as.integer(substr(dates[i], 1, 4))
      month=as.integer(substr(dates[i], 6, 7))
      day=as.integer(substr(dates[i], 9, 10))
      ndays=day
      linkpl2=paste("https://www.ogimet.com/cgi-bin/gsynres?ind=",station_nr,"&lang=en&decoded=yes&ndays=",ndays,"&ano=",year,"&mes=",month,"&day=",day,"&hora=23",sep="")
      if(month==1) linkpl2=paste("http://ogimet.com/cgi-bin/gsynres?ind=",station_nr,"&lang=en&decoded=yes&ndays=31&ano=",year,"&mes=02&day=1&hora=00",sep="")

      a = getURL(linkpl2)
      a = readHTMLTable(a, stringsAsFactors=FALSE)
      b = a[[length(a)]]
      colnames(b)=as.character(lapply(b[1,], as.character), stringsAsFactors=FALSE)

      dd=b[-1,]
      colnames(dd) = c(colnames(dd)[1], "hour", colnames(dd)[2:(length(dd)-1)])

      if(length(data_station)>0)    data_station = smartbind(data_station,dd, fill=NA)
      if(is.null(data_station))  data_station = dd

      cat(paste(year,month,"\n"))
    } # koniec petli daty

    data_station = data_station[!duplicated(data_station), ]
    data_station["station_ID"] = station_nr

  }# koniec petli stacje

  # coords
  #if (coords){
  #  all_data <- merge(imgw::hydro_stations, all_data, by.x = "id", by.y = "Kod stacji", all.y = TRUE)
  #}
  #data <- meteo_shortening(data_station, col_names = col_names, ...)
  data_station$Date = as.Date(data_station$Date, "%m/%d/%Y")
  # nie wiem jaki jest maksymalny rozmiar zmiennych  dlatego nie wiem ile kolumn należy zamienić z char na numeric
  #data_station[,c(3,4,6,8,9,10,13)] <- lapply(data_station[,c(3,4,6,8,9,10,13)], as.numeric)
  return(data_station)

} # koniec funkcji ogimet_hours

