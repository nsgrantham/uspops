library(tidyverse)

state_county_fips <- read_tsv(file.path("data", "processed", "state-county-fips.tsv"))

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
  "1" = "White, Male",
  "2" = "White, Female",
  "3" = "Black, Male",
  "4" = "Black, Female",
  "5" = "American Indian or Alaska Native, Male",
  "6" = "American Indian or Alaska Native, Female",
  "7" = "Asian or Pacific Islander, Male",
  "8" = "Asian or Pacific Islander, Female"
)

hispanic_origin_codes <- list(
  "1" = "Non-Hispanic",
  "2" = "Hispanic"
)

col_names <- c("year", "state_county_code", "age_group", 
               "race_sex", "hispanic_origin", "population")

tidy_up_population_data <- function(population_data_url) {
  read_table(population_data_url, col_names = col_names) %>%
    mutate(year = recode(year, !!! year_codes),
           age_group = recode(age_group, !!! age_group_codes),
           race_sex = recode(race_sex, !!! race_sex_codes),
           hispanic_origin = recode(hispanic_origin, !!! hispanic_origin_codes)) %>%
    separate(race_sex, c("race", "sex"), sep = ", ") %>%
    left_join(state_county_fips, by = "state_county_code") %>%
    select(year, state, county, hispanic_origin, race, sex, age_group, population)
}

messy_county_population_data_urls <- paste0(
  "https://www2.census.gov/programs-surveys/popest/tables/1990-2000/intercensal/st-co/stch-icen",
  unlist(year_codes),
  ".txt"
)

tidy_county_population_data <- messy_county_population_data_urls %>%
  map_dfr(tidy_up_population_data) %>%
  arrange(year, state, county, hispanic_origin, race, sex, age_group)

write_tsv(tidy_county_population_data, file.path("data", "processed", "county-population-data-1990-1999.tsv"))

tidy_state_population_data <- tidy_county_population_data %>%
  group_by(year, state, hispanic_origin, race, sex, age_group) %>%
  summarize(population = sum(population))

write_tsv(tidy_state_population_data, file.path("data", "processed", "state-population-data-1990-1999.tsv"))
