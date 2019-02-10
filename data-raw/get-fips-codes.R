library(tidyverse)
library(readxl)

cat("Getting U.S. FIPS codes for states and counties ... ")

source_file <- "https://www2.census.gov/programs-surveys/popest/geographies/2016/all-geocodes-v2016.xlsx"
target_file <- file.path("data-raw", "all-fips-codes-2016.xlsx")
download.file(source_file, target_file, quiet = TRUE)

all_fips_2016 <- read_xlsx(target_file, skip = 4)

state_fips <- all_fips_2016 %>%
  filter(`Summary Level` == "040") %>%
  select(state_code = `State Code (FIPS)`,
         state = `Area Name (including legal/statistical area description)`) %>%
  write_tsv(file.path("data-raw", "state-fips.tsv"))

# Add several more counties which are not included in the 
# 2016 dataset because they are no longer in use.
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

all_fips_2016 %>%
  filter(`Summary Level` == "050") %>%
  select(state_code = `State Code (FIPS)`,
         nonunique_county_code = `County Code (FIPS)`,  # different states may share county codes
         county = `Area Name (including legal/statistical area description)`) %>%
  left_join(state_fips, by = "state_code") %>%
  unite("county_code", state_code, nonunique_county_code, sep = "") %>%  # combine with state code to create unique county code
  select(county_code, state, county) %>%
  bind_rows(retired_fips) %>%
  write_tsv(file.path("data-raw", "county-fips.tsv"))

rm(all_fips_2016, state_fips)

cat("Done.\n")
