# Automatyzacja pobierania danych hydro-meteorologicznych IMGW-PIB

1. Instalacja
--------------------
W celu zainstalowania pakietu najszybciej wykorzystać pakiet `devtools`:

``` r
# install.packages("devtools") # opcjonalnie
devtools::install_github("bczernecki/imgw")
```

2. Aktywacja
--------------------
W celu aktywowania pobranego pakietu należy wydać polecenie:

``` r
library(imgw)
```


3. Dane dobowe i miesięczne:
--------------------
Część danych ze stacji synoptycznych (miesięczne i dobowe) jest już wstępnie pobrana (do 02/2018) i nie wymaga uruchamiania funkcji 'pobierz_..()'.

Dane znajdują się w katalogu `extdata` paczki `imgw` i mogą być wczytane do środowiska R za pomocą funkcji `readRDS()`:

``` r2
miesieczne = readRDS(system.file("extdata", "miesieczne.rds", package = "imgw"))
dobowe = readRDS(system.file("extdata", "dobowe.rds", package = "imgw"))
```

4. Dokumentacja w paczce
--------------------
W chwili obecnej obsługiwane są tylko dane miesięczne i dobowe ze stacji synoptycznych.