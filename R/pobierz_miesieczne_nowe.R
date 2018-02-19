library(RCurl)
library(rvest)
library(XML)


adres <- "https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/miesieczne/synop/s_m_d_format.txt"
a <- read.fwf(adres, widths = c(45,10),  fileEncoding="CP1250", stringsAsFactors=F)
a <- na.omit(a)
head(a)
a$V1 <- trimws(a$V1)
a$pole1 <- as.numeric(as.character(unlist(lapply(strsplit(x = a$V2,split = "/"), function(x1) x1[[1]]))))
a$pole2 <- as.numeric(as.character(unlist(lapply(strsplit(x = a$V2,split = "/"), function(x1) x1[[length(x1)]]))))
a$pole2[!grepl(x = a$V2, pattern="/")] <- NA
metadane <- a ; rm(a)

a <- getURL("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/miesieczne/synop/",ftp.use.epsv = FALSE,dirlistonly = TRUE)

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
  colnames(data) <- metadane$V1
  
  head(data)
  unlink(c(temp, temp2))
  
  calosc <- rbind.data.frame(calosc, data)
}

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
