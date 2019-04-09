#' Sounding data downloader
#'
#' Pobranie danych z pionowych sondowań atmosfery; Dane oryginalnie dostępne w serwisie: http://weather.uwyo.edu/upperair/sounding.html
#'
#' @param wmo_id międzynarodowy kod stacji wg WMO (World Meteorological Organization); Dla polskich stacji: Łeba - 12330, Legionowo - 12374, Wrocław- 12425
#' @param yy rok
#' @param mm czy usunac kolumny ze statusami pomiarow lub obserwacji (domyslnie status = FALSE - tj. kolumny ze statusami sa usuwane)
#' @param dd czy dodac wspolrzedne (WGS84) i wysokosc stacji? (domyslnie coords = FALSE)
#' @param hh na większość stacji do wyboru godziny 00 i 12; sporadczynie pomiary wykonywane co 6h
#' @param sounding_indices pobieranie dodatkowych informacji o wyliczonych indeksach oraz metadanych sondowania
#' @importFrom RCurl getURL
#' @importFrom XML readHTMLTable
#' @importFrom utils download.file unzip read.csv
#' @return
#' @export
#'
#' @examples \dontrun{
#'   sounding <- meteo_sounding()
#'   head(sounding)
#' }
#'

meteo_sounding <- function(wmo_id = 12120, yy = 2019, mm = 4, dd = 9, hh = 0, sounding_indices = FALSE){

  # TODO:
  # sounding

  mm <- formatC(mm, width = 2, format = "d", flag = "0")
  dd <- formatC(dd, width = 2, format = "d", flag = "0")
  hh <- formatC(hh, width = 2, format = "d", flag = "0")

  url <- paste0("http://weather.uwyo.edu/cgi-bin/sounding?region=europe&TYPE=TEXT%3ALIST&YEAR=",yy,"&MONTH=",
                mm, "&FROM=", dd, hh, "&TO=", dd, hh, "&STNM=", wmo_id)

  url


}

meteo_sounding()
