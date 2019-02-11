#' @importFrom tibble tibble
NULL

#' State population data, 1970 to 2017, as measured by the US Census Bureau.
#'
#' @format A data frame with XXX rows and 7 variables:
#' \describe{
#'   \item{year}{Year of population estimate.}
#'   \item{state}{Name of US state or "District of Columbia".}
#'   \item{hispanic_origin}{"Hispanic" or "Non-Hispanic". (Data not available for 1970 to 1980)}
#'   \item{race}{For 1980 to 1999, the races are "White", "Black", "American Indian or Alaska Native", 
#'   and "Asian or Pacific Islander". For 2000 to 2017, the races are "White", "Black", 
#'   "American Indian or Alaska Native", "Asian", "Nativa Hawaiian or Other Pacific Islander", and 
#'   "Two or More Races", for people recorded as belonging to more than one race. (Data not 
#'   available for 1970 to 1980)}
#'   \item{sex}{"Male" or "Female". (Data not available for 1970 to 1980)}
#'   \item{age_group}{For 1970 to 1980, the age groups are "0-4", "5-14", "15-19", "20-24", 
#'   "25-29", "30-34", "35-44", "45-54", "55-59", "60-64", and "65+". For 1981 to 2017, the 
#'   age groups are "0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69", 
#'   "70-74", "75-79", "80-84", and "85+".}
#'   \item{pop}{Population estimate.}
#' }
"statepops"

#' County population data, 1990 to 2017, as measured by the US Census Bureau.
#'
#' @format A data frame with XXX rows and 8 variables:
#' \describe{
#'   \item{year}{Year of population estimate.}
#'   \item{state}{Name of US state or "District of Columbia".}
#'   \item{county}{Name of US county.}
#'   \item{hispanic_origin}{"Hispanic" or "Non-Hispanic".}
#'   \item{race}{For 1990 to 1999, the races are "White", "Black", "American Indian or Alaska Native", 
#'   and "Asian or Pacific Islander". For 2000 to 2017, the races are "White", "Black", 
#'   "American Indian or Alaska Native", "Asian", "Nativa Hawaiian or Other Pacific Islander", and 
#'   "Two or More Races", which records people who identified themselves as belonging to more than 
#'   one race.}
#'   \item{sex}{"Male" or "Female".}
#'   \item{age_group}{"0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39", 
#'   "40-44", "45-49", "50-54", "55-59", "60-64", "65-69", "70-74", "75-79", "80-84", and "85+".}
#'   \item{pop}{Population estimate.}
#' }
"countypops"
