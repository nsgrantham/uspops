#' @importFrom tibble tibble
NULL

#' US population data, 1900-2018
#'
#' @format A data frame (specifically a tbl_df) with 118 observations and 2 variables: 
#'         \code{year} and \code{pop}, the US population on July 1st of the given year 
#'         as estimated by the US Census Bureau. Two exceptions are 1970 and 1980 where 
#'         \code{pop} is the estimated US population on April 1st. For years before 1970,
#'         \code{pop} is rounded to the nearest thousandth. From 1900 to 1949, the US 
#'         population estimate includes the first 48 states and District of Columbia.
#'         From 1950 to 2018, the US population includes the first 48 states, Alaska
#'         (granted statehood in 1959), Hawaii (granted statehood in 1959), and 
#'         District of Columbia. The US territory Puerto Rico is not included any 
#'         US population estimate.
"us_pops"

#' State population data, 1900-2018
#'
#' @format A data frame (specifically a tbl_df) with 5,927 observations and 3 variables: 
#'         \code{year}, \code{state}, and \code{pop}, the population of the given state 
#'         on July 1st of the given year as estimated by the US Census Bureau. Two 
#'         exceptions are 1970 and 1980 where \code{pop} is the estimated state population 
#'         on April 1st. For years before 1970, \code{pop} is rounded to the nearest thousandth.
#'         Population estimates for the first 48 states and District of Columbia are included 
#'         for all years. Population estimates for Alaska (granted statehood in 1959) are 
#'         included beginning in 1950. Population estimates for Hawaii (granted statehood in 
#'         1959) are included beginning in 1950. Population estimates for the US territory 
#'         Puerto Rico are included beginning in 2010.
"state_pops"
