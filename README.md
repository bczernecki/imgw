
<!-- README.md is generated from README.Rmd. Please edit that file -->
imgw
====

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

-   **clean\_metadata()** - Metadata cleaning function. Giving table containing parameters of selected period and character (SYNOP/KLIMAT/OPAD)

-   **metadata()** - Downloading the description (metadata) to the meteorological data provided in the danepubliczne.imgw.pl repository. By default, the function returns a list or data frame for a selected subset.

-   **meteo\_miesieczne()** - Downloading monthly (meteorological) data from SYNOP/KLIMAT/OPAD stations made available in the danepubliczne.imgw.pl databased

-   **meteo\_dobowe()** - Downloading daily (meteorological) data from SYNOP/KLIMAT/OPAD stations made available in the danepubliczne.imgw.pl databased

-   **meteo\_terminowe()** - Downloading hourly (meteorological) data from SYNOP/KLIMAT/OPAD stations made available in the danepubliczne.imgw.pl databased

Examples
--------

Acknowledgment
--------------

Institute of Meteorology and Water Management - National Research Institute is the source of the data.
