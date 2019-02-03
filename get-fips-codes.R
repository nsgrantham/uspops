library(tidyverse)
library(readxl)

source_file <- "https://www2.census.gov/programs-surveys/popest/geographies/2016/all-geocodes-v2016.xlsx"
target_file <- file.path("data", "raw", "all-geocodes-v2016.xlsx")
download.file(source_file, target_file)

retired_fips <- tribble(
  ~state_county_code, ~state, ~county,
  "02201", "Alaska", "Prince of Wales-Outer Ketchikan Census Area",
  "02232", "Alaska", "Skagway-Hoonah-Angoon Census Area",
  "02270", "Alaska", "Wade Hampton Census Area",
  "02280", "Alaska", "Wrangell-Petersburg Census Area",
  "46113", "South Dakota", "Shannon County",
  "51515", "Virginia", "Bedford City",
  "51560", "Virginia", "Clifton Forge County"
)

all_fips_2016 <- read_xlsx(target_file, skip = 4)

state_fips <- all_fips_2016 %>%
  filter(`Summary Level` == "040") %>%
  select(state_code = `State Code (FIPS)`,
         state = `Area Name (including legal/statistical area description)`)

write_tsv(state_fips, file.path("data", "processed", "state-fips.tsv"))

state_county_fips <- all_fips_2016 %>%
  filter(`Summary Level` == "050") %>%
  select(state_code = `State Code (FIPS)`, county_code = `County Code (FIPS)`,
         county = `Area Name (including legal/statistical area description)`) %>%
  left_join(state_fips, by = "state_code") %>%
  unite("state_county_code", state_code, county_code, sep = "") %>%
  select(state_county_code, state, county) %>%
  bind_rows(retired_fips)

write_tsv(state_county_fips, file.path("data", "processed", "state-county-fips.tsv"))
