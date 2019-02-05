library(tidyverse)

state_county_fips <- read_tsv(file.path("data", "processed", "state-county-fips.tsv"))

state_fips <- read_tsv(file.path("data", "processed", "state-fips.tsv"))

read_population_data <- function(population_data_url) {
  read_csv(population_data_url) %>%
    select(state = STNAME, county = CTYNAME, year = YEAR, age_group = AGEGRP,
           `Hispanic, White, Male` = HWA_MALE, 
           `Hispanic, White, Female` = HWA_FEMALE, 
           `Hispanic, Black, Male` = HBA_MALE, 
           `Hispanic, Black, Female` = HBA_FEMALE, 
           `Hispanic, American Indian or Alaska Native, Male` = HIA_MALE, 
           `Hispanic, American Indian or Alaska Native, Female` = HIA_FEMALE, 
           `Hispanic, Asian, Male` = HAA_MALE, 
           `Hispanic, Asian, Female` = HAA_FEMALE,
           `Hispanic, Native Hawaiian or Other Pacific Islander, Male` = HNA_MALE, 
           `Hispanic, Native Hawaiian or Other Pacific Islander, Female` = HNA_FEMALE,
           `Hispanic, Two or More Races, Male` = HTOM_MALE,
           `Hispanic, Two or More Races, Female` = HTOM_FEMALE,
           `Non-Hispanic, White, Male` = NHWA_MALE, 
           `Non-Hispanic, White, Female` = NHWA_FEMALE, 
           `Non-Hispanic, Black, Male` = NHBA_MALE, 
           `Non-Hispanic, Black, Female` = NHBA_FEMALE, 
           `Non-Hispanic, American Indian or Alaska Native, Male` = NHIA_MALE, 
           `Non-Hispanic, American Indian or Alaska Native, Female` = NHIA_FEMALE, 
           `Non-Hispanic, Asian, Male` = NHAA_MALE, 
           `Non-Hispanic, Asian, Female` = NHAA_FEMALE,
           `Non-Hispanic, Native Hawaiian or Other Pacific Islander, Male` = NHNA_MALE, 
           `Non-Hispanic, Native Hawaiian or Other Pacific Islander, Female` = NHNA_FEMALE,
           `Non-Hispanic, Two or More Races, Male` = NHTOM_MALE,
           `Non-Hispanic, Two or More Races, Female` = NHTOM_FEMALE) %>%
    filter(year %in% c(2:11, 13), age_group != 99)
}


year_codes <- list(
  "2" = 2000,
  "3" = 2001,
  "4" = 2002,
  "5" = 2003,
  "6" = 2004,
  "7" = 2005,
  "8" = 2006,
  "9" = 2007,
  "10" = 2008,
  "11" = 2009,
  "13" = 2010
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

state_codes_except_puerto_rico <- state_fips %>%
  filter(state != "Puerto Rico") %>%
  pull(state_code)

population_data_urls <- paste0("https://www2.census.gov/programs-surveys/popest/datasets/2000-2010/intercensal/county/co-est00int-alldata-", state_codes_except_puerto_rico, ".csv")

process_population_data <- function(population_data) {
  population_data %>%
    gather(ethnicity_race_sex, population, -state, -county, -year, -age_group) %>%
    mutate(year = recode(year, !!! year_codes),
           age_group = recode(age_group, !!! age_group_codes)) %>%
    separate(ethnicity_race_sex, c("ethnicity", "race", "sex"), sep = ", ") %>% 
    left_join(state_county_fips, by = c("state", "county")) %>%
    select(year, state_county_code, state, county, ethnicity, race, sex, age_group, population)
}

all_population_data_2000_2010 <- map(population_data_urls, read_population_data) %>%
  map_dfr(process_population_data) %>%
  arrange(year, state, county)

write_tsv(all_population_data_2000_2010, file.path("data", "processed", "county-population-data-2000-2010.tsv"))

state_population_data_2000_2010 <- all_population_data_2000_2010 %>%
  group_by(year, state, ethnicity, race, sex, age_group) %>%
  summarize(population = sum(population)) %>%
  left_join(state_fips, by = "state") %>%
  select(year, state_code, state, everything())

write_tsv(state_population_data_2000_2010, file.path("data", "processed", "state-population-data-2000-2010.tsv"))
