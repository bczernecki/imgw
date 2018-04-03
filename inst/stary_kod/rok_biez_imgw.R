library(RCurl)
library(rvest)
library(XML)


adres <- "https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/terminowe/synop/s_t_format.txt"
a <- read.fwf(adres, widths = c(47,5),  fileEncoding="CP1250", stringsAsFactors=F)
a <- na.omit(a)
a$V1 <- trimws(a$V1)
a$pole1 <- as.numeric(as.character(unlist(lapply(strsplit(x = a$V2,split = "/"), function(x1) x1[[1]]))))
a$pole2 <- as.numeric(as.character(unlist(lapply(strsplit(x = a$V2,split = "/"), function(x1) x1[[length(x1)]]))))
a$pole2[!grepl(x = a$V2, pattern="/")] <- NA
metadane <- a ; rm(a)

a <- getURL("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/terminowe/synop/2017/",ftp.use.epsv = FALSE,dirlistonly = TRUE)
stacje <- readHTMLTable(a)[[1]]$Name %>% grep(pattern = "zip")
stacje <- readHTMLTable(a)[[1]]$Name[stacje] %>% as.character()

adresy <- paste0("https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/terminowe/synop/2017/",stacje)
#adres <- "https://dane.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/terminowe/synop/2016/2016_100_s.zip"


calosc <- NULL
for (i in 1:length(adresy)){
  print(i)
  
  temp <- tempfile()
  temp2 <- tempfile()
  download.file(adresy[i], temp)
  unzip(zipfile = temp, exdir = temp2)
  plik <- paste(temp2,dir(temp2),sep="/")
  data <- read.csv(plik, header=F, stringsAsFactors = F, fileEncoding = "CP1250") 
  colnames(data) <- metadane$V1
  
  head(data)
  unlink(c(temp, temp2))
  
  calosc <- rbind.data.frame(calosc, data)
}

dplyr::filter(calosc, `Nazwa stacji`=="POZNAŃ") %>% 
    dplyr::select(`Kod stacji`:Godzina, `Opad za 6 godzin`) %>% 
  dplyr::group_by(Rok,Miesiąc) %>% dplyr::summarise(sum(`Opad za 6 godzin`))
