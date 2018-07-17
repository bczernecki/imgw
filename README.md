# Automatyzacja pobierania danych hydro-meteorologicznych IMGW-PIB

# 1. Instalacja
--------------------
W celu zainstalowania pakietu najszybciej wykorzystać pakiet `devtools`:

``` r
# dla swiezej instalacji R:
install.packages("devtools") 
# install.packages("RSelenium") # paczka chwilowo niepotrzebne ze wzgledu na wylaczenie monitora IMGW
install.packages("XML")
install.packages("RCurl")
install.packages("dplyr")
install.packages("rvest")
install.packages("data.table")

library(devtools)
install_github("bczernecki/imgw")
```

# 2. Aktywacja
--------------------
W celu aktywowania pobranego pakietu należy wydać polecenie:

``` r
library(imgw)
```


# 3. Dane dobowe i miesięczne:
--------------------
Część danych ze stacji synoptycznych (miesięczne i dobowe) jest już wstępnie pobrana (do 02/2018) i nie wymaga uruchamiania funkcji 'pobierz_..()'.

Dane znajdują się w katalogu `extdata` paczki `imgw` i mogą być wczytane do środowiska R za pomocą funkcji `readRDS()`:

``` r2
miesieczne = readRDS(system.file("extdata", "miesieczne.rds", package = "imgw"))
dobowe = readRDS(system.file("extdata", "dobowe.rds", package = "imgw"))
```
  
# 4. Dokumentacja w paczce
--------------------
W chwili obecnej obsługiwane są tylko dane miesięczne, dobowe i terminowe ze stacji synoptycznych.
Nie wszystkie funkcje w dokumentacji mogą być w pełni opisane
* w chwili obecnej wyłączono pobieranie danych z monitora IMGW ze względu na konieczność instalowania pakietu RSelenium, który sprawiał sporo problemów
* wywołanie niektórych funkcji może być czaso- i pamięciożerne (zwłaszcza dla danych terminowych)
* domyślnie pobierany jest cały zakres czasowy (wszystkie foldery i podfoldery) znalezione w serwisie danepubliczne.imgw.pl dla wybranego zestawu danych. W przyszłości przewiduje się pobieranie poszczególnych podokresów
* Metadane dla danych terminowych na dzień 17/07/2018 (107 parametrów)


# 5. Przykład użycia:
--------------------

* Pobieranie danych terminowych:

```
# jesli chcemy pobrac wiecej niz 1 rok warto skorzystac z funkcji 'lapply'
# ponizsza operacja automatycznie pobierze lata 2005-2007:
wynik <- lapply(2005:2007, pobierz_terminowe2)
library(data.table)
wynik2 <- rbindlist(wynik)
```

* Dane dobowe:

```
?pobierz_dobowe
```
