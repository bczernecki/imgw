
<!-- README.md is generated from README.Rmd. Please edit that file -->
imgw
====

[![Build Status](https://travis-ci.org/bczernecki/imgw.png?branch=master)](https://travis-ci.org/bczernecki/imgw)

The goal of **imgw** is to automatize downloading Polish meteorological and hydrological data from the [IMGW-PIB](https://dane.imgw.pl/).

Installation
------------

<!-- You can install the released version of imgw from [CRAN](https://CRAN.R-project.org) with: -->
<!-- ``` r -->
<!-- install.packages("imgw") -->
<!-- ``` -->
You can install the development version of **imgw** from [GitHub](https://github.com/bczernecki/imgw) with:

``` r
library(devtools)
install_github("bczernecki/imgw")
```

Overview
--------

### Meteorological data

-   **meteo\_monthly()** - Downloading monthly meteorological data from SYNOP/KLIMAT/OPAD stations made available in the danepubliczne.imgw.pl database

-   **meteo\_daily()** - Downloading daily meteorological data from SYNOP/KLIMAT/OPAD stations made available in the danepubliczne.imgw.pl database

-   **meteo\_hourly()** - Downloading hourly meteorological data from SYNOP/KLIMAT/OPAD stations made available in the danepubliczne.imgw.pl database

-   **meteo\_metadata()** - Downloading the description (metadata) of the meteorological data provided in the danepubliczne.imgw.pl database <!-- By default, the function returns a list or data frame for a selected subset. --> <!--lista czy ramka??-->

### Hydrological data

-   **hydro\_annual()** - Downloading semiannual and annual hydrological data from the danepubliczne.imgw.pl database

-   **hydro\_monthly()** - Downloading monthly hydrological data from the danepubliczne.imgw.pl database

-   **hydro\_daily()** - Downloading daily hydrological data from the danepubliczne.imgw.pl database

-   **hydro\_metadata()** - Downloading the description (metadata) of the hydrological data provided in the danepubliczne.imgw.pl database

Examples
--------

Acknowledgment
--------------

Institute of Meteorology and Water Management - National Research Institute is the source of the data.
