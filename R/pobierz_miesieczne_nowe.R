library(RCurl)
library(rvest)
library(XML)

clean_metadata <- function(adres){
  a <- na.omit(read.fwf(adres, widths = c(1000),  fileEncoding="CP1250", stringsAsFactors=F))
  doilu <- max(nchar(a$V1),na.rm=T)
  pola <- substr(a$V1,doilu-3,doilu)
  a$pole1 <- as.numeric(unlist(lapply(strsplit(pola, "/"), function(x) x[1])))
  a$pole2 <- as.numeric(unlist(lapply(strsplit(pola, "/"), function(x) x[2])))
  
  a$V1 <- trimws(substr(a$V1, 1, nchar(a$V1)-3))
  #a <- a[nchar(a$V1)>2,] # usuwamy puste lub prawie puste wiersze dodatkowo...
  a <- a[!(is.na(a$pole1) & is.na(a$pole2)),] # usuwanie info o statusach
  a
}

clean_metadata(adres = "https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/dobowe/synop/s_d_format.txt")

metadane <- function(okres){ # okres moze byc: miesieczne, dobowe, terminowe
  b <- NULL
  
  if(okres=="dobowe")   { # uwaga! dobowe maja po 2 pliki z metadanymi!!!
    b[[1]] <-   clean_metadata("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/dobowe/synop/s_d_format.txt")
    b[[2]] <-   clean_metadata("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/dobowe/synop/s_d_t_format.txt")
  }
  
  b[[1]] <- if(okres=="miesieczne") clean_metadata("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/miesieczne/synop/s_m_d_format.txt")
  b[[1]] <- if(okres=="terminowe")  clean_metadata("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/terminowe/synop/s_t_format.txt")
  b
}

meta <- metadane(okres="dobowe")
meta <- metadane(okres="terminowe")
meta <- metadane(okres="miesieczne")

################################
################################
# to jest fragment dla miesiecznych:
okres <- "miesieczne"
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
###################################
###################################


# to jest fragment dla dobowych:
okres <- "dobowe"
a <- getURL(paste0("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/",okres,"/synop/"),ftp.use.epsv = FALSE,dirlistonly = TRUE)
ind <- readHTMLTable(a)[[1]]$Name %>% grep(pattern="/")
katalogi <- readHTMLTable(a)[[1]]$Name[ind] %>% as.character()
calosc <- NULL
# to jest fragment dla dobowych:
# ktore najlepiej najpierw pobrac...
#if(okres=="dobowe")
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

#swiec rysiek to:
a <- (dir(pattern=".zip")) # tu mam 1500 plikow zip, z ktorych kazdy zawiera ~2-3 pliki w srodku
b <- as.list(a)    # robie z tego liste
lapply(b, FUN = function(x) unzip(zipfile = x)) # i wszystko rozpakowywuje

# zaczytaj wszystkie csv-ki z patternem 's_d' na poczatku
library(dplyr)
pliki <- dir(pattern="^s_d") %>%   .[ ! grepl("_t_", .) ] # usuwamy w ten sposob pattern s_d_t_

calosc <- lapply(as.list(pliki), FUN=function(x) read.csv(x, header=F, stringsAsFactors = F, fileEncoding = "CP1250"))

library(data.table)
calosc2 <- rbindlist(calosc)

library(dplyr)
poznan <- dplyr::filter(calosc, `Nazwa stacji`=="POZNAŃ") %>% dplyr::select(., matches("Kod"):Miesiąc, matches("Średnia temperatura miesięczna")) 
library(reshape)
poznan <- poznan[,-1:-2]
colnames(poznan) <- c("rok","miesiac","temp")
head(poznan)

library(tidyr)
poznan <- spread(poznan, key="miesiac", value="temp")
poznan <- data.frame(poznan,srednia=round(rowMeans(poznan[,-1]),1))
colnames(poznan)[2:13] <- month.abb
head(poznan)
colMeans(poznan, na.rm = T) %>% round(.,1)

poznan$rok <- as.factor(poznan$rok)

poznan2 <- poznan %>% melt() 
poznan2 <- poznan2%>% filter(variable=="Jan" | variable=="Jul" | variable =="Apr" | variable=="Sep")

library(ggplot2)
library(ggthemes)
ggplot(data=poznan2, aes(value))+
  geom_histogram(bins = 8,show.legend = T,na.rm = T,col="white", fill="lightblue")+
  xlab("temperatura powietrza")+
  facet_wrap(~variable,scales = "free")
