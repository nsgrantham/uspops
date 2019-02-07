library(tidyverse)

# Source: https://www.census.gov/data/datasets/time-series/demo/popest/1970s-state.html
# The link on this page is broken, but you can recover the correct link by changing the path
# from "1990-2000" to "1970-1980". The corrected url is defined in source_file.

source_file <- "https://www2.census.gov/programs-surveys/popest/datasets/1970-1980/national/asrh/e7080sta.txt"
target_file <- file.path("data", "raw", "e7080sta.txt")
download.file(source_file, target_file)

messy_state_population_data <- read_table(target_file, skip = 13)

state_fips <- read_tsv(file.path("data", "processed", "state-fips.tsv"))

year_codes <- list(
  "4/1/70" = 1970,
  "7/1/71" = 1971,
  "7/1/72" = 1972,
  "7/1/73" = 1973,
  "7/1/74" = 1974,
  "7/1/75" = 1975,
  "7/1/76" = 1976,
  "7/1/77" = 1977,
  "7/1/78" = 1978,
  "7/1/79" = 1979,
  "4/1/80" = 1980
)


tidy_state_population_data <- messy_state_population_data %>%
  rename(state_code = Fip, age_group = Age) %>%
  gather(year, population, -state_code, -age_group) %>%
  mutate(state_code = sprintf("%02s", str_sub(state_code, start = 1, end = -4)),
         year = recode(year, !!! year_codes),
         age_group = recode(age_group, "62-64M" = "62-64", "62-64F" = "62-64")) %>%
  left_join(state_fips, by = "state_code") %>%
  group_by(year, state, age_group) %>%
  summarize(population = sum(population)) %>%
  ungroup() %>%
  arrange(year, state, age_group)

write_tsv(tidy_state_population_data, file.path("data", "processed", "state-population-data-1970-1980.tsv"))
