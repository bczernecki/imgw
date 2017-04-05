#' Pobieranie danych meteorologicznych z serwisu IMGW-PIB (https://dane.imgw.pl)
#'
#' Funkcja pozwalająca na zautomatyzowanie procesu pobierania danych meteorologicznych i hydrologicznych z oficjalnego repozytorium Instytutu Meteorologii i Gospodarki Wodnej - Państwowego Instytutu Badawczego - https://dane.imgw.pl
#' @param user_pass  Login i token wygenerowany przez serwis https://dane.imgw.pl. Parametr w postaci email:token, np. bczernecki@gmail.com:68a60055
#' @param data_start Data początkowa od której będą pobierane dane. Obiekt klasy Date
#' @param data_end Data końcowa do której będą pobierane. Obiekt klasy Date. Domyślnie funkcja rozszerza zakres pobierania danych o tydzień w przód i w tył
#' @param stacja Kod stacji wg strony https://dane.imgw.pl
#' @param kod Kod pobieranego elementu meteorologicznego/hydrologicznego

#' @importFrom RCurl getURL
#'
#' @export
#' @examples
#' # wymagane ustalenie ponizszych parametrow pobierania:
#' 
#' user_pass <- "" # pamietaj o wpisaniu swojego loginu:tokena wg schematu zawartego w opisie!
#' data_start <- "2016-12-26" 
#' data_end <- "2017-02-20" 
#' stacja <- "352160330" # przykladowe id dla Poznania; numer mozna pobrac ze strony https://dane.imgw.pl
#' kod <- "B100B008CD" # srednia dobowa temp. powietrza synop; j.w.
#' pobierz(data_start,data_end,user_pass,stacja,kod)


pobierz <- function(data_start,data_end,user_pass,stacja,kod){
  
    if(nchar(user_pass)<=0) print("sprawdz argument: user_pass")
    stopifnot(nchar(user_pass)>0)
  

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
