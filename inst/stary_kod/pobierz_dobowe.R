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
