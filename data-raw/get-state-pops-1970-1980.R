library(tidyverse)

# Source: https://www.census.gov/data/datasets/time-series/demo/popest/1970s-state.html
# The link on this page is broken, but you can recover the correct link by changing the path
# from "1990-2000" to "1970-1980". The corrected url is defined here as `source_file`.

cat("Getting state population data for 1970 to 1980 ... ")

target_file <- file.path("data-raw", "messy-state-pops-1970-1980.txt")
if (!file.exists(target_file)) {
  source_file <- "https://www2.census.gov/programs-surveys/popest/datasets/1970-1980/national/asrh/e7080sta.txt"
  download.file(source_file, target_file, quiet = TRUE)
}

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

age_group_recodes <- c(
  "0-2" = "0-4",
  "3-4" = "0-4",
  "5-13" = "5-14", 
  "14" = "5-14",
  "15" = "15-19",
  "16" = "15-19",
  "17" = "15-19",
  "18" = "15-19",
  "19" = "15-19",
  "20" = "20-24",
  "21" = "20-24",
  "22" = "20-24",
  "23" = "20-24",
  "24" = "20-24",
  "25-29" = "25-29",
  "30-34" = "30-34",
  "35-44" = "35-44",
  "45-54" = "45-54",
  "55-59" = "55-59",
  "60-61" = "60-64",
  "62-64M" = "60-64",
  "62-64F" = "60-64",
  "65+" = "65+"
)

state_fips <- read_tsv(file.path("data-raw", "state-fips.tsv"), col_types = cols())

read_table(target_file, skip = 13, col_types = cols(), progress = FALSE) %>%
  rename(state_code = Fip, age_group = Age) %>%
  gather(year, pop, -state_code, -age_group) %>%
  mutate(state_code = sprintf("%02s", str_sub(state_code, start = 1, end = -4)),
         year = recode(year, !!! year_codes),
         age_group = fct_relevel(recode(age_group, !!! age_group_recodes), 
                                 unique(!! age_group_recodes))) %>%
  left_join(state_fips, by = "state_code") %>%
  group_by(year, state, age_group) %>%
  summarize(pop = sum(pop)) %>%
  ungroup() %>%
  arrange(year, state, age_group) %>%
  write_tsv(file.path("data-raw", "state-pops-1970-1980.tsv"))

cat("Done.\n")
