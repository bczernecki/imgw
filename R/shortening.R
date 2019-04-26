#' Shortening column names
#'
#' Shortening column names to improve the readability of downloaded dataset and removing duplicated column names
#'
#' @param data downloaded dataset with original column names
#' @param format three types of column names possible: "short" - default, values with shorten names, "polish" - (original names as downloaded), "full" - full English description
#' @param duplicates whether to remove duplicated column names (default TRUE - i.e., columns with duplicated names are deleted)
#' @export
#'
#' @examples \dontrun{
#'   colnames(data)
#'   abbr <- shortening(data = data, format = "short", duplicates = TRUE)
#'   head(abbr)
#' }
#'

shortening <- function(data, format = "short", duplicates = TRUE){

  abbrev <- imgw::abbrev
  orig_columns <- trimws(gsub("\\s+", " ", colnames(data))) # remove double spaces

  if (format == "short"){
    # abbrev english
    colnames(data) <- abbrev$abbr_ang[match(orig_columns, abbrev$fullname)]
  }

  if (format == "full"){
    # full english names:
    colnames(data) <- abbrev$fullname_ang[match(orig_columns, abbrev$fullname)]
  }

  #if(format == "polish"){
  # fullname polish, no changes required:
  # abbrev$fullname[match(orig_columns, abbrev$fullname)]
  #}


  # removing duplicated column names:  (e.g. station's name)
  if (duplicates == TRUE) {
    data <- data[, !duplicated(colnames(data))]
  }

  return(data)

} # end of function
