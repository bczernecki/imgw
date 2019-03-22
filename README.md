# imgw

Celem pakietu **imgw** jest automatyzacja pobierania danych hydro-meteorologicznych IMGW-PIB.

## Instalacja 

W celu zainstalowania pakietu najszybciej wykorzystać pakiet `devtools`:

``` r
library(devtools)
install_github("bczernecki/imgw")
```

## Przykład użycia:

* Pobieranie danych terminowych:

```r
wynik2006 <- pobierz_terminowe2(2006)
```

* Jeśli chcemy pobrać wiecęj niż 1 rok warto skorzystać z funkcji `lapply()`
* Poniższa operacja automatycznie pobierze lata 2005-2007:

```r
wynik <- lapply(2005:2007, pobierz_terminowe2)
library(data.table)
wynik2 <- rbindlist(wynik)
```

* Dane dobowe:

```r
?pobierz_dobowe
```

## Dane dobowe i miesięczne:

Część danych ze stacji synoptycznych (miesięczne i dobowe) jest już wstępnie pobrana (do 02/2018) i nie wymaga uruchamiania funkcji `pobierz_..()`.

Dane znajdują się w katalogu `extdata` paczki **imgw** i mogą być wczytane do środowiska R za pomocą funkcji `readRDS()`:

``` r2
miesieczne = readRDS(system.file("extdata", "miesieczne.rds", package = "imgw"))
dobowe = readRDS(system.file("extdata", "dobowe.rds", package = "imgw"))
```

## Dokumentacja w paczce

W chwili obecnej obsługiwane są tylko dane miesięczne, dobowe i terminowe ze stacji synoptycznych.
Nie wszystkie funkcje w dokumentacji mogą być w pełni opisane:

* w chwili obecnej wyłączono pobieranie danych z monitora IMGW ze względu na konieczność instalowania pakietu RSelenium, który sprawiał sporo problemów
* wywołanie niektórych funkcji może być czaso- i pamięciożerne (zwłaszcza dla danych terminowych)
* domyślnie pobierany jest cały zakres czasowy (wszystkie foldery i podfoldery) znalezione w serwisie danepubliczne.imgw.pl dla wybranego zestawu danych. W przyszłości przewiduje się pobieranie poszczególnych podokresów
* Metadane dla danych terminowych na dzień 17/07/2018 (107 parametrów)

## Współpraca

Zachęcamy do zgłaszania wszelkich komentarzy, uwag, błędów czy propozycji zmian na stronie
https://github.com/bczernecki/imgw/issues.
