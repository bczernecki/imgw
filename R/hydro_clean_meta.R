#' Funkcja czyszczaca hydro metadane
#'
#' Tylko do wewnetrznego uzytku...
#' Na potrzeby funkcji "hydro()" ?
#' @param adres adres URL do pliku z metadanymi
#' @param interwal interwal czasowy
#' @importFrom RCurl getURL
#' @importFrom utils read.fwf
#' @return
#' @export
#'
#' @examples \dontrun{
#'
#' }

#TODO:dane dobowe
#w folderze /dobowe/  sa 2 rodzaje metadanych
#czy usunac informacje z wierszy 6:8 w polroczach
#miesieczne
#adres="https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_hydrologiczne/miesieczne/mies_info.txt"
#dobowe
#"https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_hydrologiczne/dobowe/codz_info.txt"
#"https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_hydrologiczne/dobowe/zjaw_info.txt"
#polroczne_i_roczne
#adres="https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_hydrologiczne/polroczne_i_roczne/polr_info.txt"

hydro_clean_metadata <- function(adres, interwal = "miesieczne"){
  a <- suppressWarnings(na.omit(read.fwf(adres, widths = c(1000), fileEncoding = "CP1250", stringsAsFactors = FALSE)))


  if(interwal == "miesieczne") {
    b<- a[2:11,] # skład danych jeszcze nie wiem jak ominąć problem kontroli
    #wyjatek=substr(a[19,],65,68)  ale on może się zmienić nie wiem czy nie lepiej wykluczyć ostatni rok
  }
  if(interwal == "dobowe") { #narazie nie uwzględniam zjawisk w oddzielnym pliku
    b<- a[2:11,]

  }
  if( interwal == "polroczne_i_roczne") { #
    godzina = paste0(a[14,],":",a[15,]) # nie jestem pewien czy tak bo w dokumentacji jest podzial na dwie kolumny,
                                        #ale ale w pliku jest jedna kolumna a pomiaru brak
    data = c(a[11:13,],godzina)
    data_od=paste0("wystapienie_od_",data)
    data_do=paste0("wystapienie_od_",data)
    SPT <- unlist(strsplit(a[9,], "]/")) # stan/przeplyw/temperatura
    SPT[1]=paste0(SPT[1],"]")
    SPT[2]=paste0(SPT[2],"]")
    b=NULL
    for (i in 1:length(SPT)) {
      tmp=c(a[2:8,],SPT[i],data_od,data_do)
      b=cbind(b,tmp)
    }
    colnames(b)=c("H","Q","T")
    b=as.data.frame(b)

    }
  b
}
