#' @name stacje_meteo
#' @title Location of weather stations
#'
#' @description The object contains weather stations
#' coordinates, ID numbers, and elevations
#'
#' @format The data contains a data.frame with 1998 obs. of 4 variables:
#' \itemize{
#'     \item{X} {Longitude}
#'     \item{Y} {Latitude}
#'     \item{Kod_stacji} {Station ID}
#'     \item{Wysokosc} {Station elevation in m asl}
#' }
#' The object is in geographic coordinates using WGS84 (EPSG:4326).
#'
#' @docType data
#' @keywords datasets meteo
#' @examples
#' data(stacje_meteo)
#' head(stacje_meteo)
"stacje_meteo"
