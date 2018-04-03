# imgw
Automatize downloading of IMGW-PIB meteorological/hydrological dataset

## Dane dostępne od razu
Część danych ze stacji synoptycznych (miesięczne i dobowe) jest już wstępnie pobrana do 02/2018 i nie wymaga uruchamiania funkcji 'pobierz_..()'.

Dane znajdują się w katalogu `extdata` paczki `imgw` i mogą być wczytane do środowiska R za pomocą funkcji `readRDS()`:

`miesieczne = readRDS(system.file("extdata", "miesieczne.rds", package = "imgw"))`

`dobowe = system.file("extdata", "dobowe.rds", package = "imgw")`