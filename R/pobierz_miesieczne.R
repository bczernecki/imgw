#' Funkcja pobierająca dane miesięczne
#'
#' Funkcja pobierająca wszystkie dostępne dane miesięczne ze stacji SYNOP dostępne w zbiorze danepubliczne.imgw.pl
#' @import RCurl rvest XML
#' @importFrom utils download.file unzip read.csv
#' @export
#' @examples
#' miesieczne <- pobierz_miesieczne
#' head(miesieczne)


# source("R/clean_metadata.R")
# source("R/metadane.R")
# 

################################
################################
# to jest fragment dla miesiecznych:

pobierz_miesieczne <- function(){
okres <- "miesieczne"
meta <- metadane(okres="miesieczne")[[1]]

a <- getURL(paste0("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/",okres,"/synop/"),ftp.use.epsv = FALSE,dirlistonly = TRUE)
ind <- readHTMLTable(a)[[1]]$Name %>% grep(pattern="/")
katalogi <- readHTMLTable(a)[[1]]$Name[ind] %>% as.character()
calosc <- NULL

  for (i in 1:length(katalogi)){
    print(i)
    katalog <- gsub(katalogi[i], pattern="/", replacement = "")
    adres <- paste0("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/miesieczne/synop/",katalog,"/",katalog,"_m_s.zip")
    temp <- tempfile()
    temp2 <- tempfile()
    download.file(adres, temp)
    unzip(zipfile = temp, exdir = temp2)
    plik <- paste(temp2,dir(temp2),sep="/")[1]
    data <- read.csv(plik, header=F, stringsAsFactors = F, fileEncoding = "CP1250") 
    colnames(data) <- meta$V1
    unlink(c(temp, temp2))
    calosc <- rbind.data.frame(calosc, data)
  }
  return(calosc)
}

###################################
###################################


