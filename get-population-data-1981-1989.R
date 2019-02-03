library(tidyverse)

# Source: https://www.census.gov/data/datasets/time-series/demo/popest/1980s-state.html
# README: https://www2.census.gov/programs-surveys/popest/technical-documentation/file-layouts/1980-1990/st_int_asrh_doc.txt

source_file <- "https://www2.census.gov/programs-surveys/popest/datasets/1980-1990/state/asrh/st_int_asrh.txt"
target_file <- file.path("data", "raw", "st_int_asrh.txt")
download.file(source_file, target_file)

age_groups <- c("0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39", "40-44", 
                "45-49", "50-54", "55-59", "60-64", "65-69", "70-74", "75-79", "80-84", "85+")

population_data_1981_1989 <- read_table(target_file, col_names = c("record_code", age_groups))

state_fips <- read_tsv(file.path("data", "processed", "state-fips.tsv"))

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

race_ethnic_origin_codes <- list(
  "1" = "White, non-Hispanic",
  "2" = "Black, non-Hispanic",
  "3" = "American Indian or Alaska Native, non-Hispanic",
  "4" = "Asian or Pacific Islander, non-Hispanic",
  "5" = "White, Hispanic",
  "6" = "Black, Hispanic",
  "7" = "American Indian or Alaska Native, Hispanic",
  "8" = "Asian or Pacific Islander, Hispanic"
)


decoded_record_data <- population_data_1981_1989 %>%
  pull(record_code) %>%
  str_split("", n = 5, simplify = TRUE) %>%
  as.tibble() %>%
  magrittr::set_colnames(c("state_code_1", "state_code_2", "year", "race_ethnic_origin", "sex")) %>%
  unite(state_code, state_code_1, state_code_2, sep = "") %>%
  mutate(year = recode(year, !!! year_codes),
         race_ethnic_origin = recode(race_ethnic_origin, !!! race_ethnic_origin_codes),
         sex = recode(sex, !!! sex_codes),
         record_code = pull(pop, record_code)) %>%
  select(record_code, everything()) %>%
  left_join(state_fips, by = "state_code")

all_population_data_1981_1989 <- population_data_1981_1989 %>%
  gather(age_group, population, -record_code) %>%
  left_join(decoded_record_data, by = "record_code") %>%
  select(year, state_code, state, race_ethnic_origin, sex, age_group, everything(), -record_code)
  
write_tsv(all_population_data_1981_1989, file.path("data", "processed", "population-data-1981-1989.tsv"))
