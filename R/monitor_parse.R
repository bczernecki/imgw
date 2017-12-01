#install.packages("RSelenium")
library(RSelenium)
library(XML)

#startServer()
# remDr <- remoteDriver$new()
# remDr$open()
# remDr$navigate("http://www.google.com")
# remDr$navigate("http://www.bbc.co.uk")
# remDr$goBack()
# remDr$goForward()
# remDr$quit()


adres <- "http://monitor.pogodynka.pl/#station/meteo/352160330"
rD <- rsDriver(port = 4567L, browser = c("chrome"))
remDr <- rD[["client"]]
remDr$navigate("http://www.google.com/ncr")
remDr$navigate(adres)

#webElem <- remDr$findElement(using = 'id', value = "gbqfq")
webElem <- remDr$findElement(using = 'class name', "panel")
webElem$getElementAttribute("class")
library(dplyr)
a2 <- htmlParse(webElem$getElementText()[[1]]) 
class(a2)
a2
remDr$getPageSource()
remDr$close()
rD[["server"]]$stop() 

rD$navigate("http://www.google.com")
