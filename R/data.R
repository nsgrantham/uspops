#' @importFrom tibble tibble
NULL

#' U.S. Census Bureau population estimates by state (1970-2017)
#'
#' @format A data frame with five variables: \code{year}, \code{state} (including "District of Columbia"),
#'   \code{hispanic_origin} ("Hispanic" or "Non-Hispanic"),  \code{race} (racial groups
#'   change over time: NA (1970-1980); "White", "Black", "American Indian or Alaska Native", 
#'   "Asian or Pacific Islander" (1981-1999); "White", "Black", "American Indian or Alaska Native",
#'   "Asian", "Native Hawaiian or Other Pacific Islander", "Two or More Races" (2000-2017)), 
#'   \code{sex} ("Male" or "Female"), \code{age_group} (groups before 1990 are different), \code{pop}. \code{n}.
"statepops"

#' U.S. Census Bureau population estimates by county (1990-2017)
#'
#' @format A data frame with five variables: \code{year}, \code{state} (including "District of Columbia"),
#'   \code{hispanic_origin} ("Hispanic" or "Non-Hispanic"),  \code{race} (racial groups
#'   change over time: NA (1970-1980); "White", "Black", "American Indian or Alaska Native", 
#'   "Asian or Pacific Islander" (1981-1999); "White", "Black", "American Indian or Alaska Native",
#'   "Asian", "Native Hawaiian or Other Pacific Islander", "Two or More Races" (2000-2017)), 
#'   \code{sex} ("Male" or "Female"), \code{age_group} (groups before 1990 are different), \code{pop}. \code{n}.
"countypops"

