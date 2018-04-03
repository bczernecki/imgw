#' Funkcja pobierająca dane miesięczne
#'
#' Funkcja pobiera wszystkie dostępne dane miesięczne ze stacji SYNOP dostępne w zbiorze danepubliczne.imgw.pl
#' Domyślnie dane zapisywane są w aktualnie wskazanym katalogu roboczym.
#' Po pobraniu danych nalezy jest nastepnie rozpakowac i wczytac za pomoca funkcji 'wczytaj_dobowe()'
#' 
#' 
#'  
#' @import RCurl rvest dplyr
#' @importFrom data.table rbindlist
#' @export
#' @examples
#' pobierz_dobowe() # download all files into current working directory
#' # next steps should involve (1) unpacking and (2) reading into R environment:
#' # wczytaj_dobowe()


################################
################################
# to jest fragment dla dobowek, ktore sa znacznie bardziej skomplikowane :/

pobierz_dobowe <- function(){
  okres <- "dobowe"
  meta <- metadane(okres="dobowe") # musi zostac pobrane jako lista dwuelementowa ...
  a <- getURL(paste0("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/",okres,"/synop/"),ftp.use.epsv = FALSE,dirlistonly = TRUE)
  ind <- readHTMLTable(a)[[1]]$Name %>% grep(pattern="/")
  katalogi <- readHTMLTable(a)[[1]]$Name[ind] %>% as.character()
  calosc <- NULL
    # ponizszy fragment dla dobowych
    # zaklada, ze najlepiej je najpierw pobrac...
      for (i in 1:length(katalogi)){
        print(i)
        katalog <- gsub(katalogi[i], pattern="/", replacement = "")
        a <- getURL(paste0("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/",okres,"/synop/",katalog,"/"),ftp.use.epsv = FALSE,dirlistonly = FALSE)
        ind <- grep(readHTMLTable(a)[[1]]$Name,pattern = "zip")
        pliki <- readHTMLTable(a)[[1]]$Name[ind] %>% as.character()
  
          for(j in 1:length(pliki)){
            adres <- paste0("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/",okres,"/synop/",katalog,"/",pliki[j])
            #temp <- tempfile()
            #temp2 <- paste0(katalogi,pliki)
            download.file(adres, pliki[j])
          }
      }
}