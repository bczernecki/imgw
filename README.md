
<!-- README.md is generated from README.Rmd. Please edit that file -->

# imgw

[![Build
Status](https://travis-ci.org/bczernecki/imgw.png?branch=master)](https://travis-ci.org/bczernecki/imgw)
[![CRAN
status](https://www.r-pkg.org/badges/version/imgw)](https://cran.r-project.org/package=imgw)
[![CRAN RStudio mirror
downloads](http://cranlogs.r-pkg.org/badges/imgw)](https://cran.r-project.org/package=imgw)

The goal of **imgw** is to automatize downloading Polish meteorological
and hydrological data from the
[IMGW-PIB](https://dane.imgw.pl/), SYNOP (meteorological) data from [ogimet.com](http://ogimet.com/index.phtml.en) and rawinsoden data from University of Wyoming webpage (http://weather.uwyo.edu/upperair/).

## Installation

You can install the released version of imgw from [CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("imgw")
```

You can install the development version of **imgw** from
[GitHub](https://github.com/bczernecki/imgw) with:

``` r
library(remotes)
install_github("bczernecki/imgw")
```

## Overview

### Meteorological data

  - **meteo()** - Downloading hourly, daily, and monthly meteorological
    data from the SYNOP/CLIMATE/PRECIP stations available in the
    danepubliczne.imgw.pl collection. It is a wrapper for
    `meteo_monthly()`, `meteo_daily()`, and `meteo_hourly()`.
    
  - **ogimet_hourly()** - Downloading hourly meteorological
    data from the SYNOP stations available in the
    ogimet collection. Basically any Synop station working under WMO framework after year 2000 should be available

  - **meteo\_sounding()** - Downloading the mea (i.e., measurements of
    the vertical profile of atmosphere) sounding data

  - **meteo\_shortening()** - Shortening column names of meteorological
    parameters to improve the readability of downloaded dataset and
    removing duplicated column names

### Hydrological data

  - **hydro()** - Downloading hourly, daily, and monthly hydrological
    data from the SYNOP / CLIMATE / PRECIP stations available in the
    danepubliczne.imgw.pl collection. It is a wrapper for
    `hydro_annual()`, `hydro_monthly()`, and `hydro_daily()`.

  - **hydro\_shortening()** - Shortening column names of hydrological
    parameters to improve the readability of downloaded dataset and
    removing duplicated column names

## Examples

``` r
library(imgw)
m = meteo_monthly(rank = "synop", year = 2000, coords = TRUE)
head(m)
#>            rank        id        X        Y   station   yy mm tmax_abs
#> 575 SYNOPTYCZNA 353230295 23.16228 53.10726 BIAŁYSTOK 2000  1      5.3
#> 577 SYNOPTYCZNA 353230295 23.16228 53.10726 BIAŁYSTOK 2000  2     10.6
#> 578 SYNOPTYCZNA 353230295 23.16228 53.10726 BIAŁYSTOK 2000  3     14.8
#> 579 SYNOPTYCZNA 353230295 23.16228 53.10726 BIAŁYSTOK 2000  4     27.8
#> 580 SYNOPTYCZNA 353230295 23.16228 53.10726 BIAŁYSTOK 2000  5     29.3
#> 581 SYNOPTYCZNA 353230295 23.16228 53.10726 BIAŁYSTOK 2000  6     32.6
#>     tmax_mean tmin_abs tmin_mean t2m_mean_mon t5cm_min rr_monthly
#> 575       0.4    -16.5      -4.5         -2.1    -23.5       34.2
#> 577       4.1    -10.4      -1.4          1.3    -12.9       25.4
#> 578       6.2     -6.4      -1.0          2.4     -9.4       45.5
#> 579      17.9     -4.6       4.7         11.5     -8.1       31.6
#> 580      21.3     -4.3       5.7         13.8     -8.3        9.4
#> 581      23.1      1.0       9.6         16.6     -1.8       36.4
#>     rr_max_daily first_day_max_rr last_day_max_rr insolation_monthly
#> 575          7.0               29              NA               25.8
#> 577          4.7                4               8               35.6
#> 578         12.7                7              NA               91.5
#> 579         26.9                5              NA              244.9
#> 580          3.3               29              NA              349.1
#> 581          8.3               27              NA              283.8
#>     snowcover_max snowcover_days rain_days snow_days r_s_days hail_days
#> 575            13             22         3        17        5         0
#> 577             3              6         6        15        3         0
#> 578             4              6         8        11        2         0
#> 579             0              0         6         0        0         1
#> 580             0              0         5         0        0         0
#> 581             0              0        10         0        0         1
#>     fog_days fogginess_days rime_days glaze_days snowstorm_low_days
#> 575       11             24         4          1                  2
#> 577        6             17         1          0                  0
#> 578        2             14         0          0                  0
#> 579        4              9         1          0                  0
#> 580        0              2         0          0                  0
#> 581        0              3         0          0                  0
#>     snowstorm_high_days hazyness_days ws_10ms_days ws_15ms_days
#> 575                   1             0            0            0
#> 577                   0             0            0            0
#> 578                   0             0            0            0
#> 579                   0             0            0            0
#> 580                   0             0            0            0
#> 581                   0             0            0            0
#>     thunder_days dew_days hoarfrost_days cloud_mean_mon ws_mean_mon
#> 575            0        0              5            6.6         2.6
#> 577            0        0             10            6.3         2.4
#> 578            0        0             11            5.8         3.2
#> 579            2       12              3            3.5         2.4
#> 580            3        3              4            2.9         1.9
#> 581            4        5              0            4.0         2.1
#>     vapor_press_mean_mon rh_mean_mon press_mean_mon slp_mean_mon
#> 575                  4.9        89.4          996.6       1015.8
#> 577                  5.8        84.7          996.1       1015.0
#> 578                  5.9        79.4          993.8       1012.6
#> 579                  9.4        69.5          993.5       1011.7
#> 580                  9.6        61.8          998.7       1016.8
#> 581                 12.1        66.0          998.7       1016.6
#>     rr_daytime rr_nightime
#> 575       17.5        16.7
#> 577       10.6        14.8
#> 578       14.4        31.1
#> 579        5.9        25.7
#> 580        7.8         1.6
#> 581       14.5        21.9
h = hydro_annual(year = 2010)
head(h)
#>             id station riv_or_lake  hyy idyy Mesu idex   H beyy bemm bedd
#> 3223 150210180 ANNOPOL   Wisła (2) 2010   13    H    1 227 2009   12   19
#> 3224 150210180 ANNOPOL   Wisła (2) 2010   13    H    2 319   NA   NA   NA
#> 3225 150210180 ANNOPOL   Wisła (2) 2010   13    H    3 531 2010    3    3
#> 3226 150210180 ANNOPOL   Wisła (2) 2010   14    H    1 271 2010    8   29
#> 3227 150210180 ANNOPOL   Wisła (2) 2010   14    H    1 271 2010   10   27
#> 3228 150210180 ANNOPOL   Wisła (2) 2010   14    H    2 392   NA   NA   NA
#>      behm
#> 3223   NA
#> 3224   NA
#> 3225   18
#> 3226   NA
#> 3227   NA
#> 3228   NA
```

## Acknowledgment

Institute of Meteorology and Water Management - National Research
Institute, Ogimet.com and University of Wyoming are the sources of the data.
