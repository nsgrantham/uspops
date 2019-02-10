library(tidyverse)

cat("Getting U.S. Census Bureau population estimates by county (2011-2017) ...\n")

county_fips <- read_tsv(file.path("data-raw", "county-fips.tsv"), col_types = cols())

year_codes <- list(
  "3" = 2011,
  "4" = 2012,
  "5" = 2013,
  "6" = 2014,
  "7" = 2015,
  "8" = 2016,
  "9" = 2017
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

tidy_up_county_pops <- function(url) {
  read_csv(url, col_types = cols(), progress = FALSE) %>%
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
    filter(year %in% 3:9) %>%  # guessing that these codes correspond to 2011, ..., 2017
    gather(hispanic_origin_race_sex, pop, -state, -county, -year, -age_group) %>%
    mutate(year = recode(year, !!! year_codes),
           age_group = fct_relevel(recode(age_group, !!! age_group_codes), !! age_group_codes)) %>%
    separate(hispanic_origin_race_sex, c("hispanic_origin", "race", "sex"), sep = ", ") %>% 
    left_join(county_fips, by = c("state", "county")) %>%
    select(year, state, county, hispanic_origin, race, sex, age_group, pop)
}

state_fips_except_puerto_rico <- read_tsv(file.path("data-raw", "state-fips.tsv"), col_types = cols()) %>%
  filter(state != "Puerto Rico")

paste0("https://www2.census.gov/programs-surveys/popest/datasets/2010-2017/counties/asrh/cc-est2017-alldata-", 
       pull(state_fips_except_puerto_rico, state_code), ".csv") %>%
  set_names(pull(state_fips_except_puerto_rico, state)) %>%
  imap_dfr(function(url, state) {
    cat("  Tidying", state, "counties ... ")
    county_pops <- tidy_up_county_pops(url)
    cat("Done.\n")
    county_pops
  }) %>%
  arrange(year, state, county, hispanic_origin, race, sex, age_group) %>%
  write_tsv(file.path("data-raw", "tidy-county-pops-2011-2017.tsv"))

cat("Done.")
