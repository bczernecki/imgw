#' Funkcja wczytujaca pobrane dane 
#'
#' Funkcja wczytuje wszystkie (uprzednio pobrane) pliki z rozszerzeniem '.zip' w katalogu roboczym (lub wskazanym).
#' Komenda rozpakowywuje wszystkie pliki .zip, w ktorych domyslnie znajduja sie pliki .csv (s_d_t... oraz s_d...),
#' wczytuje je do oddzielnych list bedacych wynikiem dzialania funkcji
#' 
#' Uwaga! Inne pliki z rozszerzeniem .zip w katalogu roboczym rowniez zostana rozpakowane!
#' Uwaga2! W przypadku duzej liczby plikow caly proces moze byc czaso- i obliczeniochlonny!
#' 
#' @param katalog Wskazany katalog z plikami .zip
#'  
#' @import dplyr
#' @importFrom data.table rbindlist
#' @importFrom utils download.file unzip
#' 
#' @export
#' @examples
#' a <- (dir(pattern=".zip")) # tu mam 1500 plikow zip, z ktorych kazdy zawiera ~2-3 pliki w srodku
#' b <- as.list(a)    # robie z tego liste
#' lapply(b, FUN = function(x) unzip(zipfile = x)) # i wszystko rozpakowywuje
#' # next steps should involve (1) unpacking and (2) reading into R environment:
#' 
#' dane <- wczytaj_miesieczne(katalog = "/home/bartosz/github/imgw/inst/extdata/dobowe/")




#swiec rysiek to:
wczytaj_miesieczne <- function(katalog){
    
  # sprawdzenie ustawien dla biezacego katalogu:
      if(missing(katalog)){
        message("brak argumentu wskazujacego na katalog. Pozostawiam biezacy:")
        print(getwd())
      } else {
        setwd(katalog)
      }


  # rozpoczecie wczytywania plikow i rozpakowywania
  message("")
  message("rozpoczecie wczytywania plikow i rozpakowywania...")
    a <- (dir(pattern=".zip")) # tu mam 1500 plikow zip, z ktorych kazdy zawiera ~2-3 pliki w srodku
    b <- as.list(a)    # tworzymy liste
    lapply(b, FUN = function(x) unzip(zipfile = x)) # i wszystko rozpakowywuje
    
    # teraz zaczytaj wszystkie pobrane csv-ki z patternem 's_d' na poczatku
    pliki <- dir(pattern="^s_d") %>%   .[ ! grepl("_t_", .) ] # usuwamy w ten sposob pattern s_d_t_
    calosc <- lapply(as.list(pliki), FUN=function(x) read.csv(x, header=F, stringsAsFactors = F, fileEncoding = "CP1250"))
    s_d <- rbindlist(calosc)
    
    # i to samo dla plikow z rozszerzeniem s_d_t:
    pliki <- dir(pattern="^s_d_t") # zostawiamy w ten sposob pattern s_d_t_
    calosc <- lapply(as.list(pliki), FUN=function(x) read.csv(x, header=F, stringsAsFactors = F, fileEncoding = "CP1250"))
    s_d_t <- rbindlist(calosc)
    
    meta <- metadane(okres="dobowe") # pobranie metadanych
    colnames(s_d) <- meta[[1]]$V1
    colnames(s_d_t) <- meta[[2]]$V1    
    calosc <- list(sd=s_d, sdt=s_d_t)
    return(calosc)
}

wczytaj <- wczytaj_miesieczne

# calosc <- wczytaj_miesieczne(katalog = "/home/bartosz/github/imgw/inst/extdata/dobowe/")
# saveRDS(calosc, file = "~/Dropbox/matas_part1.rds")

#library(dplyr)
# poznan <- dplyr::filter(calosc, `Nazwa stacji`=="POZNAŃ") %>% dplyr::select(., matches("Kod"):Miesiąc, matches("Średnia temperatura miesięczna")) 
# library(reshape)
# poznan <- poznan[,-1:-2]
# colnames(poznan) <- c("rok","miesiac","temp")
# head(poznan)
# 
# library(tidyr)
# poznan <- spread(poznan, key="miesiac", value="temp")
# poznan <- data.frame(poznan,srednia=round(rowMeans(poznan[,-1]),1))
# colnames(poznan)[2:13] <- month.abb
# head(poznan)
# colMeans(poznan, na.rm = T) %>% round(.,1)
# 
# poznan$rok <- as.factor(poznan$rok)
# 
# poznan2 <- poznan %>% melt() 
# poznan2 <- poznan2%>% filter(variable=="Jan" | variable=="Jul" | variable =="Apr" | variable=="Sep")
# 
# library(ggplot2)
# library(ggthemes)
# ggplot(data=poznan2, aes(value))+
#   geom_histogram(bins = 8,show.legend = T,na.rm = T,col="white", fill="lightblue")+
#   xlab("temperatura powietrza")+
#   facet_wrap(~variable,scales = "free")

