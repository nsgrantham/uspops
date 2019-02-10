library(tidyverse)

cat("Getting U.S. Census Bureau population estimates by county (1990-1999) ... \n")

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

county_fips <- read_tsv(file.path("data-raw", "county-fips.tsv"), col_types = cols(), progress = FALSE)

tidy_up_county_pops <- function(county_pops_url) {
  read_table(county_pops_url, col_types = cols(), progress = FALSE,
             col_names = c("year", "county_code", "age_group", 
                           "race_sex", "hispanic_origin", "pop")) %>%
    mutate(year = recode(year, !!! year_codes),
           age_group = fct_relevel(recode(age_group, !!! age_group_codes), !! age_group_codes),
           race_sex = recode(race_sex, !!! race_sex_codes),
           hispanic_origin = recode(hispanic_origin, !!! hispanic_origin_codes)) %>%
    separate(race_sex, c("race", "sex"), sep = ", ") %>%
    left_join(county_fips, by = "county_code") %>%
    select(year, state, county, hispanic_origin, race, sex, age_group, pop)
}

paste0("https://www2.census.gov/programs-surveys/popest/tables/1990-2000/intercensal/st-co/stch-icen",
       unlist(year_codes), ".txt") %>%
  set_names(unlist(year_codes)) %>%
  imap_dfr(function(url, year) {
    cat(paste("  Tidying data from", year, "... "))
    county_pops <- tidy_up_county_pops(url)
    cat("Done.\n")
    county_pops
  }) %>%
  arrange(year, state, county, hispanic_origin, race, sex, age_group) %>%
  write_tsv(file.path("data-raw", "tidy-county-pops-1990-1999.tsv"))

cat("Done.\n")
