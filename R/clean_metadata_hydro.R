#' Hydrological metadata cleaning
#'
#' Internal function for hydrological metadata cleaning
#' @param address URL address of the metadata file
#' @param interval temporal interval
#' @importFrom RCurl getURL
#' @importFrom utils read.fwf
#' @return
#miesieczne
#address="https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_hydrologiczne/miesieczne/mies_info.txt"
#dobowe
#"https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_hydrologiczne/dobowe/codz_info.txt"
#"https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_hydrologiczne/dobowe/zjaw_info.txt"
#polroczne_i_roczne
#address="https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_hydrologiczne/polroczne_i_roczne/polr_info.txt"

clean_metadata_hydro <- function(address, interval = "miesieczne"){
  a <- suppressWarnings(na.omit(read.fwf(address, widths = c(1000),
                                         fileEncoding = "CP1250", stringsAsFactors = FALSE)))

  if(interval == "miesieczne") {
    b <- a[2:11, ] # skład danych jeszcze nie wiem jak ominąć problem kontroli
                    # ale on może się zmienić nie wiem czy nie lepiej wykluczyć ostatni rok
  }
  if(interval == "dobowe") {
    b <- a[2:11, ]
  }
  if(interval == "polroczne_i_roczne") {
    godzina <- paste0(a[14, ], ":", a[15, ]) # nie jestem pewien czy tak bo w dokumentacji jest podzial na dwie kolumny,
                                            #ale w pliku jest jedna kolumna a pomiaru brak
    data <- c(a[11:13, ], godzina)
    data_od <- paste0("wystapienie_od_", data)
    data_do <- paste0("wystapienie_od_", data)
    SPT <- unlist(strsplit(a[9, ], "]/")) # stan/przeplyw/temperatura
    SPT[1] <- paste0(SPT[1], "]")
    SPT[2] <- paste0(SPT[2], "]")
    b <- NULL
    for (i in 1:length(SPT)) {
      tmp <- c(a[2:8, ], SPT[i], data_od, data_do)
      b <- cbind(b, tmp)
    }
    colnames(b) <- c("H", "Q", "T")
    b <- as.data.frame(b)
    }
  b
}
