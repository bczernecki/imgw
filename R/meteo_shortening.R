#' Shortening column names for meteorological variables
#'
#' Shortening column names of meteorological parameters to improve the readability of downloaded dataset and removing duplicated column names
#'
#' @param data downloaded dataset with original column names
#' @param format three types of column names possible: "short" - default, values with shorten names, "polish" - (original names as downloaded), "full" - full English description
#' @param remove_duplicates whether to remove duplicated column names (default TRUE - i.e., columns with duplicated names are deleted)
#' @export
#'
#' @examples \dontrun{
#'   colnames(data)
#'   abbr <- meteo_shortening(data = data, format = "short", remove_duplicates = TRUE)
#'   head(abbr)
#' }
#'

meteo_shortening <- function(data, format = "short", remove_duplicates = TRUE){

  abbrev <- imgw::meteo_abbrev
  orig_columns <- trimws(gsub("\\s+", " ", colnames(data))) # remove double spaces

  if (format == "short"){
    # abbrev english
    colnames(data) <- abbrev$abbr_eng[match(orig_columns, abbrev$fullname)]
  }

  if (format == "full"){
    # full english names:
    colnames(data) <- abbrev$fullname_eng[match(orig_columns, abbrev$fullname)]
  }

  #if(format == "polish"){
  # fullname polish, no changes required:
  # abbrev$fullname[match(orig_columns, abbrev$fullname)]
  #}


  # removing duplicated column names:  (e.g. station's name)
  if (remove_duplicates == TRUE) {
    data <- data[, !duplicated(colnames(data))]
  }

  return(data)

} # end of function
