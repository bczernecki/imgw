
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
library(remotes)
install_github("bczernecki/imgw")
```

Overview
--------

### Meteorological data

-   **meteo()** - Downloading hourly, daily, and monthly meteorological data from the SYNOP/CLIMATE/PRECIP stations available in the danepubliczne.imgw.pl collection. It is a wrapper for `meteo_monthly()`, `meteo_daily()`, and `meteo_hourly()`.

-   **meteo\_monthly()** - Downloading monthly meteorological data from SYNOP/CLIMATE/PRECIP stations made available in the danepubliczne.imgw.pl database

-   **meteo\_daily()** - Downloading daily meteorological data from SYNOP/CLIMATE/PRECIP stations made available in the danepubliczne.imgw.pl database

-   **meteo\_hourly()** - Downloading hourly meteorological data from SYNOP/CLIMATE/PRECIP stations made available in the danepubliczne.imgw.pl database

-   **meteo\_metadata()** - Downloading the description (metadata) of the meteorological data provided in the danepubliczne.imgw.pl database

-   **meteo\_sounding()** - Downloading the mea (i.e., measurements of the vertical profile of atmosphere) sounding data

-   **meteo\_shortening()** - Shortening column names of meteorological parameters to improve the readability of downloaded dataset and removing duplicated column names

### Hydrological data

-   **hydro()** - Downloading hourly, daily, and monthly hydrological data from the SYNOP / CLIMATE / PRECIP stations available in the danepubliczne.imgw.pl collection. It is a wrapper for `hydro_annual()`, `hydro_monthly()`, and `hydro_daily()`.

-   **hydro\_annual()** - Downloading semiannual and annual hydrological data from the danepubliczne.imgw.pl database

-   **hydro\_monthly()** - Downloading monthly hydrological data from the danepubliczne.imgw.pl database

-   **hydro\_daily()** - Downloading daily hydrological data from the danepubliczne.imgw.pl database

-   **hydro\_metadata()** - Downloading the description (metadata) of the hydrological data provided in the danepubliczne.imgw.pl database

-   **hydro\_shortening()** - Shortening column names of hydrological parameters to improve the readability of downloaded dataset and removing duplicated column names

Examples
--------

``` r
library(imgw)
m = meteo_monthly(rank = "synop", year = 2000, coords = TRUE)
head(m)
#>          rank        id        X        Y       station   yy mm tmax_abs
#> 1 SYNOPTYCZNA 349190600 19.00234 49.80671 BIELSKO-BIAŁA 2000 10     26.4
#> 2 SYNOPTYCZNA 349190600 19.00234 49.80671 BIELSKO-BIAŁA 2000  1      7.4
#> 3 SYNOPTYCZNA 349190600 19.00234 49.80671 BIELSKO-BIAŁA 2000  6     32.2
#> 4 SYNOPTYCZNA 349190600 19.00234 49.80671 BIELSKO-BIAŁA 2000  7     28.0
#> 5 SYNOPTYCZNA 349190600 19.00234 49.80671 BIELSKO-BIAŁA 2000  8     32.6
#> 6 SYNOPTYCZNA 349190600 19.00234 49.80671 BIELSKO-BIAŁA 2000  9     25.1
#>   tmax_mean tmin_abs tmin_mean t2m_mean_mon t5cm_min rr_monthly
#> 1      17.4      0.6      10.0         13.4     -3.8       39.5
#> 2       0.7    -19.6      -4.5         -1.6    -21.7       38.9
#> 3      22.5      6.1      12.1         17.2      2.4       81.1
#> 4      20.5      6.7      12.0         16.0      5.5      322.5
#> 5      24.1      7.1      13.4         18.6      3.7       62.8
#> 6      17.3      2.7       7.9         12.2     -1.2       46.1
#>   rr_max_daily first_day_max_rr last_day_max_rr insolation_monthly
#> 1         11.7               17              NA                0.0
#> 2          9.1               29              NA                0.0
#> 3         22.1               14              NA              271.8
#> 4         69.3               28              NA                0.0
#> 5         33.6                6              NA                0.0
#> 6         19.0                4              NA                0.0
#>   snowcover_max snowcover_days rain_days snow_days r_s_days hail_days
#> 1             0              0        11         0        0         0
#> 2            30             26         2        16        2         0
#> 3             0              0        11         0        0         0
#> 4             0              0        20         0        0         0
#> 5             0              0        10         0        0         1
#> 6             0              0         8         0        0         0
#>   fog_days fogginess_days rime_days glaze_days snowstorm_low_days
#> 1        8             15         0          0                  0
#> 2        2             28         0          0                 10
#> 3        0              7         0          0                  0
#> 4        1             18         0          0                  0
#> 5        2             17         0          0                  0
#> 6        1             20         0          0                  0
#>   snowstorm_high_days hazyness_days ws_10ms_days ws_15ms_days thunder_days
#> 1                   0             0           11            2            3
#> 2                   4             0            7            1            1
#> 3                   0             0            0            0            4
#> 4                   0             0            5            0            5
#> 5                   0             0            2            0            4
#> 6                   0             0            0            0            0
#>   dew_days hoarfrost_days cloud_mean_mon ws_mean_mon vapor_press_mean_mon
#> 1       12              2            4.9         3.9                 11.4
#> 2        0              0            6.5         4.3                  4.6
#> 3       21              0            4.0         2.8                 13.1
#> 4        8              0            5.9         3.3                 13.9
#> 5       22              0            3.8         2.4                 15.5
#> 6       22              0            4.6         3.0                 11.2
#>   rh_mean_mon press_mean_mon slp_mean_mon rr_daytime rr_nightime
#> 1        74.8          970.3       1017.5       11.8        27.7
#> 2        82.8          971.8       1021.8       16.6        22.3
#> 3        67.2          972.3       1019.0       34.4        46.7
#> 4        77.6          964.4       1010.8      150.9       171.6
#> 5        73.8          971.4       1017.8        6.5        56.3
#> 6        79.2          969.7       1017.1       13.0        33.1
h = hydro_annual(year = 2010)
head(h)
#>          id  station riv_or_lake  hyy idyy Mesu idex   H beyy bemm bedd
#> 1 149180020 CHAŁUPKI    Odra (1) 2010   13    H    1 135 2009   12   20
#> 2 149180020 CHAŁUPKI    Odra (1) 2010   13    H    2 188   NA   NA   NA
#> 3 149180020 CHAŁUPKI    Odra (1) 2010   13    H    3 420 2009   11   12
#> 4 149180020 CHAŁUPKI    Odra (1) 2010   14    H    1 137 2010    8   26
#> 5 149180020 CHAŁUPKI    Odra (1) 2010   14    H    2 229   NA   NA   NA
#> 6 149180020 CHAŁUPKI    Odra (1) 2010   14    H    3 650 2010    5   17
#>   behm
#> 1   NA
#> 2   NA
#> 3    4
#> 4   NA
#> 5   NA
#> 6   15
```

Acknowledgment
--------------

Institute of Meteorology and Water Management - National Research Institute is the source of the data.
