library(tidyverse)

source(file.path("data-raw", "get-fips-codes.R"))
source(file.path("data-raw", "get-state-pops-1970-1980.R"))
source(file.path("data-raw", "get-state-pops-1981-1989.R"))
source(file.path("data-raw", "get-county-pops-1990-1999.R"))
source(file.path("data-raw", "get-state-pops-1990-1999.R"))
source(file.path("data-raw", "get-county-pops-2000-2010.R"))
source(file.path("data-raw", "get-state-pops-2000-2010.R"))
source(file.path("data-raw", "get-county-pops-2011-2017.R"))
source(file.path("data-raw", "get-state-pops-2011-2017.R"))

col_types <- list(
  year = col_integer(),
  state = col_character(),
  county = col_character(),
  hispanic_origin = col_character(),
  race = col_character(),
  sex = col_character(),
  age_group = col_character(),
  pop = col_integer()
)

cat("Combining all state population datasets and saving as 'statepops' ...\n")

statepops <- file.path("data-raw", c("state-pops-1970-1980.tsv", "state-pops-1981-1989.tsv",
                                     "state-pops-1990-1999.tsv", "state-pops-2000-2010.tsv",
                                     "state-pops-2011-2017.tsv")) %>% 
  map_dfr(function(file) suppressWarnings(read_tsv(file, col_types = col_types, progress = FALSE))) %>%
  select(year, state, hispanic_origin, race, sex, age_group, pop)

save(statepops, file = file.path("data", "statepops.rda"))

cat("Done. Load the dataset with 'data(statepops)'.\n")

cat("Combining all county population datasets and saving as 'countypops' ...\n")
  
countypops <- file.path("data-raw", c("county-pops-1990-1999.tsv", "county-pops-2000-2010.tsv",
                                      "county-pops-2011-2017.tsv")) %>% 
  map_dfr(function(file) read_tsv(file, col_types = col_types, progress = FALSE)) %>%
  select(year, state, hispanic_origin, race, sex, age_group, pop)

save(countypops, file = file.path("data", "countypops.rda"))

cat("Done. Load the dataset with 'data(countypops)'.\n")
