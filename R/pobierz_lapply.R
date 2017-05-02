#' Pobieranie danych meteorologicznych z serwisu IMGW-PIB (https://dane.imgw.pl)
#'
#' Funkcja pozwalająca na zautomatyzowanie procesu pobierania danych meteorologicznych i hydrologicznych z oficjalnego repozytorium Instytutu Meteorologii i Gospodarki Wodnej - Państwowego Instytutu Badawczego - https://dane.imgw.pl.
#' Jest to zrównoleglona wersja funkcji 'pobierz'. Z uwagi na możliwość otwarcia max. 128 połączeń (textConnections) w R liczba wykonywanych zapytań jest dzielona na proporcjonalnie mniejsze części.
#' 
#' @param user_pass  Login i token wygenerowany przez serwis https://dane.imgw.pl. Parametr w postaci email:token, np. bczernecki@gmail.com:68a60055
#' @param data_start Data początkowa od której będą pobierane dane. Obiekt klasy Date
#' @param data_end Data końcowa do której będą pobierane. Obiekt klasy Date. Domyślnie funkcja rozszerza zakres pobierania danych o tydzień w przód i w tył
#' @param stacja Kod stacji wg strony https://dane.imgw.pl
#' @param kod Kod pobieranego elementu meteorologicznego/hydrologicznego
#' @param cores Liczba wątków do zrównoleglonego pobierania

#' @importFrom RCurl getURL
#' @importFrom parallel mclapply
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
#' cores <- 4 # liczba watkow do mclapply
#' pobierz_lapply(data_start,data_end,user_pass,stacja,kod,cores)
#' 
#' 
#' # mozna takze uruchomic w petli dla kilku stacji...
#' 
#' stacja <- c("350150500", "350190560", "350160520","351160415", "350170530")
#' kod <- "B609B00400"
#' for(stacja2 in stacja){
#'   data_start <- "1966-01-01"
#'   data_end <- "2017-01-01"
#'   tmp <- pobierz_lapply(data_start,data_end,user_pass,stacja2,kod, cores=4) # pobieranie danych
#'    write.table(x = tmp, file=paste0(stacja2, ".csv" ), row.names = F) # zapisywanie danego roku do pliku
#' } # koniec petli dla stacji



pobierz_lapply <- function(data_start,data_end,user_pass,stacja,kod,cores){
  
  library(RCurl)
  library(parallel)
#  library(R.utils)

  daty <- seq.Date(from=as.Date(data_start)-7, to=as.Date(data_end)+7, by="7 days")

  wyciagnij <- function(x, kod, stacja, user_pass){
    
    link <- paste0("https://dane.imgw.pl/1.0/pomiary/cbdh/",stacja,"-",kod,"/tydzien/",x,"?format=csv")
    a <- getURL(link,userpwd = user_pass)
    a <- gsub(a,pattern = "\\r",replacement = "")
    #a <- read.csv(textConnection(a), sep=";", colClasses = c("POSIXct","numeric","numeric"))
    a <- read.csv(textConnection(a), sep=";", stringsAsFactors = F)
    
    
    if(any(grepl("Unauthorized", a))) {
      cat(paste("Wystąpił problem z autoryzacją. Sprawdź nazwę użytkownika i hasło oraz sprawdź czy link:\n", link[1] , " działa poprawnie w przeglądarce"))
      stop()
    }  
    
    
    return(a)
}

daty2 <- data.frame(daty=daty)
nr <- nrow(daty2)
n <- 125 # liczba polaczen do odpalenia na raz:
lista <- split(daty2, rep(1:ceiling(nr/n), each=n, length.out=nr)) # dzielenie na liste

  wynik <- NULL
    for (i in 1:length(lista)){
        bb <- parallel::mclapply(lista[[i]]$daty, FUN = wyciagnij, kod=kod, stacja=stacja, 
                       user_pass=user_pass,mc.cores = cores )
        bb <- do.call(rbind.data.frame, bb)
        
            proba_nr <- 1
            while(ncol(bb)!=3 & proba_nr<=12) {
              cat(paste0("Prawdopodobnie wystąpił błąd podczas pobierania. Liczba kolumn =!3\nCzekam 60 s. przed ponowieniem pobierania... Proba nr ", proba_nr,"\n"))
              cat(paste("Prawdopodobny kod błędu:", head(bb,1)))
              Sys.sleep(60)
              bb <- parallel::mclapply(lista[[i]]$daty, FUN = wyciagnij, kod=kod, stacja=stacja,
                                       user_pass=user_pass,mc.cores = cores )
              bb <- do.call(rbind.data.frame, bb)
              
              proba_nr <- proba_nr+1
                
                if(proba_nr==13) {
                  cat(paste("Wykonano ostatnie podejście. Przerywam działanie..."))
                  print(Sys.time())
                  stop()
                }
              
            } # koniec petli while ncol
        
        wynik <- rbind.data.frame(wynik, bb)
        cat(paste0(kod, "  ", stacja, "  ", as.Date(range(bb$data)[1]), "  ", as.Date(range(bb$data)[2]), " | ",
                   round(i/length(lista)*100,1),"%", "\n"))
        closeAllConnections()
    } # koniec petli 'for' lista

  return(wynik)
} #koniec funkcji