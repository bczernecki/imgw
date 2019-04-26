#' Shortening column names
#'
#' Shortening column names to improve the readability of downloaded dataset and removing duplicated column names
#'
#' @param data downloaded dataset with original column names
#' @param col_names three types of column names possible: "short" - default, values with shorten names, "full" - full English description, "polish" - original names in the dataset
#' @param duplicates whether to remove duplicated column names (default TRUE - i.e., columns with duplicated names are deleted)
#' @export
#'
#' @examples \dontrun{
#'   colnames(data)
#'   abbr <- shortening(data = data, colnames = "short", duplicates = TRUE)
#'   head(abbr)
#' }
#'

shortening <- function(data, col_names = "short", duplicates = TRUE){

  if (col_names != "polish"){
    abbrev <- imgw::abbrev
    orig_columns <- trimws(gsub("\\s+", " ", colnames(data))) # remove double spaces

    matches <- match(orig_columns, abbrev$fullname)
    matches <- matches[!is.na(matches)]

    if (col_names == "short"){
      # abbrev english
      colnames(data)[orig_columns %in% abbrev$fullname] <- abbrev$abbr_ang[matches]
    }

    if (col_names == "full"){
      # full english names:
      colnames(data)[orig_columns %in% abbrev$fullname] <- abbrev$fullname_ang[matches]
    }
  }

  # removing duplicated column names:  (e.g. station's name)
  if (duplicates == TRUE) {
    data <- data[, !duplicated(colnames(data))]
  }

  return(data)

} # end of function
