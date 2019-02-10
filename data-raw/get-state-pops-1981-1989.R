library(tidyverse)

# Source: https://www.census.gov/data/datasets/time-series/demo/popest/1980s-state.html
# README: https://www2.census.gov/programs-surveys/popest/technical-documentation/file-layouts/1980-1990/st_int_asrh_doc.txt

cat("Getting U.S. Census Bureau population estimates by state (1981-1989) ... ")

source_file <- "https://www2.census.gov/programs-surveys/popest/datasets/1980-1990/state/asrh/st_int_asrh.txt"
target_file <- file.path("data-raw", "messy-state-pops-1981-1989.txt")
download.file(source_file, target_file, quiet = TRUE)

age_groups <- c("0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39", "40-44", 
                "45-49", "50-54", "55-59", "60-64", "65-69", "70-74", "75-79", "80-84", "85+")

year_codes <- list(
  "1" = 1981,
  "2" = 1982,
  "3" = 1983,
  "4" = 1984,
  "5" = 1985,
  "6" = 1986,
  "7" = 1987,
  "8" = 1988,
  "9" = 1989
)

sex_codes <- list(
  "1" = "Male",
  "2" = "Female"
)

race_hispanic_origin_codes <- list(
  "1" = "White, Non-Hispanic",
  "2" = "Black, Non-Hispanic",
  "3" = "American Indian or Alaska Native, Non-Hispanic",
  "4" = "Asian or Pacific Islander, Non-Hispanic",
  "5" = "White, Hispanic",
  "6" = "Black, Hispanic",
  "7" = "American Indian or Alaska Native, Hispanic",
  "8" = "Asian or Pacific Islander, Hispanic"
)

state_fips <- read_tsv(file.path("data-raw", "state-fips.tsv"), col_types = cols())

messy_state_pops <- read_table(target_file, col_names = c("record_code", age_groups), 
                               col_types = cols(), progress = FALSE)

decoded_records <- messy_state_pops %>%
  pull(record_code) %>%
  str_split("", n = 5, simplify = TRUE) %>%
  magrittr::set_colnames(c("state_code_1", "state_code_2", "year", "race_hispanic_origin", "sex")) %>%
  as_tibble() %>%
  unite(state_code, state_code_1, state_code_2, sep = "") %>%
  mutate(year = recode(year, !!! year_codes),
         race_hispanic_origin = recode(race_hispanic_origin, !!! race_hispanic_origin_codes),
         sex = recode(sex, !!! sex_codes),
         record_code = pull(messy_state_pops, record_code)) %>%
  separate(race_hispanic_origin, c("race", "hispanic_origin"), sep = ", ") %>%
  select(record_code, everything()) %>%
  left_join(state_fips, by = "state_code")

messy_state_pops %>%
  gather(age_group, pop, -record_code) %>%
  left_join(decoded_records, by = "record_code") %>%
  mutate(age_group = fct_relevel(age_group, !! age_groups)) %>%
  select(year, state, hispanic_origin, race, sex, age_group, pop, -record_code, -state_code) %>%
  arrange(year, state, hispanic_origin, race, sex, age_group) %>%
  write_tsv(file.path("data-raw", "tidy-state-pops-1981-1989.tsv"))

cat("Done.\n")