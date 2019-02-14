library(tidyverse)

cat("Getting county population data for 2000-2009 ...\n")

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
  "11" = 2009
)

# age codes 0 and 1 actually correspond to ages 0 and 1-4, respectively, 
# but give them the 0-4 grouping for uniformity with data from 1980-1989
age_codes <- list(
  "0" = "0-4",
  "1" = "0-4",
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

county_fips <- read_tsv(file.path("data-raw", "county-fips.tsv"), col_types = cols(), progress = FALSE)

tidy_up_county_pops <- function(county_pops_url) {
  read_csv(county_pops_url, col_types = cols(), progress = FALSE) %>%
    select(state = STNAME, county = CTYNAME, year = YEAR, age = AGEGRP,
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
    filter(year %in% 2:11, age != 99) %>%
    gather(origin_race_sex, pop, -state, -county, -year, -age) %>%
    mutate(year = recode(year, !!! year_codes),
           age = fct_relevel(recode(age, !!! age_codes), unique(!! age_codes))) %>%
    separate(origin_race_sex, c("origin", "race", "sex"), sep = ", ") %>% 
    group_by(year, state, county, origin, race, sex, age) %>%
    mutate(pop = sum(pop)) %>%
    ungroup()
}

state_fips_except_puerto_rico <- read_tsv(file.path("data-raw", "state-fips.tsv"), col_types = cols()) %>%
  filter(state != "Puerto Rico")

get_county_pops_url <- function(state_code) {
  glue::glue("https://www2.census.gov/programs-surveys/popest/datasets/2000-2010/intercensal/county/co-est00int-alldata-{state_code}.csv")
}

get_county_pops_url(pull(state_fips_except_puerto_rico, state_code)) %>%
  set_names(pull(state_fips_except_puerto_rico, state)) %>%
  imap_dfr(function(url, state) {
    cat(paste("+ Getting data for", state, "... "))
    county_pops <- tidy_up_county_pops(url)
    cat("Done.\n")
    county_pops
  }) %>%
  arrange(year, state, county, origin, race, sex, age) %>%
  write_tsv(file.path("data-raw", "county-pops-2000-2009.tsv"))

cat("Done.\n")
