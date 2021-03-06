#' Shortening column names for meteorological variables
#'
#' Shortening column names of meteorological parameters to improve the readability of downloaded dataset and removing duplicated column names
#'
#' @param data downloaded dataset with original column names
#' @param col_names three types of column names possible: "short" - default, values with shorten names, "full" - full English description, "polish" - original names in the dataset
#' @param remove_duplicates whether to remove duplicated column names (default TRUE - i.e., columns with duplicated names are deleted)
#' @export
#'
#' @examples \donttest{
#'   monthly <- meteo_monthly(rank = "climate", year = 1969)
#'   colnames(monthly)
#'   abbr <- meteo_shortening(data = monthly, col_names = "short", remove_duplicates = TRUE)
#'   head(abbr)
#' }
#'

meteo_shortening <- function(data, col_names = "short", remove_duplicates = TRUE){

  if (col_names != "polish"){
    abbrev <- imgw::meteo_abbrev
    orig_columns <- trimws(gsub("\\s+", " ", colnames(data))) # remove double spaces

    matches <- match(orig_columns, abbrev$fullname)
    matches <- matches[!is.na(matches)]

    if (col_names == "short"){
      # abbrev english
      colnames(data)[orig_columns %in% abbrev$fullname] <- abbrev$abbr_eng[matches]
    }

    if (col_names == "full"){
      # full english names:
      colnames(data)[orig_columns %in% abbrev$fullname] <- abbrev$fullname_eng[matches]
    }
  }

  # removing duplicated column names:  (e.g. station's name)
  if (remove_duplicates == TRUE) {
    data <- data[, !duplicated(colnames(data))]
  }

  return(data)

} # end of function
