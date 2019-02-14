library(tidyverse)

source(file.path("data-raw", "get-fips-codes.R"))
source(file.path("data-raw", "get-data-1980-1989.R"))
source(file.path("data-raw", "get-data-1990-1999.R"))
source(file.path("data-raw", "get-data-2000-2009.R"))
source(file.path("data-raw", "get-data-2010-2018.R"))

ages <- c("0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39", "40-44",
          "45-49", "50-54", "55-59", "60-64", "65-69", "70-74", "75-79", "80-84", "85+")

col_types <- list(
  year = col_date(format = "%Y"),
  state = col_character(),
  county = col_character(),
  origin = col_character(),
  race = col_character(),
  sex = col_character(),
  age = col_factor(levels = ages, ordered = TRUE),
  pop = col_integer()
)

cat("Combining all county population data and saving as 'county_pops' ...\n")

county_pops <- file.path("data-raw", c("county-pops-1980-1989.tsv", "county-pops-1990-1999.tsv",
                                       "county-pops-2000-2009.tsv", "county-pops-2010-2018.tsv")) %>% 
  map_dfr(function(file) suppressWarnings(read_tsv(file, col_types = col_types, progress = FALSE))) %>%
  select(year, state, origin, race, sex, age, pop)

save(county_pops, file = file.path("data", "county_pops.rda"))

cat("Done. Load the dataset with 'data(county_pops)'.\n")

cat("Calculating state population data and saving as 'state_pops' ... ")

state_pops <- county_pops %>%
  group_by(year, state, origin, race, sex, age) %>%
  summarize(pop = sum(pop))

save(state_pops, file = file.path("data", "state_pops.rda"))

cat("Done. Load the dataset with 'data(state_pops)'.\n")

cat("Calculating national population data and saving as 'us_pops' ... ")

us_pops <- state_pops %>%
  group_by(year, origin, race, sex, age) %>%
  summarize(pop = sum(pop))

save(us_pops, file = file.path("data", "us_pops.rda"))

cat("Done. Load the dataset with 'data(us_pops)'.\n")
