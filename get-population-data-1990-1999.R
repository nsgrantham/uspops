library(tidyverse)

state_county_fips <- read_tsv(file.path("data", "processed", "state-county-fips.tsv"))

read_population_data <- function(population_data_url) {
  read_table(population_data_url, col_names = c("year", "state_county_code", "age_group", 
                                                "race_sex", "ethnic_origin", "population"))
}

year_codes <- list(
  "90" = 1990,
  "91" = 1991,
  "92" = 1992,
  "93" = 1993,
  "94" = 1994,
  "95" = 1995,
  "96" = 1996,
  "97" = 1997,
  "98" = 1998,
  "99" = 1999
)

age_group_codes <- list(
  "0" = "0",
  "1" = "1-4",
  "2" = "5-9",
  "3" = "10-14",
  "4" = "15-19",
  "5" = "20-24",
  "6" = "25-29",
  "7" = "30-34",
  "8" = "35-39",
  "9" = "40-44",
  "10" = "45-49",
  "11" = "50-54",
  "12" = "55-59",
  "13" = "60-64",
  "14" = "65-69",
  "15" = "70-74",
  "16" = "75-79",
  "17" = "80-84",
  "18" = "85+"
)

race_sex_codes <- list(
  "1" = "White male",
  "2" = "White female",
  "3" = "Black male",
  "4" = "Black female",
  "5" = "American Indian or Alaska Native male",
  "6" = "American Indian or Alaska Native female",
  "7" = "Asian or Pacific Islander male",
  "8" = "Asian or Pacific Islander female"
)

ethnic_origin_codes <- list(
  "1" = "not Hispanic or Latino",
  "2" = "Hispanic or Latino"
)

process_population_data <- function(population_data) {
  population_data %>%
    mutate(year = recode(year, !!! year_codes),
           age_group = recode(age_group, !!! age_group_codes),
           race_sex = recode(race_sex, !!! race_sex_codes),
           ethnic_origin = recode(ethnic_origin, !!! ethnic_origin_codes)) %>%
    left_join(state_county_fips, by = "state_county_code") %>%
    select(year, state_county_code, state, county, everything())
}

population_data_urls <- paste0("https://www2.census.gov/programs-surveys/popest/tables/1990-2000/intercensal/st-co/stch-icen", unlist(year_codes), ".txt")

all_population_data_1990_1999 <- map(population_data_urls, read_population_data) %>%
  map_dfr(process_population_data)

write_tsv(all_population_data_1990_1999, file.path("data", "processed", "population-data-1990-1999.tsv"))
