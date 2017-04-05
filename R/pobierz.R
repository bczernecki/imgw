#' Funkcja pobierająca dane z serwisu dane.imgw.pl
#'
#' Pozwala na zautomatyzowanie procesu pobierania danych meteorologicznych i hydrologicznych z oficjalnego repozytorium Instytutu Meteorologii i Gospodarki Wodnej - Państwowego Instytutu Badawczego (https://dane.imgw.pl)
#' @param data_start data poczatkowa od ktorej beda pobierane dane. Obiekt klasy Date
#' @param data_end data końcowa do ktorej beda pobierane. Obiekt klasy Date. Domyslnie funkcja rozszerzy okres pobierania o tydzien w przod i w tyl
#' @param user_pass  login i token ze strony https://dane.imgw.pl. Zmienna w postaci email:token, np. bczernecki@gmail.com:68a60056
#' @param stacja kod stacji wg strony https://dane.imgw.pl
#' @param kod kod pobieranego elementu meteorologicznego/hydrologicznego

#' @importFrom RCurl getURL
#'
#' @export
#' @examples
#' # wymagane ustalenie ponizszych parametrow pobierania:
#' 
#' data_start <- "2016-12-26" 
#' data_end <- "2017-02-20" 
#' user_pass <- "" 
#' stacja <- "352160330" # przykladowe id dla Poznania; numer mozna pobrac ze strony https://dane.imgw.pl
#' kod <- "B100B008CD" # srednia dobowa temp. powietrza synop; j.w.
#' pobierz(data_start,data_end,user_pass,stacja,kod)


pobierz <- function(data_start,data_end,user_pass,stacja,kod){
  
    if(length(user_pass)<5) print("sprawdz argument: user_pass")
    stopifnot(length(user_pass)>5)
  

  daty <- seq.Date(from=as.Date(data_start)-7, to=as.Date(data_end)+7, by="7 days")

  i <- 1
  wynik <- NULL
  
    while(i<=length(daty)){
  
      a <-gsub(
        getURL(
        paste0("https://dane.imgw.pl/1.0/pomiary/cbdh/",
           stacja,"-",kod,"/tydzien/",daty[i],"?format=csv"),
        userpwd = user_pass),
        pattern = "\\r",replacement = "")
  
      a <- read.csv(textConnection(a), sep=";", 
                colClasses = c("POSIXct","numeric","numeric"))
  
    wynik <- rbind.data.frame(wynik, a)
    
    cat(paste0(daty[i],"\t" ,round((i/length(daty))*100,2),"%\n"))
    i <- i+1

}


return(wynik)

}
