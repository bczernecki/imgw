#' Sounding data downloader
#'
#' Downloading the mea (i.e. measurements of the vertical profile of atmosphere) sounding data; Source: http://weather.uwyo.edu/upperair/sounding.html
#'
#' @param wmo_id International WMO station code (World Meteorological Organization ID); For Polish stations: Łeba - 12120, Legionowo - 12374, Wrocław- 12425 (default value = 12150)
#' @param yy year - single number (default = 2019)
#' @param mm month - single number denoting month (default = 1, i.e. January)
#' @param dd day - single number denoting day (default = 1)
#' @param hh hour - single number denoting initial hour of sounding; for most stations this measurement is done twice a day (i.e. at 12 and 00 UTC), sporadically 4 times a day; default value = 12
#' @param sounding_indices - logical (default = FALSE); whether to download an extra information about sounding instability indices and metadata? default = FALSE ; if set to TRUE returns list instead of data.frame
#' @importFrom utils download.file read.fwf
#' @return Returns data.frame or list with values described at: weather.uwyo.edu ; For data frame the values in columns stands for:
#' \enumerate{
#'  \item PRES - Pressure (hPa)
#'  \item HGHT - Height (metres)
#'  \item TEMP - Temperature (C)
#'  \item DWPT - Dew point (C)
#'  \item RELH - Relative humidity (%)
#'  \item MIXR - Mixing ratio (g/kg)
#'  \item DRCT - Wind direction (deg)
#'  \item SKNT - Wind speed (knots)
#'  \item THTA = (K)
#'  \item THTE = (K)
#'  \item THTV = (K)
#'  }
#' @export
#'
#' @examples \dontrun{
#'   sounding <- meteo_sounding()
#'   head(sounding)
#' }
#'

meteo_sounding <- function(wmo_id, yy = 2019, mm = 1, dd = 1, hh = 0, sounding_indices = FALSE){

  mm <- formatC(mm, width = 2, format = "d", flag = "0")
  dd <- formatC(dd, width = 2, format = "d", flag = "0")
  hh <- formatC(hh, width = 2, format = "d", flag = "0")

  url <- paste0("http://weather.uwyo.edu/cgi-bin/sounding?region=europe&TYPE=TEXT%3ALIST&YEAR=",
                yy, "&MONTH=", mm, "&FROM=", dd, hh, "&TO=", dd, hh, "&STNM=", wmo_id)

  temp <- tempfile()
  download.file(url, temp)

  txt <- read.fwf(file = temp, widths = 1000)
  sects <- grep(pattern = "PRE>", x = txt$V1)
  df <- read.fwf(file = temp, skip = sects[1] + 4, widths = rep(7, 11),
                 n = (sects[2] - (sects[1] + 5)))
  colnames(df) <- c("PRES", "HGHT", "TEMP", "DWPT", "RELH",
                    "MIXR", "DRCT", "SKNT", "THTA", "THTE", "THTV")

  if(sounding_indices == TRUE){
    txt <- read.fwf(file = temp, skip = sects[2] + 1, widths = 1000,
                    n = (sects[3] - (sects[2] + 2)), stringsAsFactors = FALSE)$V1
    df2 <- as.data.frame(matrix(data = unlist(strsplit(txt, split = ": ")), ncol = 2, byrow = TRUE))
    colnames(df2) <- c("parameter"," value")
    df <- list(df, df2)
  }

  unlink(temp)
}

# ONLY FOR TESTING PURPOSES:
# a <- meteo_sounding(wmo_id = 12374, yy = 2018, mm = 8, dd = 24, hh = 12)
# plot(y=a$HGHT, a$TEMP, type='l', xlim=c(-60,15))
# library(sounding)
# data("holdxy")
# data("holdxx")
# data("pp")
#
# a <- na.omit(a)
# x <- data.frame(lev=a$PRES,
#                 HGT=a$HGHT,
#                 TMP=a$TEMP,
#                 DPT = a$DWPT,
#                 WD = a$DRCT,
#                 WS = a$SKNT,
#                 lon=52,
#                 lat=19,
#                 date2=Sys.time())
# plotuj(x, wczytane_holdxy=FALSE, zaznacz_cape = T)
# sounding(pressure = a$PRES, altitude = a$HGHT, temp = a$TEMP, dpt = a$DWPT, wd = a$DRCT, ws = a$SKNT*2)
