# 🇺🇸 uspops

[![Travis-CI Build Status](https://travis-ci.org/nsgrantham/uspops.svg?branch=master)](https://travis-ci.org/nsgrantham/uspops)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/nsgrantham/uspops?branch=master&svg=true)](https://ci.appveyor.com/project/nsgrantham/uspops)

This package contains two datasets provided by the US Census Bureau:

* `us_pops`: For each year from 1900 to 2018, the estimated population of 
  the United States on July 1st (two exceptions are 1970 and 1980 where the 
  estimates are made for April 1st).

* `state_pops`: For each year from 1900 to 2018, the estimated population of
  of all 50 states (Alaska and Hawaii since 1950), District of Columbia, and 
  Puerto Rico (since 2010) on July 1st (two exceptions are 1970 and 1980 where
  the estimates are made for April 1st).  

Th
e datasets are tidy and made from the following non-tidy US Census Bureau files:

* [Population estimates 1900-1909](https://www2.census.gov/programs-surveys/popest/tables/1980-1990/state/asrh/st0009ts.txt)

* [Population estimates 1910-1919](https://www2.census.gov/programs-surveys/popest/tables/1980-1990/state/asrh/st1019ts.txt)

* [Population estimates 1920-1929](https://www2.census.gov/programs-surveys/popest/tables/1980-1990/state/asrh/st2029ts.txt)

* [Population estimates 1930-1939](https://www2.census.gov/programs-surveys/popest/tables/1980-1990/state/asrh/st3039ts.txt)

* [Population estimates 1940-1949](https://www2.census.gov/programs-surveys/popest/tables/1980-1990/state/asrh/st4049ts.txt)

* [Population estimates 1950-1959](https://www2.census.gov/programs-surveys/popest/tables/1980-1990/state/asrh/st5060ts.txt)

* [Population estimates 1960-1969](https://www2.census.gov/programs-surveys/popest/tables/1980-1990/state/asrh/st6070ts.txt)

* [Population estimates 1970-1979](https://www2.census.gov/programs-surveys/popest/tables/1980-1990/state/asrh/st7080ts.txt)

* [Population estimates 1980-1989](https://www2.census.gov/programs-surveys/popest/tables/1980-1990/state/asrh/st8090ts.txt)

* [Population estimates 1990-1999](https://www2.census.gov/programs-surveys/popest/tables/1990-2000/intercensal/st-co/co-est2001-12-00.pdf)

* [Population estimates 2000-2009](https://www2.census.gov/programs-surveys/popest/datasets/2000-2009/national/totals/nst_est2009_alldata.csv)

* [Population estimates 2010-2018](https://www2.census.gov/programs-surveys/popest/datasets/2010-2018/national/totals/nst-est2018-alldata.csv)

To produce `us_pops` and `state_pops` from these files, see [`data-raw/get-data.R`](data-raw/get-data.R).

## Installation

You can install uspops from GitHub with:

```r
# install.packages("devtools")
devtools::install_github("nsgrantham/uspops")
```
