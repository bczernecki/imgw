#' Pobieranie danych meteorologicznych z serwisu IMGW-PIB (https://dane.imgw.pl)
#'
#' Funkcja pozwalająca na zautomatyzowanie procesu pobierania danych meteorologicznych i hydrologicznych z oficjalnego repozytorium Instytutu Meteorologii i Gospodarki Wodnej - Państwowego Instytutu Badawczego - https://dane.imgw.pl.
#' Z uwagi na ograniczenia związane z liczbą tworzonych zapytań (ok. 10 tys. na 10 min.) funkcja może wymuszać krótkie przerwy w pobieraniu w celu odświeżenia limitów.
#' 
#' @param user_pass  Login i token wygenerowany przez serwis https://dane.imgw.pl. Parametr w postaci email:token, np. bczernecki@gmail.com:68a60055
#' @param data_start Data początkowa od której będą pobierane dane. Obiekt klasy Date
#' @param data_end Data końcowa do której będą pobierane. Obiekt klasy Date. Domyślnie funkcja rozszerza zakres pobierania danych o tydzień w przód i w tył
#' @param stacja Kod stacji wg strony https://dane.imgw.pl
#' @param kod Kod pobieranego elementu meteorologicznego/hydrologicznego
#' @param podglad Wyświetla szczegółowe informacje cząstkowe (link oraz pierwsze kilkanaście znaków) w trakcie pobierania (TRUE/FALSE). Domyślnie FALSE 

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


pobierz <- function(data_start,data_end,user_pass,stacja,kod, podglad=FALSE){
  library(RCurl)
  options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))) 
  
    if(nchar(user_pass)<=0) print("sprawdz argument: user_pass")
    stopifnot(nchar(user_pass)>0)
  

  daty <- seq.Date(from=as.Date(data_start)-7, to=as.Date(data_end)+7, by="7 days")

  i <- 1
  wynik <- NULL
  
    while(i<=length(daty)){
      
      link <- paste0("https://dane.imgw.pl/1.0/pomiary/cbdh/",
                    stacja,"-",kod,"/tydzien/",daty[i],"?format=csv")
      
      a <- tryCatch(getURL(link,userpwd = user_pass, cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")), error=function(e) 0)
      a <-gsub(a,  pattern = "\\r",replacement = "")
      
      if(any(grepl("429,",a))) {
        cat(paste("Przekroczono limit pobierania. Czekam 5 min. przed ponowną próbą\n"))
        cat(paste(link))
        cat("Komunikat ze strony:\t",paste(a))
        Sys.sleep(300)
        a <- tryCatch(getURL(link,userpwd = user_pass, cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")), error=function(e) 0)
        a <-gsub(a,  pattern = "\\r",replacement = "")
      }
      
      if(any(grepl("Unauthorized", a))) {
        cat(paste("Wystąpił problem z autoryzacją. Sprawdź nazwę użytkownika i hasło oraz sprawdź czy link:\n", link[1] , " działa poprawnie w przeglądarce"))
        stop()
        }  
          
        if(podglad==TRUE){
        print(link)
        print(substr(a,1 , 60))
        }
        
        if(nchar(a)>1){
          a <- read.csv(textConnection(a), sep=";", 
                colClasses = c("POSIXct","numeric","numeric"))
          wynik <- rbind.data.frame(wynik, a)
    
          cat(paste0(stacja,"\t", daty[i],"\t" ,round((i/length(daty))*100,1),"%\n"))
        } else {
          cat(paste("Wystąpił błąd\tdata:", link))
          cat(paste("Pobieranie będzie kontynuowane dla kolejnych dat za 1 min."))
          Sys.sleep(60)
        } # koniec if-else dla nchar(a)>1
    
    i <- i+1
} # koniec petli while


return(wynik)

}
