library(tidyverse)

cat("Getting county population data for 1980-1989 ... ")

age_codes <- list(
  "Under 5 years" = "0-4",
  "5 to 9 years" = "5-9",
  "10 to 14 years" = "10-14",
  "15 to 19 years" = "15-19",
  "20 to 24 years" = "20-24",
  "25 to 29 years" = "25-29",
  "30 to 34 years" = "30-34",
  "35 to 39 years" = "35-39",
  "40 to 44 years" = "45-49",
  "50 to 54 years" = "50-54",
  "55 to 59 years" = "55-59",
  "60 to 64 years" = "60-64",
  "65 to 69 years" = "65-69",
  "70 to 74 years" = "70-74",
  "75 to 79 years" = "75-79",
  "80 to 84 years" = "80-84",
  "85 years and over" = "85+"
)

race_sex_codes <- list(
  "White male" = "White, Male",
  "White female" = "White, Female",
  "Black male" = "Black, Male",
  "Black female" = "Black, Female",
  "Other races male" = "Other Race, Male",
  "Other races female" = "Other Race, Female"
)

county_fips <- read_tsv(file.path("data-raw", "county-fips.tsv"), col_types = cols(), progress = FALSE)

read_csv("https://www2.census.gov/programs-surveys/popest/datasets/1980-1990/counties/asrh/pe-02.csv", 
          col_types = cols(), progress = FALSE, skip = 5) %>%
  slice(-1) %>%
  rename(year = `Year of Estimate`, county_code = `FIPS State and County Codes`,
         race_sex = `Race/Sex Indicator`) %>%
  gather(age, pop, -year, -county_code, -race_sex) %>%
  mutate(county_code = sprintf("%05d", county_code),
         race_sex = recode(race_sex, !!! race_sex_codes),
         age = fct_relevel(recode(age, !!! age_codes), !! age_codes)) %>%
  separate(race_sex, c("race", "sex"), sep = ", ") %>%
  left_join(county_fips, by = "county_code") %>%
  select(year, state, county, race, sex, age, pop) %>%
  arrange(year, state, county, race, sex, age) %>%
  write_tsv(file.path("data-raw", "county-pops-1980-1989.tsv"))

cat("Done.\n")
