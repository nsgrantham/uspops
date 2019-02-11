library(tidyverse)
library(readxl)

cat("Getting FIPS codes for states and counties ... ")

target_file <- file.path("data-raw", "all-fips-codes-2017.xlsx")
if (!file.exists(target_file)) {
  source_file <- "https://www2.census.gov/programs-surveys/popest/geographies/2017/all-geocodes-v2017.xlsx"
  download.file(source_file, target_file, quiet = TRUE)
}

current_fips_2017 <- read_xlsx(target_file, skip = 4)

state_fips <- current_fips_2017 %>%
  filter(`Summary Level` == "040") %>%
  select(state_code = `State Code (FIPS)`,
         state = `Area Name (including legal/statistical area description)`) %>%
  arrange(state_code) %>%
  write_tsv(file.path("data-raw", "state-fips.tsv"))

# Add several more counties which are not included in the 
# 2017 dataset because they are no longer in use.
retired_fips <- tribble(
  ~county_code, ~state, ~county,
  "02201", "Alaska", "Prince of Wales-Outer Ketchikan Census Area",
  "02232", "Alaska", "Skagway-Hoonah-Angoon Census Area",
  "02270", "Alaska", "Wade Hampton Census Area",
  "02280", "Alaska", "Wrangell-Petersburg Census Area",
  "46113", "South Dakota", "Shannon County",
  "51515", "Virginia", "Bedford City",
  "51560", "Virginia", "Clifton Forge County"
)

current_fips_2017 %>%
  filter(`Summary Level` == "050") %>%
  select(state_code = `State Code (FIPS)`,
         nonunique_county_code = `County Code (FIPS)`,  # different states may share county codes
         county = `Area Name (including legal/statistical area description)`) %>%
  left_join(state_fips, by = "state_code") %>%
  unite("county_code", state_code, nonunique_county_code, sep = "") %>%  # combine with state code to create unique county code
  select(county_code, state, county) %>%
  bind_rows(retired_fips) %>%
  arrange(county_code) %>%
  write_tsv(file.path("data-raw", "county-fips.tsv"))


cat("Done.\n")
