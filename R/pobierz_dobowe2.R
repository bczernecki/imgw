#' Funkcja pobierająca dane miesięczne ale tylko dla wskazanego folderu/roku
#'
#' Funkcja pobiera wszystkie dostępne dane miesięczne ze stacji SYNOP dostępne w zbiorze danepubliczne.imgw.pl
#' Domyślnie dane zapisywane są w aktualnie wskazanym katalogu roboczym.
#' Po pobraniu danych nalezy jest nastepnie rozpakowac i wczytac za pomoca funkcji 'wczytaj_dobowe()'
#' 
#' 
#'  
#' @import RCurl rvest dplyr
#' @importFrom data.table rbindlist
#' @importFrom utils download.file
#'  
#' @export
#' @examples
#' pobierz_dobowe2(rok=2005) # download all files into current working directory
#' # next steps should involve (1) unpacking and (2) reading into R environment:
#' a <- (dir(pattern=".zip")) # tu mam 1500 plikow zip, z ktorych kazdy zawiera ~2-3 pliki w srodku
#' b <- as.list(a)    # robie z tego liste
# 'lapply(b, FUN = function(x) unzip(zipfile = x)) # i wszystko rozpakowywuje
# dane <- wczytaj() # lub wczytaj_miesieczne jesli samo wczytaj() nie dziala


#' lapply(c("1996_2000",2001:2005), pobierz_dobowe2) # wskazujemy katalogi do pobrania
#' # uwaga! moze troche mulic przy duzej liczbie lat!


################################
################################
# to jest fragment dla dobowek, ktore sa znacznie bardziej skomplikowane :/

pobierz_dobowe2 <- function(rok="1996_2000"){
  okres <- "dobowe"
  meta <- metadane(okres="dobowe") # musi zostac pobrane jako lista dwuelementowa ...
  a <- getURL(paste0("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/",okres,"/synop/"),ftp.use.epsv = FALSE,dirlistonly = TRUE)
  ind <- readHTMLTable(a)[[1]]$Name %>% grep(pattern="/")
  katalogi <- readHTMLTable(a)[[1]]$Name[ind] %>% as.character()
  
  rok <- paste0(rok,"/")
  
  calosc <- NULL
  
  i <- match(rok, katalogi) # testujemy, czy katalog istnieje i jesli tak to ktory to jest
  
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