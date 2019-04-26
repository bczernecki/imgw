#' Shortening column names
#'
#' Shortening column names to improve readability of downloaded dataset and removing duplicated column names
#'
#' @param data downloaded dataset with original column names
#' @param duplicates whether to remove duplicated column names (default TRUE - i.e. columns with duplicated names are deleted)
#' @param format three types of column names possible: "short" - default, values with shorten names, "polish" - (original names as downloaded), "full" - full English description
#' @export
#'
#' @examples \dontrun{
#'   abbrev <- abbre(rank = "climate", year = 1969)
#'   head(monthly)
#' }
#'

abbrev <- function(data, duplicates = TRUE, format = "short"){

  abbrev = imgw::abbrev
  orig_columns <- trimws(gsub("\\s+", " ", colnames(data))) # remove double spaces

  if(format == "short"){
    # abbrev english
    colnames(data) <- abbrev$abbr_ang[match(orig_columns, abbrev$fullname)]
  }

  if(format == "full"){
    # full english names:
    colnames(data) <- abbrev$fullname_ang[match(orig_columns, abbrev$fullname)]
  }

  #if(format == "polish"){
    # fullname polish, no changes required:
    # abbrev$fullname[match(orig_columns, abbrev$fullname)]
  #}


  # removing duplicated column names:  (e.g. station's name)
  if(duplicates == TRUE){
  data <- data[,!duplicated(colnames(data))]
  }

  return(data)

} # end of function
