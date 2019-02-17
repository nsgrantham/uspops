#' US population data from the US Census Bureau, 1900-2018
#'
#' @format A data frame (specifically a tbl_df) with 119 observations and 2 variables:
#' \describe{ 
#'   \item{\code{year}}{Year of the population estimate.}
#'   \item{\code{pop}}{US population on July 1st as estimated by the US Census Bureau. 
#'     Two exceptions are 1970 and 1980 where the population is estimated for April 1st.}
#' }
#'
#' @details For years before 1970, \code{pop} is rounded to the nearest thousandth.
#'   
#' For each year from 1900 to 2018, \code{pop} includes the first 48 states and 
#' District of Columbia. Beginning in 1950, \code{pop} also includes Alaska and Hawaii, 
#' both of which were granted statehood in 1959. There are no years for which \code{pop}
#' includes Puerto Rico, a US territory.
"us_pops"

#' State population data from the US Census Bureau, 1900-2018
#'
#' @format A data frame (specifically a tbl_df) with 5,978 observations and 3 variables:
#' \describe{
#'   \item{\code{year}}{Year of the population estimate.}
#'   \item{\code{state}}{Name of state, "District of Columbia", or "Puerto Rico".}
#'   \item{\code{pop}}{State population on July 1st as estimated by the US Census Bureau.
#'     Two exceptions are 1970 and 1980 where the population is estimated for April 1st.}
#' } 
#' 
#' @details For years before 1970, \code{pop} is rounded to the nearest thousandth.
#' 
#' For each year from 1900 to 2018, \code{pop} is available for the first 48 states and 
#' District of Columbia. Beginning in 1950, \code{pop} is available for Alaska and Hawaii,
#' both of which were granted statehood in 1959. Beginning in 2010, \code{pop} is available
#' for Puerto Rico, a US territory.
"state_pops"
